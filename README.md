# Amidst Seed Hunter

Updated!

Automates the hunt for seeds containing (or excluding) biomes and structures using [Amidst](https://github.com/toolbox4minecraft/amidst/releases).

This is still very much alpha software. Not all of the features work and some may not quite work as expected. Please report any bugs you find.

Also, if you'd like to support further development, please check out my [Patreon](https://www.patreon.com/azuntik)!

## Installation

No installation; it's a standalone executable. If you want to compile from source, you'll need to install AutoIt v3.

## Usage

You will need to set up Amidst to work properly. Amidst Seed Hunter works by searching for the unique biome color codes, as well as the colors used in the various structures icons, in the Amidst window. For best results, please do the following prior to running Amidst Seed Hunter:
* Turn on the grid and zoom to set the search area. If you want the biomes to appear within 2048 blocks, for instance, be sure that a square (centered on 0,0) is visible in the Amidst window. You will want to adjust the size of the window so that the seed information window is just slightly above the search area, and the icon in the lower right is just below it. Take a look at debug_image.jpg for help visualizing this.
* Once you've set the zoom, turn off the grid.
* If you're only concerned with biomes, you can turn off all other layers. Otherwise, add the layers for the structures you're searching for.
* You're set! You can run Amidst Seed Hunter!

Choose the biomes and/or structures you'd like to include in your search, as well as any you want to make sure don't appear (if desired).

There are a lot of settings on the options page that you can play around with. If you want to use a seed list file, be sure that each seed is listed on its own line.

Once you've got everything set the way you want it, click "Begin Search" and get something to drink, because it's going to be a while.

The program will end when it finds the number of seeds you're looking for or hits the maximum number of seeds to search. All of that can be configured.

If you want to search indefinitely (until you find the number of seeds you're looking for), simply set the maximum seeds to evaluate to 0.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## History

13 April 2017 - First commit! v0.1
23 April 2017 - v0.2 - Major feature update
24 April 2017 - v0.2.1 - Fixed a handful of bugs and added guided Amidst setup

## Credits

This was written by me, Azuntik, in AutoIt.

The cool "Toast" effect in the corner belongs to Melba23.

And, obviously, Amidst, while not included here, is indispensible to this project.

## License

CC BY-NC-SA 4.0 (https://creativecommons.org/licenses/by-nc-sa/4.0/)
