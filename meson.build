project('hypatia', ['c', 'vala'],
          version: '0.1.0',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                   ],
)

i18n = import('i18n')
add_global_arguments([
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    '-w',
], language: 'c')

dependency('gtk4', version: '>= 4.6.0')
dependency('libadwaita-1', version :'>=1.0.0')
dependency('gee-0.8', version: '>= 0.8.0')


subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')
