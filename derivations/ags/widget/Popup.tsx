import { App, Astal, Gdk, Gtk, Widget } from 'astal/gtk3';

type PaddingProps = { winName: string };
type Position = 'top_center' | 'top_right' | 'center';
interface LayoutProps {
	name: string;
	position: Position;
	child?: JSX.Element;
}
interface PopupWindowProps extends Widget.WindowProps {
	name: string;
	layout: Position;
}

function Padding({ winName }: PaddingProps) {
	return (
		<eventbox
			onClickRelease={(_, event) => {
				if (event.button == Gdk.BUTTON_PRIMARY) {
					App.toggle_window(winName);
				}
			}}
			vexpand
			hexpand
		/>
	);
}

function Layout({ child, name, position }: LayoutProps) {
	switch (position) {
		case 'top_center':
			return (
				<box>
					<Padding winName={name} />
					<box vertical hexpand={false}>
						{child}
						<Padding winName={name} />
					</box>
					<Padding winName={name} />
				</box>
			);
		case 'top_right':
			return (
				<box>
					<Padding winName={name} />
					<box vertical hexpand={false}>
						{child}
						<Padding winName={name} />
					</box>
				</box>
			);
		//default to center
		default:
			return (
				<centerbox>
					<Padding winName={name} />
					<centerbox orientation={Gtk.Orientation.VERTICAL}>
						<Padding winName={name} />
						{child}
						<Padding winName={name} />
					</centerbox>
					<Padding winName={name} />
				</centerbox>
			);
	}
}

export default function PopupWindow({
	child,
	name,
	layout,
	...props
}: PopupWindowProps) {
	const { TOP, RIGHT, BOTTOM, LEFT } = Astal.WindowAnchor;
	return (
		<window
			name={name}
			namespace={name}
			layer={Astal.Layer.OVERLAY}
			keymode={Astal.Keymode.EXCLUSIVE}
			application={App}
			anchor={TOP | BOTTOM | RIGHT | LEFT}
			onKeyPressEvent={(_, event: Gdk.Event) => {
				if (event.get_keyval()[1] === Gdk.KEY_Escape) {
					App.toggle_window(name);
				}
			}}
			{...props}
		>
			<Layout name={name} position={layout}>
				{child}
			</Layout>
		</window>
	);
}
