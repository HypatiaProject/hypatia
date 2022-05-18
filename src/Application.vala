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

		public string search_text = "";
		public GLib.Settings settings;

		public signal void show_search_entry_requested();

		private Gtk.AboutDialog about_dialog;

		public Application () {
			Object(application_id: "com.github.HypatiaProject.hypatia", flags: ApplicationFlags.FLAGS_NONE);

			ActionEntry[] action_entries = {
                { "about", this.on_about_action },
                { "quit", this.on_quit_action },
                { "toggle-search", this.on_toggle_search }
            };
            this.add_action_entries (action_entries, this);
            this.set_accels_for_action ("app.quit", {"<primary>q"});
            this.set_accels_for_action ("app.about", {"<Ctrl><Shift>a"});
            this.set_accels_for_action ("app.toggle-search", {"<primary>l"});

		    settings = new GLib.Settings("com.github.HypatiaProject.hypatia");
		}

		public override void activate() {
			base.activate();
			var win = this.active_window;
			if (win == null) {
				win = new Hypatia.Window(this);
				var window = win as Hypatia.Window;
			    window.search_requested.connect(on_search_requested);
			    window.show_about_requested.connect(on_about_action);
			    window.close_request.connect(exit_request);

			    string[] authors = {"Nathan Dyer (Initial Release and Maintainer)", "Ali Galal"};
			    string[] artists = {"Nathan Dyer (Initial Design)", "Tobias Bernard (Icon)"};
			    string[] special_thanks = {"Dos Gatos Coffee Bar in beautiful, downtown Johsnon City, TN USA"};

			    about_dialog = new Gtk.AboutDialog();
			    about_dialog.program_name = "Hypatia";
			    about_dialog.logo_icon_name = "com.github.HypatiaProject.hypatia";
			    about_dialog.authors = authors;
			    about_dialog.artists = artists;
			    about_dialog.copyright = "Copyright © 2022 Nathan Dyer and Hypatia Project Contributors";
			    about_dialog.version = "0.1.1";
			    about_dialog.add_credit_section ("Special Thanks", special_thanks);

			    about_dialog.set_transient_for (window);
			    about_dialog.modal = true;			}
			win.present();
		}

		private void on_about_action () {
			about_dialog.show();

            about_dialog.close_request.connect(() => {
                about_dialog.hide();
                return true;
            });
		}

		private void on_quit_action () {
		    exit_request();
		}

		private void on_toggle_search () {
			var window = active_window as Hypatia.Window;
			window.toggle_search();
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
