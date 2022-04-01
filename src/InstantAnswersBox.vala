/* DDGBox.vala
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
	public class InstantAnswersBox : Gtk.Box {

	    private Gtk.Label heading_label;
	    private Gtk.Label abstract_text_label;
	    private Gtk.Label source_label;
	    private Gtk.Image image;

	    private string NOT_FOUND_TEXT = _("No instant answer found");

        public InstantAnswersBox() {
            this.set_orientation(Gtk.Orientation.HORIZONTAL);
            this.set_spacing(12);
            this.vexpand = false;

            heading_label = new Gtk.Label(NOT_FOUND_TEXT);
            heading_label.get_style_context().add_class("title-1");
            heading_label.halign = Gtk.Align.START;
            abstract_text_label = new Gtk.Label("");
            abstract_text_label.set_max_width_chars(40);
            abstract_text_label.set_wrap(true);
            abstract_text_label.halign = Gtk.Align.START;
            abstract_text_label.justify = Gtk.Justification.FILL;
            image = new Gtk.Image();

            var left_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);
            var right_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);
            right_box.get_style_context().add_class("card");
            right_box.valign = Gtk.Align.START;

            source_label = new Gtk.Label(_("Answers provided by DuckDuckGo"));
            source_label.halign = Gtk.Align.START;
            source_label.get_style_context().add_class("accent");

            left_box.append(heading_label);
            left_box.append(abstract_text_label);
            left_box.append(source_label);
            left_box.hexpand = true;
            right_box.append(image);

            this.append(left_box);
            this.append(right_box);

            source_label.hide();
            image.hide();
        }

        public void set_answer(InstantAnswer answer) {
            if (answer != null && answer.heading.length > 0 && answer.abstract_text.length > 0) {
                heading_label.set_text(answer.heading);
                abstract_text_label.set_text(answer.abstract_text);
                abstract_text_label.show();
                source_label.show();

                Gdk.Pixbuf pixbuf = null;

                if (answer.image.length > 0) {
                    try {
                        var session = new Soup.Session();
                        var message = new Soup.Message("GET", answer.image);
                        InputStream stream = session.send(message);
                        pixbuf = new Gdk.Pixbuf.from_stream(stream, null);
                        image.set_from_pixbuf(pixbuf);
                        image.set_pixel_size(250);
                        image.margin_top = 12;
                        image.margin_bottom = 12;
                        image.margin_start = 12;
                        image.margin_end = 12;
                        image.show();

                    } catch (Error e) {
                        warning(_("Failed to load image. %s"), e.message);
                        image.hide();
                    }
                } else {
                    image.hide();
                }
            } else {
                image.hide();
                abstract_text_label.hide();
                source_label.hide();
                heading_label.set_text(NOT_FOUND_TEXT);
            }
        }
	}
}
