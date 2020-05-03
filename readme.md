# Heaps::more
__Heaps::more__ is a library for use with the [Heaps](https://heaps.io/) Game Framework, written in [Haxe](https://haxe.org/).

__Heaps__ is a reasonably bare-bones framework and currently doesn't provide much in the way of high-level features like UI, physics etc. __Heaps::more__ is an attempt to add some of these features. I use it in my own projects. I don't offer any guarantees, but you are welcome to use it in yours ([MIT license](https://choosealicense.com/licenses/mit/)).

## Current status
Very much a work-in-progress. Currently working on a css box-model based UI library.

## Package structure
The package structure is similar to Heaps:
* __m2d__ - 2D-related classes
* __m3d__ - 3D-related classes
* __mxd__ - 2D/3D agnostic classes
* __examples__ - Examples :)

## TODO
* Update Param to specifically use Box parent
* Update param to call parent.contentWidth/height
* Move param to m2d.ui (tied in with ui because of Object and UIApp)

## Changes

__2020-05-03__
* UI: Rudimentary Flow object (pinterest style columns)

__2020-05-02__
* UI: Redo entire UI system from scratch using lessons learned so far!

__2020-04-28__
* UI: Created Param for relative sizes (supports px, %, pw, ph, vw,vh)
* UI: Started UIApp (extends hxd.App) specifically for an m2d.ui based app
* UI: Working on creating UI DOM from JSON file (supports font loading and stylesheets). WIP

__2020-04-21__

* Color: Added 140 predefined colors (the css3 colors). Added color helpers
* Borders: Added border rendering (no radius support yet)

__2020-04-20__

* TextArea: Fixed glyph alignment. Added JustifyFull. Added character spacing. Lots of improvements
* Background: Fixed percentage-sized backgrounds. Added corner radius (only works with colored backgrounds)

__2020-04-19__

* TextArea: Fixed width and maxWidth
