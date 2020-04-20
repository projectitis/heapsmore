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

## Changes
__2020-04-20__
* TextArea: Fixed glyph alignment. Added JustifyFull. Added character spacing. Lots of improvements.
* BoxBackground: Fixed percentage-sized backgrounds. Added corner radius (only works with colored backgrounds)
__2020-04-19__
* TextArea: Fixed width and maxWidth
