# Friday Night Funkin: Redstone Engine

A modification of Friday Night Funkin's engine designed to tweak little details and add small features to make the game feel a bit more polished.
## Features
- Improved input system
- Customizable note hitboxes
- Notes glow when they can be hit
- Decimal BPM support
- Randomization
- Powerful optimization system
- Improved animations
- And more!
## Feature requests
- Is there something you want in the engine? Open an issue or a pull request to increase your chances of it being added!
## Engine Credits
- [RedstoneRuler](https://twitter.com/redstoneruler2) - Programming
- The various other FNF projects that I sto- er, "borrowed" artwork/code from. (Hey listen they're open source too so anything goes)
## OG FNF Credits
- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art/Animation
- [Kawai Sprite](https://twitter.com/kawaisprite) - Music
## Build instructions
The compilation process for this engine is mostly the same as compiling the base game, but there are a few more steps depending on the version you plan on compiling.
After setting up Haxe, do the following:
### New Video Codec (hxCodec)
- Install hxCodec by running `haxelib git hxCodec https://github.com/polybiusproxy/hxcodec`

### Old Video Codec (Extension-Webm)
- Install actuate by running `haxelib install actuate`
- Install the extension-webm fork by running `haxelib git extension-webm https://github.com/GrowtopiaFli/extension-webm`
- Finally, run `lime rebuild extension-webm [windows/mac/linux/android]`, depending on device.

The rest of the process can be found here: https://github.com/ninjamuffin99/Funkin#build-instructions
## Other notes
This repository probably looks much smaller than what you're used to. Don't worry, I just gitignored a lot of unnecessary files. This will not affect compilation.
