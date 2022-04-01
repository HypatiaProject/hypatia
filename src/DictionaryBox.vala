/* DictionaryBox.vala
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
	public class DictionaryBox : Gtk.Box {

	    private Gtk.Box dictionary_box;
	    private Gtk.Box thesaurus_box;

	    private Gtk.Label dictionary_label;

	    private Gtk.Label word_label;
	    private Gtk.Label pronunciation_label;
	    private Gtk.Label origin_label;

	    private Gtk.Label not_found_label;
	    private Gtk.Label source_label;

        public DictionaryBox () {
            this.set_orientation(Gtk.Orientation.VERTICAL);
            this.set_spacing(12);

            dictionary_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);
            thesaurus_box = new Gtk.Box(Gtk.Orientation.VERTICAL, 12);

            dictionary_label = new Gtk.Label(_("Dictionary"));
            dictionary_label.halign = Gtk.Align.START;
            dictionary_label.get_style_context().add_class("heading");

            word_label = new Gtk.Label("");
            word_label.get_style_context().add_class("title-1");
            word_label.halign = Gtk.Align.START;
            word_label.set_wrap(true);

            pronunciation_label = new Gtk.Label("");
            pronunciation_label.halign = Gtk.Align.START;
            pronunciation_label.get_style_context().add_class("title-4");
            pronunciation_label.set_wrap(true);

            source_label = new Gtk.Label(_("Definitions provided by Wiktionary via Free Dictionary API"));
            source_label.halign = Gtk.Align.START;
            source_label.get_style_context().add_class("accent");
            source_label.hide();

            origin_label = new Gtk.Label("");
            origin_label.halign = Gtk.Align.START;
            origin_label.set_wrap(true);

            not_found_label = new Gtk.Label(_("No definitions found."));
            not_found_label.halign = Gtk.Align.START;
            not_found_label.get_style_context().add_class("title-1");

            this.append(not_found_label);
            this.append(word_label);
            this.append(pronunciation_label);
            this.append(origin_label);
            this.append(dictionary_box);
            this.append(source_label);
        }

        public void set_definition(DictionaryEntry entry) {

            set_found(false);

            // Clear existing entries
            while(dictionary_box.get_last_child() != null) {
                dictionary_box.remove(dictionary_box.get_last_child());
            }

            dictionary_box.append(dictionary_label);

            word_label.set_text(entry.word);
            pronunciation_label.set_text(entry.phonetic);
            origin_label.set_text(entry.origin);

            int def_count = 1;
            foreach (var def in entry.definitions) {
                var def_label = new Gtk.Label("%i: %s".printf(def_count, def.definition));
                def_label.halign = Gtk.Align.START;
                def_label.set_wrap(true);

                if(def.part_of_speech.length > 0) {
                    var part_of_speech_label = new Gtk.Label("<b>%s</b>".printf(def.part_of_speech));
                    part_of_speech_label.halign = Gtk.Align.START;
                    part_of_speech_label.use_markup = true;
                    part_of_speech_label.set_wrap(true);
                    dictionary_box.append(part_of_speech_label);
                }

                dictionary_box.append(def_label);

                string synonyms = _("Synonyms: ");
                foreach (var syn in def.synonyms) {
                    synonyms = synonyms + ", " + syn;
                }
                synonyms = synonyms.replace(" ,", "");

                string antonyms = _("Antonyms: ");
                foreach (var ant in def.antonyms) {
                    antonyms = antonyms + ", " + ant;
                }
                antonyms = antonyms.replace(" ,", "");

                if (def.synonyms.size > 0) {
                    var syn_label = new Gtk.Label(synonyms);
                    syn_label.halign = Gtk.Align.START;
                    dictionary_box.append(syn_label);
                }
                if (def.antonyms.size > 0) {
                    var ant_label = new Gtk.Label(antonyms);
                    ant_label.halign = Gtk.Align.START;
                    dictionary_box.append(ant_label);
                }

                def_count = def_count + 1;
                set_found(true);
            }
        }

        public void set_found (bool found) {
            if(found) {
                not_found_label.hide();
                dictionary_label.show();
                word_label.show();
                pronunciation_label.show();
                origin_label.show();
                source_label.show();
            } else {
                not_found_label.show();
                dictionary_label.hide();
                word_label.hide();
                pronunciation_label.hide();
                origin_label.hide();
                source_label.hide();
            }
        }
	}

}
