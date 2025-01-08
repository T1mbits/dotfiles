import { App, Astal, Gdk, Gtk } from 'astal/gtk3';
import PopupWindow from './Popup';
import Apps from 'gi://AstalApps';
import { exec, execAsync, Variable } from 'astal';
import icons from '../lib/icons';
import { Entry } from 'astal/gtk3/widget';

function hide() {
	App.get_window('launcher')!.hide();
}

function AppButton({ app }: { app: Apps.Application }) {
	return (
		<button
			className="AppButton"
			onClicked={() => {
				hide();
				app.launch();
			}}
		>
			<box>
				<icon icon={app.iconName ?? icons.fallback.executable} />
				<box valign={Gtk.Align.CENTER} vertical>
					<label
						className="name"
						truncate
						xalign={0}
						label={app.name}
					/>
					{app.description && (
						<label
							className="description"
							wrap
							xalign={0}
							label={app.description}
						/>
					)}
				</box>
			</box>
		</button>
	);
}

export default function Applauncher() {
	const { CENTER } = Gtk.Align;
	const apps = new Apps.Apps();

	const text = Variable('');
	const prefix = text((text) => text.charAt(0));
	const root = text((text) => text.slice(1));

	const list = text((text) => apps.fuzzy_query(text));
	const onChange = (self: Entry) => {
		text.set(self.text);

		switch (prefix.get()) {
			case '~':
				execAsync(`sh -c "fd -HE .git ${root.get()} $HOME"`)
					.then((out) => print(`fd output: ${out}`))
					.catch((err) => printerr(`fd error: ${err}`));
				break;
		}
	};
	const onEnter = () => {
		switch (prefix.get()) {
			// case '$':
			// 	execAsync(
			// 		`sh -c "kitty --hold -d $HOME $SHELL -c 'source ~/.\${SHELL##*/}rc; ${enteredText.slice(
			// 			1
			// 		)} & disown"`
			// 	);
			// 	break;
			case '~':
				break;
			case '/':
			default:
				apps.fuzzy_query(text.get())?.[0].launch();
		}
		hide();
	};

	return (
		<PopupWindow
			name="launcher"
			layout="center"
			application={App}
			onShow={() => text.set('')}
		>
			<box widthRequest={500} className="launcher" vertical>
				<entry
					placeholderText="Search"
					text={text()}
					onChanged={onChange}
					onActivate={onEnter}
					onRealize={(self) => self.grab_focus()}
				/>
				<scrollable heightRequest={400}>
					<box
						spacing={6}
						vertical
						visible={list.as((l) => l.length > 0)}
					>
						{list.as((list) =>
							list.map((app) => <AppButton app={app} />)
						)}
					</box>
				</scrollable>
				<box
					halign={CENTER}
					className="not-found"
					vertical
					visible={list.as((l) => l.length == 0)}
				>
					<icon icon="system-search-symbolic" />
					<label label="No match found" />
				</box>
			</box>
		</PopupWindow>
	);
}
