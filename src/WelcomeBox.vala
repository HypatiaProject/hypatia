/* WelcomeBox.vala
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
	public class WelcomeBox : Adw.Window {

	    public signal void next_page_selected();
	    public Gtk.Box box;
	    
        public WelcomeBox () {
            this.modal = true;
            this.set_default_size (200, 200);
            box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
            box.set_orientation(Gtk.Orientation.VERTICAL);

            var welcome_label = new Gtk.Label("Welcome to Hypatia");
            welcome_label.get_style_context().add_class("large-title");
            welcome_label.margin_top = 30;
            box.append(welcome_label);

            string welcome_text = _("Hypatia is a research tool that finds information as you use your device.\n\nYou can enter any word or topic in the search field to find instant answers, photos, definitions, synonyms, and Wikipedia articles.\n\nBy default, every time you open the application it automatically searches for what's on your clipboard, so you can look up information about things as you browse the web and use your device. For the best workflow, we recommend setting a keyboard shortcut in your OS to launch the application, so you can find answers in a single keypress.");

            var description_label = new Gtk.Label(welcome_text);
            description_label.set_width_chars (40);
            description_label.set_wrap (true);
            description_label.vexpand = true;
            description_label.valign = Gtk.Align.START;
            description_label.halign = Gtk.Align.START;
            description_label.margin_end = 15;
            description_label.margin_top = 15;
            description_label.margin_start = 15;
            description_label.margin_end = 15;
            description_label.justify = Gtk.Justification.CENTER;
            box.append(description_label);

            var button = new Gtk.Button.with_label (_("Get Started"));
            button.css_classes = {"suggested-action","pill"};
            button.halign = Gtk.Align.CENTER;
            button.margin_bottom = 30;
            button.clicked.connect(() => {
                next_page_selected();
            });
            box.append(button);
            this.set_content (box);
        }
	}
}
