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
	public class WelcomeBox : Gtk.Box {

	    public signal void next_page_selected();

        public WelcomeBox () {
            this.set_orientation(Gtk.Orientation.VERTICAL);
            this.set_spacing(12);

            var welcome_label = new Gtk.Label("Welcome to Hypatia");
            welcome_label.get_style_context().add_class("large-title");
            this.append(welcome_label);

            string welcome_text = "Hypatia is a research tool that finds information as you use your device.\n\nYou can enter any word or topic in the search field to find instant answers, photos, definitions, synonyms, and Wikipedia articles.\n\nBy default, every time you open the application it automatically searches for what's on your clipboard, so you can look up information about things as you browse the web and use your device. For the best workflow, we recommend setting a keyboard shortcut in your OS to launch the application, so you can find answers in a single keypress.";

            var description_label = new Gtk.Label(welcome_text);
            description_label.set_width_chars (40);
            description_label.set_wrap (true);
            description_label.vexpand = true;
            description_label.valign = Gtk.Align.CENTER;
            this.append(description_label);

            var button = new Gtk.Button.with_label ("Get Started");
            button.get_style_context ().add_class("suggested-action");
            button.halign = Gtk.Align.END;
            button.margin_top = 12;
            button.clicked.connect(() => {
                next_page_selected();
            });
            this.append(button);
        }
	}
}
