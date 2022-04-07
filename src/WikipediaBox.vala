/* WikipediaBox.vala
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
	public class WikipediaBox : Gtk.Box {

	    public signal void article_changed (bool found);

	    private Gtk.Label title_label;
	    private Gtk.Label extract_label;
	    private Gtk.LinkButton link_button;
	    private Gtk.Button wike_button;

	    private string NOT_FOUND_TEXT = _("No Wikipedia article found.");

        public WikipediaBox () {
            this.set_orientation(Gtk.Orientation.VERTICAL);
            this.set_spacing(12);

            title_label = new Gtk.Label(NOT_FOUND_TEXT);
            title_label.get_style_context().add_class("title-1");
            title_label.halign = Gtk.Align.START;
            extract_label = new Gtk.Label("");
            extract_label.halign = Gtk.Align.START;
            extract_label.set_max_width_chars(40);
            extract_label.set_wrap(true);
            extract_label.justify = Gtk.Justification.FILL;

            link_button = new Gtk.LinkButton.with_label("https://wikipedia.org", "Read more on Wikipedia");
            link_button.halign = Gtk.Align.CENTER;
            
            wike_button = new Gtk.Button.with_label("Read More in Wike") {
            	css_classes = {"suggested-action","pill"},
            	halign = Gtk.Align.CENTER
            };
            
            //FIXME: The app stop responding when trying to Open Wike and respond back when closing it.
            wike_button.clicked.connect(()=>{
            	string ls_stdout;
                string ls_stderr;
                int ls_status;
                
                //TODO: Use GLib.AppInfo.Launch instead to launch wike.
                try {
                    Process.spawn_command_line_sync("wike -u " + link_button.get_uri(),
                        out ls_stdout,
                        out ls_stderr,
                        out ls_status);

                } catch (SpawnError e) {
                    warning ("Error: %s\n", e.message);
                }
            });

            this.append(title_label);
            this.append(extract_label);
            this.append(link_button);
            this.append(wike_button);

            link_button.hide();
            wike_button.hide();
        }
        //TODO: Use Glib.AppInfo instead to check for the existence of Wike.
        public bool is_wike_installed() {
        	if (FileUtils.test("/usr/bin/wike", FileTest.EXISTS)) {
        		return true;
        	} else {
        		return false;
        	}
        }

        public void set_wikipedia_entry (WikipediaEntry entry) {
            title_label.set_text(entry.title);
            if(entry.extract != null && entry.extract.length > 0) {
                extract_label.set_text (entry.extract.replace("\n", "\n\n"));
                link_button.set_uri(entry.url);
                link_button.show();
                
                if (is_wike_installed()) {
                	wike_button.show();                	
                }
                
                extract_label.show();
                article_changed(true);

            } else {
                extract_label.hide();
                link_button.hide();
                wike_button.hide();
                title_label.set_text(NOT_FOUND_TEXT);
                article_changed(false);
            }
        }

        public string get_link() {
            return link_button.get_uri();
        }
	}

}
