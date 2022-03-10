# Hypatia
A research helper tool for Linux-based systems

<img src="hypatia-alpha-screenshot.png" width="700px">

**WARNING**: This repository is currently in a pre-alpha state. If you intend to build this project, please know that the experience is not complete. Please do not review the application yet, and please do not file new bugs until the first version is released (the first release is tentatively planned for March 18th, but that date is subject to change).

## About


Hypatia is a research tool for the Linux desktop. It's designed to provide at-a-glance information about the topics you're reading, or about things you're curious about. It lets you find definitions, explanations, and answers related to the text on your display without removing you from the context or making you navigate away.

For those familiar with the lookup feature in Apple operating systems, it works in a similar way, but is much more powerful, and can be triggered independently without having to force-touch on a single word. 


## How it works


There are two ways the application can function: manually, where you open the app and enter a word or phrase to search for, or automatically, where it reads text from your clipboard on launch, and can be triggered by a shortcut.

Once you set a keyboard shortcut to open the app, you can copy text from the article you're reading, trigger the app, and a pop-up will give you instant information about whatever it is you're looking at.

Or, if you prefer to use it in manual mode, you can open it and search directly for any topic by entering it into the search box.


## What can it do? 

At launch, there are three main action areas:

1. Instant Answers (provided by DuckDuckGo)
2. Dictionary and thesaurus (provided by Wiktionary, via the FreeDictionaryAPI)
3. Wikipedia Entries

Searching for any term or phrase will search those sources for information, and the app will present any relevant results that it finds. 

## What are future plans?

Hypatia is meant to be a lean, yet powerful, research tool. The main focus will always be around these three sources, but there are some system-wide integrations I'd like to add, once the platforms provide for them. For example, the ideal would be for Hypatia to:

- Open the Maps app when you search for a location
- Open Wike, or a similar application, when you select to read more
- Open a note taking app when you want to create a note based on the content

If other integrations make sense and don't weaken the experience (or cause confusion) I'm open to adding it, but the main focus for future additions is with sharing and third-party app integration.


## How do I build it? 

We recommend cloning the project and building with GNOME Builder.

Alternately, you can build it by running the following commands on Fedora and similar systems:

```
sudo dnf install valac gtk4-devel libadwaita-devel libgee-devel libsoup-devel json-glib-devel
meson builddir --prefix=/usr/local
sudo ninja -C builddir install
```
