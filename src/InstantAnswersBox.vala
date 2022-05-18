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
	    private Gtk.Box left_box;
	    private Gtk.Separator separator;

	    private string NOT_FOUND_TEXT = _("No instant answer found");

        public InstantAnswersBox() {
            this.set_orientation(Gtk.Orientation.HORIZONTAL);
            this.set_spacing(12);
            this.vexpand = false;

            image = new Gtk.Image();

			separator = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
			separator.hide();

            heading_label = new Gtk.Label(NOT_FOUND_TEXT);
            heading_label.css_classes = {"title-1"};
            heading_label.wrap = true;
            heading_label.margin_top = 5;
            heading_label.margin_bottom = 5;
            heading_label.margin_start = 10;
            heading_label.margin_end = 10;
            heading_label.halign = Gtk.Align.START;
            
            abstract_text_label = new Gtk.Label("");
            abstract_text_label.wrap = true;
            abstract_text_label.halign = Gtk.Align.START;
            abstract_text_label.valign = Gtk.Align.START;
            abstract_text_label.justify = Gtk.Justification.FILL;
            abstract_text_label.hexpand = true;            
            abstract_text_label.vexpand = true;
            abstract_text_label.margin_top = 5;
            abstract_text_label.margin_bottom = 5;
            abstract_text_label.margin_start = 10;
            abstract_text_label.margin_end = 10;
            abstract_text_label.selectable = true;
            

            left_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);

            source_label = new Gtk.Label(_("Answers provided by DuckDuckGo"));
            source_label.halign = Gtk.Align.START;
            source_label.css_classes = {"accent"};
            source_label.margin_top = 5;
            source_label.margin_bottom = 5;
            source_label.margin_start = 10;
            source_label.margin_end = 10;
			

            left_box.append(heading_label);
            left_box.append(separator); 
            left_box.append(abstract_text_label);
            left_box.append(source_label);
            left_box.hexpand = true;

            this.append(left_box);

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
                        image.margin_top = 10;
                        left_box.prepend(image);
			            left_box.css_classes = {"card"};    
			            heading_label.halign = Gtk.Align.CENTER;
                        image.show();
                        separator.show();

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
