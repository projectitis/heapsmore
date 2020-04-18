# Heaps::more
__Heaps::more__ is a library for use with the [Heaps](https://heaps.io/) Game Framework, written in [Haxe](https://haxe.org/).

__Heaps__ is a reasonably bare-bones framework and currently doesn't provide much in the way of high-level features like UI, physics etc. __Heaps::more__ is an attempt to add some of these features. I use it in my own projects. I don't offer any guarantees, but you are welcome to use it in yours ([MIT license](https://choosealicense.com/licenses/mit/)).

## Current state
Very much a work-in-progress. Currently working on a css box-model based UI library, starting with an improved text area [m2d.ui.TextArea](m2d/ui/TextArea.hx). The TextArea now has text rendering, auto-width or fixed width, auto-height or fixed height, clipping (partial glyphs), css box-model (padding, border, margin). Working on alignment (including justify) and then scrolling. 

## Package structure
The package structure is similar to Heaps:
* __m2d__ - 2D-related classes
* __m3d__ - 3D-related classes
* __mxd__ - 2D/3D agnostic classes
