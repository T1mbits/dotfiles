import Battery from 'gi://AstalBattery';
import Brightness from '../services/brightness';
import Cava from 'gi://AstalCava';
import Hyprland from 'gi://AstalHyprland';
import Network from 'gi://AstalNetwork';
import Mpris from 'gi://AstalMpris';
import Notifd from 'gi://AstalNotifd';
import Tray from 'gi://AstalTray';
import WirePlumber from 'gi://AstalWp';
import { bind, GLib, Variable } from 'astal';
import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import icons from '../lib/icons';

const { EXCLUSIVE } = Astal.Exclusivity;
const { PRIMARY, SECONDARY } = Astal.MouseButton;
const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
const { NORTH, SOUTH } = Gdk.Gravity;
const { START, END } = Gtk.Align;

const hyprland = Hyprland.get_default();

function SysTray() {
	const tray = Tray.get_default();

	return (
		<box className="tray" spacing={6}>
			{bind(tray, 'items').as((items) =>
				items.map((item) => (
					<menubutton
						tooltipMarkup={bind(item, 'tooltipMarkup')}
						usePopover={false}
						actionGroup={bind(item, 'actionGroup').as((ag) => [
							'dbusmenu',
							ag,
						])}
						menuModel={bind(item, 'menu_model')}
						className="tray-item"
					>
						<icon gicon={bind(item, 'gicon')} />
					</menubutton>
				))
			)}
		</box>
	);

	// return (
	// 	<box className="tray">
	// 		{bind(tray, 'items').as((items) =>
	// 			items.map((item) => {
	// 				if (item.iconThemePath) App.add_icons(item.iconThemePath);

	// 				const menu = item.create_menu();

	// 				return (
	// 					<button
	// 						className="tray-item"
	// 						tooltipMarkup={bind(item, 'tooltipMarkup')}
	// 						onDestroy={() => menu?.destroy()}
	// 						onClickRelease={(self, { button, x, y }) => {
	// 							switch (button) {
	// 								case PRIMARY:
	// 									item.activate(x, y);
	// 									break;
	// 								case SECONDARY:
	// 									menu?.popup_at_widget(
	// 										self,
	// 										SOUTH,
	// 										NORTH,
	// 										null
	// 									);
	// 									break;
	// 							}
	// 						}}
	// 					>
	// 						<icon gIcon={bind(item, 'gicon')} />
	// 					</button>
	// 				);
	// 			})
	// 		)}
	// 	</box>
	// );
}

interface WorkspacesProps {
	gdkmonitor: Gdk.Monitor;
}
function Workspaces({ gdkmonitor }: WorkspacesProps) {
	return (
		<box className="workspaces">
			{bind(hyprland, 'workspaces').as((workspace) =>
				workspace
					.sort((a, b) => a.id - b.id)
					.map((workspace) => {
						return (
							<button
								className={bind(
									hyprland,
									'focusedWorkspace'
								).as((fw) =>
									workspace === fw ? 'focused' : ''
								)}
								onClicked={() => workspace.focus()}
								tooltipText={workspace.id.toString()}
							>
								{/* {fw.as((fw) =>
									workspace === fw ? workspace.id : ''
								)} */}
								{/* {workspace.id} */}
							</button>
						);
					})
			)}
		</box>
	);
}

function ActiveClient() {
	const focused = bind(hyprland, 'focusedClient');

	return (
		<box className="title">
			{focused.as((client) => (
				<label
					label={
						client
							? bind(client, 'title').as(String)
							: bind(hyprland, 'focusedWorkspace').as(
									({ id }) => `Workspace ${id}`
							  )
					}
					tooltipText={
						client
							? bind(client, 'title')
							: bind(hyprland, 'focusedWorkspace').as(
									({ id }) => `Workspace ${id}`
							  )
					}
					truncate
					maxWidthChars={35}
				/>
			))}
		</box>
	);
}

function AudioVisualizer() {
	const cava = Cava.get_default();
	cava?.set_bars(12);

	const bars = Variable('');
	const blocks = [
		'\u2581',
		'\u2582',
		'\u2583',
		'\u2584',
		'\u2585',
		'\u2586',
		'\u2587',
		'\u2588',
	];

	cava?.connect('notify::values', () => {
		let b = '';
		cava.get_values().map(
			(val) =>
				(b += blocks[Math.min(Math.floor(val * 8), blocks.length - 1)])
		);
		bars.set(b);
	});

	return (
		<box className={'audio-visualizer'} onDestroy={() => cava?.disconnect}>
			<label onDestroy={() => bars.drop()} label={bind(bars)} />
		</box>
	);
}

function NotificationIndicator() {
	type PackageUpdates = { aur: number; repo: number };

	// const packageUpdates = dependencies('yay')
	// 	? Variable<PackageUpdates>({ aur: 0, repo: 0 }).poll(
	// 			60000,
	// 			[
	// 				'bash',
	// 				'-c',
	// 				'yay -Qu --aur --quiet | wc -l && yay -Qu --repo --quiet | wc -l',
	// 			],
	// 			(out, _) => {
	// 				let packageCount = out.split('\n');
	// 				return {
	// 					aur: parseInt(packageCount[0]),
	// 					repo: parseInt(packageCount[1]),
	// 				};
	// 			}
	// 	  )
	// 	: Variable<PackageUpdates>({ aur: 0, repo: 0 });

	// function PackageUpdatesIndicator() {
	// 	return (
	// 		<icon
	// 			visible={bind(packageUpdates).as(
	// 				({ aur, repo }) => aur + repo != 0
	// 			)}
	// 			tooltipText={bind(packageUpdates).as(({ aur, repo }) => {
	// 				let r =
	// 					repo > 0
	// 						? `${repo} package${
	// 								repo > 1 ? 's' : ''
	// 						  } from Arch Repositories`
	// 						: '';
	// 				let a =
	// 					aur > 0
	// 						? `${aur} package${aur > 1 ? 's' : ''} from AUR`
	// 						: '';
	// 				return `${r}${r && a ? '\n' : ''}${a}`;
	// 			})}
	// 			onDestroy={() => packageUpdates.drop()}
	// 			icon={icons.package}
	// 		/>
	// 	);
	// }

	function Notifications() {
		const notifd = Notifd.get_default();
		const dnd = bind(notifd, 'dontDisturb');
		const notifications = bind(notifd, 'notifications');

		return (
			<box
				tooltipText={notifications.as(
					({ length }) =>
						`${length} notification${length != 1 ? 's' : ''}`
				)}
			>
				{dnd.as((dnd) => (
					<icon
						icon={
							dnd
								? icons.notification.silent
								: notifications.as(({ length }) =>
										length > 0
											? icons.notification.active
											: icons.notification.inactive
								  )
						}
					/>
				))}
			</box>
		);
	}

	return (
		<box
			className={'notification-indicator'}
			// spacing={bind(packageUpdates).as(({ aur, repo }) =>
			// 	aur + repo == 0 ? 0 : 4
			// )}
		>
			{/* {PackageUpdatesIndicator()} */}
			{Notifications()}
		</box>
	);
}

function Media() {
	// const mpris = Mpris.get_default();
	const spotify = Mpris.Player.new('spotify_player');

	return (
		<box className="Media">
			{/* {bind(mpris, 'players').as((ps) =>
				ps[0] ? (
					<box> */}
			{/* <icon icon={bind(ps[0], 'coverArt')} /> */}
			<icon icon="spotify" />
			<label
				label={bind(spotify, 'title').as(
					() => `${spotify.title} - ${spotify.artist}`
				)}
			/>
			{/* </box>
				) : (
					'Nothing Playing'
				)
			)} */}
		</box>
	);
}

function SystemStatus() {
	function NetworkingIndicator() {
		const network = Network.get_default();

		return (
			<icon
				icon={bind(network.wifi, 'iconName')}
				tooltipText={bind(network.wifi, 'ssid').as(
					(ssid) => ssid || 'Unknown'
				)}
			/>
		);
	}

	function AudioIndicator() {
		const wirePlumber = WirePlumber.get_default()?.defaultSpeaker;
		if (wirePlumber === undefined) return;

		return (
			<icon
				icon={bind(wirePlumber, 'volumeIcon')}
				tooltipText={bind(wirePlumber, 'volume').as(
					(volume) => `${Math.floor(volume * 100)}%`
				)}
			/>
		);
	}

	function BrightnessIndicator() {
		const brightness = Brightness.get_default();

		return (
			<icon
				icon={icons.brightness}
				tooltipText={bind(brightness, 'screen').as(
					(brightness) => `${brightness * 100}%`
				)}
			/>
		);
	}

	function BatteryDisplay() {
		const battery = Battery.get_default();
		const charging = bind(battery, 'charging');
		const timeToCompletion = charging
			? bind(battery, 'timeToFull').get()
			: bind(battery, 'timeToEmpty').get();
		const timeToEmpty = bind(battery, 'timeToEmpty');

		return (
			// <box
			// 	className="battery"
			// spacing={4}
			// >
			<icon
				icon={bind(battery, 'batteryIconName')}
				visible={bind(battery, 'isPresent')}
				tooltipText={bind(battery, 'percentage').as((percent) => {
					return `${Math.floor(
						percent * 100
					)}%\nTime to empty: ${Math.floor(
						timeToEmpty.get() / 60 / 60
					)}h ${timeToEmpty.get() % 60} min`;
				})}
			/>
			// 	<label
			// 		label={bind(battery, 'percentage').as(
			// 			(p) => `${Math.floor(p * 100)}%`
			// 		)}
			// 	/>
			// </box>
		);
	}

	return (
		<box spacing={4} className={'system-status'}>
			{AudioIndicator()}
			<BrightnessIndicator />
			<NetworkingIndicator />
			<BatteryDisplay />
		</box>
	);
}

function Clock() {
	const date = Variable('').poll(
		1000,
		() => GLib.DateTime.new_now_local().format('%A, %B %-d, %Y')!
	);
	const time = Variable('').poll(
		1000,
		() => GLib.DateTime.new_now_local().format('%H:%M')!
	);

	return (
		<box
			className="clock"
			onDestroy={() => {
				time.drop();
				date.drop();
			}}
			tooltipText={date()}
		>
			{time()}
		</box>
	);
}

function Launcher() {
	return (
		<box className="launcher">
			<icon icon={icons.os.nix} />
		</box>
	);
}

let barCount = 0;
export default function Bar(gdkmonitor: Gdk.Monitor) {
	barCount++;
	return (
		<window
			className="bar"
			gdkmonitor={gdkmonitor}
			exclusivity={EXCLUSIVE}
			anchor={TOP | LEFT | RIGHT}
			name={`Bar${barCount}`}
			onDestroy={() => barCount--}
			application={App}
		>
			<centerbox>
				<box hexpand spacing={8} halign={START}>
					<Launcher />
					<SysTray />
					<ActiveClient />
				</box>
				<box>
					<Workspaces gdkmonitor={gdkmonitor} />
				</box>
				<box hexpand spacing={8} halign={END}>
					{/* {Media()} */}
					<NotificationIndicator />
					<SystemStatus />
					<Clock />
				</box>
			</centerbox>
		</window>
	);
}
