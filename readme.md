# Heaps::more
__Heaps::more__ is an extension library for use with the [Heaps](https://heaps.io/) Game Framework, written in [Haxe](https://haxe.org/) and open-sourced under the [MIT license](https://choosealicense.com/licenses/mit/).

## Current status
Very much a work-in-progress.

Just finished developing an equation parser. It handles functions and variables, and has callbacks to support custom functions, variables and constants. It also supports useful functions for working with color, such as darken, lighten and tint. This EqParser will form the basis for my [JX (Json eXpanded) parser](https://github.com/projectitis/jx).

## Package structure
The package structure is similar to Heaps:
* __m2d__ - 2D-related classes
* __m3d__ - 3D-related classes
* __mxd__ - 2D/3D agnostic classes
* __examples__ - Examples :)

## TODO
* Working scroll bars

## Changes

__2020-05-29__
* Wrote an equation parser (`mxd.EqParser`)! Handles many common math functions, custom variables/functions/constants, and also color functions (like darken, lighten and tint)

__2020-05-20__
* UI: Changed sockets to use drag/drop instead of click/click

__2020-05-19__
* UI: Added `Socket` class to dock cables to
* Examples: Added `Socket` example

__2020-05-17__
* UI: Changed to use `h2d.col.Bounds` and removed custom `Rect` class
* UI: Started scrollbars and scroll areas
* Tools: Added easing equations based on [AHEasing](https://github.com/warrenm/AHEasing)
* UI: Started `Cable` class for approximated rope physics (catenary curves). Not intended to be accurate, just visually pleasing!

__2020-05-05__
* UI: Added table formatting to flow. Added auto-height and width support to UI elements

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
