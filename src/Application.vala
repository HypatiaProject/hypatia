/* Application.vala
 *
 * Copyright 2022 Hypatia Developers
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

namespace Hypatia {
	public class Application : Adw.Application {
		private ActionEntry[] APP_ACTIONS = {
			{ "about", on_about_action },
			{ "quit", quit }
		};

		public string search_text = "";
		public GLib.Settings settings;

		public signal void show_search_entry_requested();

		public Application () {
			Object(application_id: "com.github.HypatiaProject.hypatia", flags: ApplicationFlags.FLAGS_NONE);

			this.add_action_entries(this.APP_ACTIONS, this);
			this.set_accels_for_action("app.exit-request", {"<primary>q"});
		    this.set_accels_for_action ("app.lookup-request", {"<Ctrl>L"});

		    settings = new GLib.Settings("com.github.HypatiaProject.hypatia");

		}

		public override void activate() {
			base.activate();
			var win = this.active_window;
			if (win == null) {
				win = new Hypatia.Window(this);
			}
			win.present();
			var window = win as Hypatia.Window;
			window.search_requested.connect(on_search_requested);
			window.show_about_requested.connect(on_about_action);
			window.close_request.connect(exit_request);
		}

		private void on_about_action () {
			string[] authors = {"Nathan Dyer"};
			string[] artists = {"Nathan Dyer (Initial Design)"};
			Gtk.show_about_dialog(this.active_window,
				                  "program-name", "Hypatia",
				                  "authors", authors,
				                  "artists", artists,
				                  "copyright", "Copyright © 2022 Nathan Dyer and Hypatia Project Contributors",
				                  "version", "0.1.0");
		}

		private void on_search_requested (string term) {
		    Hypatia.Window win = (Hypatia.Window)this.active_window;
			if (win != null) {
			    var instant_answer = SearchUtility.do_search(term);
			    var dictionary_entry = SearchUtility.find_definition(term);
			    var wikipedia_entry = SearchUtility.do_wikipedia_lookup(term);
                win.set_entries(instant_answer, dictionary_entry, wikipedia_entry);
			}
		}

		private void lookup_request () {
            show_search_entry_requested();
		}

		private bool exit_request () {
            if (settings.get_boolean("run-in-background")) {
                this.active_window.hide();
            } else {
                quit();
            }

            return true;
		}
	}
}
