/* window.vala
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
	public class Window : Adw.ApplicationWindow {

	    public signal void search_requested (string term);
	    public signal void show_about_requested ();

	    private InstantAnswersBox answers_box;
	    private DictionaryBox dictionary_box;
	    private WikipediaBox wikipedia_box;

	    private Adw.Carousel carousel;

	    private Gtk.Entry search_entry;

	    private Gtk.Button tweet_button;
	    private Gtk.Button search_term_button;

	    private Gtk.Spinner loading_spinner;

		public Window (Hypatia.Application app) {
			Object(application: app);
			
			var style_manager = Adw.StyleManager.get_default();
            style_manager.color_scheme = Adw.ColorScheme.DEFAULT;

			this.set_default_size(750, 450);

            var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);
            this.set_content(box);

            var header = new Adw.HeaderBar();
            header.get_style_context().add_class("flat");
            box.append(header);

			var title_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 12);
            header.set_title_widget(title_box);

			var welcome_box = new WelcomeBox();
			answers_box = new InstantAnswersBox();
			dictionary_box = new DictionaryBox();
			wikipedia_box = new WikipediaBox();

			var share_button = new Gtk.Button.from_icon_name("emblem-shared-symbolic");
			share_button.set_tooltip_text(_("Share"));
			var share_popover = new Gtk.Popover();

			tweet_button = new Gtk.Button.with_label(_("Share article via Tweet"));
			tweet_button.clicked.connect(() => {

                string encoded_text = """Look%20what%20I%20found%20on%20Wikipedia%20using%20%23Hypatia%3A%20""";
                string url = "https://twitter.com/intent/tweet?text=" + encoded_text + wikipedia_box.get_link();

                string ls_stdout;
                string ls_stderr;
                int ls_status;

                try {
                    Process.spawn_command_line_sync("xdg-open " + url,
                        out ls_stdout,
                        out ls_stderr,
                        out ls_status);

                } catch (SpawnError e) {
                    warning ("Error: %s\n", e.message);
                }
            });
            tweet_button.sensitive = false;

            wikipedia_box.article_changed.connect((found) => {
                if (found == true) {
                    tweet_button.sensitive = true;
                } else {
                    tweet_button.sensitive = false;
                }
            });
            
            share_popover.set_parent(share_button);
            var share_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
            share_box.append(tweet_button);
            share_popover.set_child(share_box);
            
            share_button.clicked.connect(() => {
               share_popover.popup();
            });

            var settings_button = new Gtk.Button.from_icon_name("open-menu-symbolic");
            settings_button.set_tooltip_text(_("Menu"));
            var settings_popover = new Gtk.Popover();
            settings_popover.set_parent(settings_button);
            var settings_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 6);

            var run_in_background_label = new Gtk.Label(_("Keep running in background"));
            run_in_background_label.halign = Gtk.Align.START;
            run_in_background_label.hexpand = true;
            var run_in_background_checkbox = new Gtk.CheckButton();
            run_in_background_checkbox.margin_start = 12;
            var run_in_background_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            run_in_background_box.hexpand = true;
            run_in_background_box.append (run_in_background_label);
            run_in_background_box.append (run_in_background_checkbox);
            settings_box.append(run_in_background_box);


            var load_from_clipboard_label = new Gtk.Label(_("Automatically load content from clipboard"));
            load_from_clipboard_label.halign = Gtk.Align.START;
            load_from_clipboard_label.hexpand = true;
            var load_from_clipboard = new Gtk.CheckButton();
            load_from_clipboard.margin_start = 12;
            var load_from_clipboard_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
            load_from_clipboard_box.append (load_from_clipboard_label);
            load_from_clipboard_box.append (load_from_clipboard);
            settings_box.append(load_from_clipboard_box);


            var show_welcome_at_startup_label = new Gtk.Label(_("Show welcome at start-up"));
            show_welcome_at_startup_label.halign = Gtk.Align.START;
            show_welcome_at_startup_label.hexpand = true;
            var show_welcome_at_startup = new Gtk.CheckButton();
            show_welcome_at_startup.margin_start = 12;
            var show_welcome_at_startup_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            show_welcome_at_startup_box.append (show_welcome_at_startup_label);
            show_welcome_at_startup_box.append (show_welcome_at_startup);
            settings_box.append (show_welcome_at_startup_box);


            var run_in_background = app.settings.get_boolean("run-in-background");
            var automatically_load_from_clipboard = app.settings.get_boolean("load-from-clipboard");
            var show_welcome = app.settings.get_boolean("show-welcome");

            if (run_in_background) {
                run_in_background_checkbox.set_active(true);
            } else {
                run_in_background_checkbox.set_active(false);
            }

            if (automatically_load_from_clipboard) {
                load_from_clipboard.set_active(true);
            } else {
                load_from_clipboard.set_active(false);
            }

            if (show_welcome) {
                show_welcome_at_startup.set_active(true);
            } else {
                show_welcome_at_startup.set_active(false);
            }

            run_in_background_checkbox.toggled.connect(() => {
                app.settings.set_boolean("run-in-background", run_in_background_checkbox.get_active());

            });

            load_from_clipboard.toggled.connect(() => {
                app.settings.set_boolean("load-from-clipboard", load_from_clipboard.get_active());

            });

            show_welcome_at_startup.toggled.connect(() => {
                app.settings.set_boolean("show-welcome", show_welcome_at_startup.get_active());
            });

            var separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
            separator.margin_top = 12;
            separator.margin_bottom = 12;
            settings_box.append (separator);


            var about_button = new Gtk.Button.with_label(_("About"));
            about_button.clicked.connect(() => {
                settings_popover.popdown();
                show_about_requested();
            });
            settings_box.append(about_button);

            settings_popover.set_child(settings_box);
            settings_button.clicked.connect(() => {
               settings_popover.popup();
            });

            var donate_button = new Gtk.LinkButton.with_label("https://ko-fi.com/nathandyer", _("Buy The Developer A Coffee"));
            donate_button.get_style_context().remove_class("link");
            donate_button.get_style_context().remove_class("flat");
            settings_box.append(donate_button);


            // Set up the main view for the application

            carousel = new Adw.Carousel();
			carousel.set_spacing(3000);
			carousel.vexpand = true;
			carousel.margin_start = 24;
			carousel.margin_end = 24;
			carousel.margin_top = 24;
			carousel.margin_bottom = 24;

            search_term_button = new Gtk.Button.from_icon_name("system-search-symbolic");
            search_term_button.set_tooltip_text(_("Show Search"));
            var search_term_revealer = new Gtk.Revealer();
            search_term_revealer.set_transition_type(Gtk.RevealerTransitionType.SLIDE_LEFT);
            var search_term_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            search_entry = new Gtk.Entry();
            search_entry.get_style_context().add_class("linked");
            search_entry.width_chars = 35;
            search_entry.placeholder_text = _("Enter Search Term");
            search_term_box.append(search_entry);
            search_term_revealer.set_child(search_term_box);

            search_term_button.clicked.connect(() => {
                if(search_term_revealer.child_revealed) {
                    search_term_revealer.set_reveal_child(false);
                    search_term_button.set_icon_name("system-search-symbolic");
                    search_term_button.set_tooltip_text(_("Show Search"));
                } else {
                    search_term_revealer.set_reveal_child(true);
                    search_term_button.set_icon_name("go-next-symbolic");
                    search_term_button.set_tooltip_text(_("Hide Search"));
                    search_entry.grab_focus();
                }
            });

            var copy_clipboard_button = new Gtk.Button.from_icon_name("edit-copy-symbolic");
            copy_clipboard_button.set_tooltip_text(_("Copy From Clipboard"));
            copy_clipboard_button.clicked.connect(on_load_clipboard);
            search_term_box.prepend(copy_clipboard_button);

            var activate_search_button = new Gtk.Button.from_icon_name("system-search-symbolic");
            activate_search_button.set_tooltip_text(_("Search"));
            search_term_box.append(activate_search_button);
            activate_search_button.get_style_context().add_class("linked");

            activate_search_button.clicked.connect(() => {
                loading_spinner.show();
                loading_spinner.start();
                search_requested(search_entry.text);

            });

            search_entry.activate.connect(() => {
                loading_spinner.show();
                loading_spinner.start();
                search_requested(search_entry.text);
            });

            search_entry.changed.connect(() => {
                app.search_text = search_entry.get_text();
            });

            app.show_search_entry_requested.connect(() => {
                if(search_term_revealer.child_revealed) {
                    search_term_revealer.set_reveal_child(false);
                    search_term_button.set_icon_name("system-search-symbolic");
                    search_term_button.set_tooltip_text(_("Show Search"));
                } else {
                    search_term_revealer.set_reveal_child(true);
                    search_term_button.set_icon_name("go-next-symbolic");
                    search_term_button.set_tooltip_text(_("Hide Search"));
                    search_entry.grab_focus();
                }
            });

            loading_spinner = new Gtk.Spinner();

            header.pack_end(settings_button);
            header.pack_end(share_button);
            header.pack_end(search_term_button);
            header.pack_end(search_term_revealer);
            header.pack_end(loading_spinner);

			var dictionary_scrolled = new Gtk.ScrolledWindow();
			dictionary_scrolled.set_child(dictionary_box);
			dictionary_scrolled.vexpand = true;
			dictionary_scrolled.hexpand = true;
			dictionary_scrolled.hscrollbar_policy = Gtk.PolicyType.NEVER;

			var wikipedia_scrolled = new Gtk.ScrolledWindow();
			wikipedia_scrolled.set_child(wikipedia_box);
			wikipedia_scrolled.vexpand = true;
			wikipedia_scrolled.hexpand = true;
			wikipedia_scrolled.hscrollbar_policy = Gtk.PolicyType.NEVER;

            if(app.settings.get_boolean("show-welcome")) {
                welcome_box.show();
            }
            carousel.append(answers_box);
            carousel.append(dictionary_scrolled);
            carousel.append(wikipedia_scrolled);

            box.append(carousel);

            var button_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
            var instant_answers_button = new Gtk.ToggleButton.with_label(_("Instant Answers"));
            var dictionary_button = new Gtk.ToggleButton.with_label(_("Definitions"));
            var wikipedia_button = new Gtk.ToggleButton.with_label(_("Wikipedia"));

            button_box.append(instant_answers_button);
            button_box.append(dictionary_button);
            button_box.append(wikipedia_button);
            button_box.get_style_context().add_class("linked");
            button_box.homogeneous = true;

            var button_revealer = new Gtk.Revealer();
            button_revealer.set_child(button_box);
            button_revealer.reveal_child = true;
            
            instant_answers_button.clicked.connect(() => {
                carousel.scroll_to(answers_box, true);
            });

            dictionary_button.clicked.connect(() => {
                carousel.scroll_to(dictionary_scrolled, true);
            });

            wikipedia_button.clicked.connect(() => {
                carousel.scroll_to(wikipedia_scrolled, true);
            });

            welcome_box.next_page_selected.connect(() => {
                welcome_box.hide();
                carousel.scroll_to(answers_box, true);
                if (app.settings.get_boolean("first-launch")) {
                    app.settings.set_boolean("show-welcome", false);
                    app.settings.set_boolean("first-launch", false);
                }
            });

            if (!app.settings.get_boolean("show-welcome")) {
                instant_answers_button.set_active(true);
                dictionary_button.set_active(false);
                wikipedia_button.set_active(false);
            }

            carousel.page_changed.connect((page) => {
                switch (page) {
                    case 0:
                        instant_answers_button.set_active(true);
                        dictionary_button.set_active(false);
                        wikipedia_button.set_active(false);
                        break;

                    case 1:
                        instant_answers_button.set_active(false);
                        dictionary_button.set_active(true);
                        wikipedia_button.set_active(false);
                        break;

                    case 2:
                        instant_answers_button.set_active(false);
                        dictionary_button.set_active(false);
                        wikipedia_button.set_active(true);
                        break;

                    default:

                        break;
                }
            });

            box.append(button_revealer);
            loading_spinner.hide();
            notify["visible"].connect(() => {
                if(this.visible) {
                    GLib.Timeout.add(500, () => {
                        if (app.settings.get_boolean("load-from-clipboard")) {
                            on_load_clipboard();
                        }
                        return false;
                    });
                }
            });
            
            welcome_box.set_transient_for(this);
		}

		public void set_entries(InstantAnswer answer, DictionaryEntry dict, WikipediaEntry wiki) {
            answers_box.set_answer(answer);
            dictionary_box.set_definition(dict);
            wikipedia_box.set_wikipedia_entry(wiki);
            loading_spinner.stop();
            loading_spinner.hide();
		}

		public void set_search_text(string text) {
		    var app = application as Hypatia.Application;
		    search_entry.text = text;
		    app.search_text = text;
		}

		public void toggle_search() {
		    search_term_button.clicked();
		}

		private void on_load_clipboard () {
            var clipboard = Gdk.Display.get_default().get_clipboard();

            clipboard.read_text_async.begin(null, (obj, res) => {
                try {
                    string search_text = clipboard.read_text_async.end(res);
                    set_search_text(search_text);
                    search_requested(search_text);
                } catch (Error e) {
                    warning(_("Unable to load from clipboard."));
                }
            });
		}
	}
}
