import { App, Gdk, Gtk } from 'astal/gtk3';
import style from './style/default.scss';
import Bar from './widget/Bar';
import Launcher from './widget/Launcher';

App.start({
	css: style,
	main() {
		const bars = new Map<Gdk.Monitor, Gtk.Widget>();

		// initialize
		for (const gdkmonitor of App.get_monitors()) {
			bars.set(gdkmonitor, Bar(gdkmonitor));
		}

		App.connect('monitor-added', (_, gdkmonitor) => {
			print('monitor added');
			bars.set(gdkmonitor, Bar(gdkmonitor));
		});

		App.connect('monitor-removed', (_, gdkmonitor) => {
			print('monitor removed');
			bars.get(gdkmonitor)?.destroy();
			bars.delete(gdkmonitor);
		});

		// App.get_monitors().map(Bar);
		App.get_monitors().map(Launcher);
	},
});
