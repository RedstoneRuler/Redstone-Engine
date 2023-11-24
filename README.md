# Friday Night Funkin: Redstone Engine

A modification of Friday Night Funkin's engine full of random features that I thought might be cool, developed as a way of learning HaxeFlixel.
## Please note
This engine is a buggy, outdated nightmare full of terrible code and poorly thought-out mechanics. I am most likely not coming back to this anytime soon. The rest of the README below is outdated and likely inaccurate due to age.
## Features
- Lower latency
- Randomized charts
- Powerful optimization system
- Improved animations
- Custom UI skin support
- Softcoded modding support (WIP)
- And more!
## Engine Credits
- [RedstoneRuler](https://twitter.com/redstoneruler2) - Programming
- The various other FNF projects that I sto- er, "borrowed" artwork/code from. (Hey listen they're open source too so anything goes)
## OG FNF Credits
- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art/Animation
- [Kawai Sprite](https://twitter.com/kawaisprite) - Music
## Build instructions
The compilation process for this engine is mostly the same as compiling the base game, but there are a few more steps.
**Install the latest version of Haxe. The bug mentioned on the FNF repo has been fixed.**

After setting up HaxeFlixel, do the following, depending on the version you plan on compiling:
### Windows, Android (hxCodec)
- Install hxCodec by running `haxelib git hxCodec https://github.com/polybiusproxy/hxcodec`

### HTML5, Mac, Linux (Extension-Webm)
- Install actuate by running `haxelib install actuate`
- Install the extension-webm fork by running `haxelib git extension-webm https://github.com/GrowtopiaFli/extension-webm`
- Finally, run `lime rebuild extension-webm [windows/mac/linux/android]`, depending on your platform, **not the platform you're compiling for.**

The rest of the process can be found here: https://github.com/ninjamuffin99/Funkin#build-instructions
