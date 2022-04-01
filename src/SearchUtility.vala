/* SearchUtility.vala
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
    public class InstantAnswer {

        public string heading = "";
        public string abstract_text = "";
        public string abstract_url = "";
        public string image = "";

        public InstantAnswer () {}
    }

    public class DictionaryEntry{
        public string word = "";
        public string phonetic = "";
        public string origin = "";

        public Gee.ArrayList<Definition> definitions = new Gee.ArrayList<Definition>();

        public DictionaryEntry () {}

    }

    public class Definition {
        public string definition = "";
        public string example = "";
        public string part_of_speech = "";
        public Gee.ArrayList<string> synonyms = new Gee.ArrayList<string>();
        public Gee.ArrayList<string> antonyms = new Gee.ArrayList<string>();

        public Definition () {}
    }

    public class WikipediaEntry {

        public string title = "";
        public string extract = "";
        public int64 pageid = 0;
        public string url = "";

        public WikipediaEntry () {}

    }


	public class SearchUtility {

	    public static string INSTANT_SEARCH_PROVIDER = "DuckDuckGo";
	    public static string DEFINITION_PROVIDER = "Wiktionary via the Free Dictionary API";

        public static InstantAnswer? do_search (string term) {

            var uri = "https://api.duckduckgo.com/?q=%s&format=json&pretty=1&skip_disambig=1".printf(term);

            var session = new Soup.Session();
            var message = new Soup.Message("GET", uri);
            session.send_message(message);

            try {
                var parser = new Json.Parser();
                parser.load_from_data((string) message.response_body.flatten().data, -1);


                var root_object = parser.get_root().get_object();

                var answer = new InstantAnswer();
                answer.heading = root_object.get_string_member("Heading");
                answer.abstract_text = root_object.get_string_member("AbstractText");
                answer.abstract_url = root_object.get_string_member("AbstractURL");
                answer.image = "http://duckduckgo.com" + root_object.get_string_member("Image");

                return answer;

            } catch (Error e) {
                warning(_("Unable to get instant answer for: ") + term);
                return null;
            }
        }

        public static DictionaryEntry? find_definition(string term) {
            // For now, only English definitions are working
            // French and Spanish should be available soon
            var uri = "https://api.dictionaryapi.dev/api/v2/entries/en/%s".printf(term);

            var session = new Soup.Session();
            var message = new Soup.Message("GET", uri);
            session.send_message(message);

            string partOfSpeech = "";

            try {

                var dictionary_entry = new DictionaryEntry();
                var definitions = new Gee.ArrayList<Definition>();

                var parser = new Json.Parser();
                parser.array_end.connect((array) => {

                    var element = array.get_object_element(0);

                    // Check to see which array
                    //
                    if (element == null) {

                    } else if (element.get_string_member("word") != null) {

                        dictionary_entry.word = element.get_string_member("word");
                        dictionary_entry.phonetic = element.get_string_member("phonetic");
                        if (element.get_string_member("origin") != null) {
                           dictionary_entry.origin = element.get_string_member("origin");
                        }

                    } else if (element.get_string_member("definition") != null) {

                        var definition = new Definition();
                        definition.definition = element.get_string_member("definition");

                        if (partOfSpeech.length > 0) {
                            definition.part_of_speech = partOfSpeech;
                        }

                        if (element.get_string_member("example") != null) {
                            definition.example = element.get_string_member("example");
                        }

                        if (element.get_array_member("synonyms") != null) {
                            var synonyms = element.get_array_member("synonyms");

                            for (int i = 0; i < synonyms.get_length(); i++) {
                                var syn = synonyms.get_string_element(i);
                                definition.synonyms.add(syn);
                            }
                        }

                        definitions.add(definition);

                    } else if (element.get_string_member("partOfSpeech") != null) {
                        partOfSpeech = element.get_string_member("partOfSpeech");
                    }
                    });

                    parser.load_from_data((string) message.response_body.flatten().data, -1);

                    foreach (var d in definitions) {
                        dictionary_entry.definitions.add(d);
                    }

                    return dictionary_entry;


            } catch (Error e) {
                warning(_("Unable to load definition for: ") + term);
                return null;
            }
        }

        public static WikipediaEntry?  do_wikipedia_lookup (string term) {

            var uri = "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=%s".printf(term);

            var session = new Soup.Session();
            var message = new Soup.Message("GET", uri);
            session.send_message(message);

            try {

                var wikipedia_entry = new WikipediaEntry();

                var parser = new Json.Parser();
                parser.load_from_data((string) message.response_body.flatten().data, -1);
                var root_object = parser.get_root().get_object();
                var pages = root_object.get_object_member("query").get_object_member("pages");
                var members = pages.get_members();

                foreach (var member in members) {
                    var element = pages.get_object_member(member);
                    wikipedia_entry.title = element.get_string_member("title");
                    wikipedia_entry.extract = element.get_string_member("extract");
                    wikipedia_entry.pageid = element.get_int_member("pageid");
                }

                wikipedia_entry.url = "http://en.wikipedia.org/?curid=%ld".printf((long)wikipedia_entry.pageid);
                return wikipedia_entry;

            } catch (Error e) {
                warning(_("Unable to load Wikipedia article for: ") + term);
                return null;
            }
        }
    }
}
