hypatia_sources = [
  'Main.vala',
  'Window.vala',
  'WelcomeBox.vala',
  'WikipediaBox.vala',
  'DictionaryBox.vala',
  'InstantAnswersBox.vala',
  'SearchUtility.vala',
  'Application.vala',
  ]

hypatia_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('libsoup-2.4'),
  dependency('json-glib-1.0'),
  dependency('gee-0.8')
]

executable('hypatia', hypatia_sources,
  vala_args: '--target-glib=2.50',  dependencies: hypatia_deps,
  install: true,
)
