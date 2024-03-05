# Octopus 🐙

Swift implementation of the Homerow and Tab keyboard remapping modes for macOS. Ergonomics over mnemonics.


## Why I built this

Homerow and Tab modes were initially implemented and maintained in the original Karabiner app, which stopped working in 2007 because of the keyboard driver architecture changes in macOS Sierra. [Karabiner-Elements](https://karabiner-elements.pqrs.org/) was released as a replacement for Karabiner, however it took a long time until Karabiner-Elements supported all the functionality necessary for Homerow and Tab modes to work. Without prospects of seeing Karabiner-Elements support these modes which I relied upon daily for code/text editing, I decided to implement them myself in a dedicated app. The initial implementation was in Objective-C. It was later re-written through different versions of Swift as they were released. Today Octopus implements these modes in a way, which [I still don't think is possible](https://github.com/yqrashawn/GokuRakuJoudo/issues/158#issuecomment-1025209574) with Karabiner-Elements.


## Modes

Each mode is active only while the respective activation key is pressed (eg. space / tab). The  objective is to increase system-wide speed and comfort of navigation and text manipulation with the keyboard, while minimizing hand movement. Ergonomic key mappings are prioritized over mnemonic ones. This means that the most used actions are placed closer to the homerow mode, and not mapped according to characters that would make them easier to remember.

### Homerow mode

For general text editing and manipulation. Active while the <kbd>Space</kbd> key is pressed:

- Directional keys: <kbd>J</kbd><kbd>K</kbd><kbd>L</kbd><kbd>I</kbd> -> <kbd>Left</kbd><kbd>Down</kbd><kbd>Right</kbd><kbd>Up</kbd>

- Editing:
  - <kbd>Y</kbd> -> <kbd>⌘ Delete</kbd>
  - <kbd>U</kbd> -> <kbd>Delete</kbd>
  - <kbd>O</kbd> -> <kbd>Space</kbd>
  - <kbd>P</kbd> -> <kbd>Forward Delete</kbd>
- Undo / Redo:
  - <kbd>H</kbd> -> <kbd>⌘</kbd><kbd>Z</kbd>
  - <kbd>N</kbd> -> <kbd>⌘</kbd><kbd>Shift</kbd><kbd>Z</kbd>
- Return / Escape
  - <kbd>;</kbd> -> <kbd>Return</kbd>
  - <kbd>'</kbd> -> <kbd>Esc</kbd>

- Left hand, modifiers:
  - <kbd>A</kbd> -> <kbd>Shift</kbd>
  - <kbd>S</kbd> -> <kbd>Control</kbd>
  - <kbd>D</kbd> -> <kbd>Option</kbd>
  - <kbd>F</kbd> -> <kbd>Command</kbd>
  - <kbd>G</kbd> -> <kbd>Hyper</kbd>

- Left hand, single press:
  - <kbd>A</kbd> -> <kbd>⌃</kbd><kbd>S</kbd> (select word under cursor)
  - <kbd>S</kbd> -> <kbd>⌘</kbd><kbd>X</kbd> (cut)
  - <kbd>D</kbd> -> <kbd>⌘</kbd><kbd>C</kbd> (copy)
  - <kbd>F</kbd> -> <kbd>⌘</kbd><kbd>V</kbd> (paste)
  - <kbd>F</kbd> -> <kbd>⌘</kbd><kbd>G</kbd> (duplicate)


### Tab mode

For app, window, and tab navigation and management. Active while the <kbd>Tab ⇥</kbd> key is pressed
- <kbd>J</kbd>/<kbd>L</kbd>: switch between apps
- <kbd>I</kbd>/<kbd>K</kbd>: switch between windows of the active app
- <kbd>U</kbd>/<kbd>O</kbd>: switch betwen tabs
- <kbd>Y</kbd>: close tab
- <kbd>;</kbd>: new tab
- <kbd>'</kbd>: quit application


