# SEE Modes for GiellaLT

This repo holds syntax modes for [SubEthaEdit](https://subethaedit.net) (SEE among friends) for the following types of text files:

* [ConstraintGrammar](https://visl.sdu.dk/cg3.html)
* Corpus analysis (Constraint Grammar output)
* [LexC](https://fomafst.github.io/morphtut.html)
* Twolc
* Typos
* Xfst

They are a.o. used in the development of language resources in the [GiellaLT infrastructure](https://github.com/giellalt).

**LexC**, **Twolc** and **Xfst** are tools & formalisms by Xerox. The tools are freely available at <https://web.stanford.edu/~laurik/fsmbook/home.html> (although closed-source), and both the tools and formalisms are documented in the book linked to on that site. The same formalisms are supported by the open-source tools [**Foma**](https://fomafst.github.io) and [**Hfst**](https://hfst.github.io), ie they are source-code compatible with the Xerox tools.

**Typos** files are simple TAB separated, two column files containing real typos and their corrections. These files are used for testing spelling checkers, and the syntax colouring helps us check that the content is entered correctly.

# What's New in 0.3.1

**LexC mode 2.7.1** bugfix:
- 🐛 Fixed trailing newline handling in output

**LexC mode 2.7.0** (from 0.3.0) major improvements:
- 🆕 External [Divvun-SEE-helper](https://github.com/divvun/divvun-see-helper) bypasses macOS sandbox restrictions
- ✨ Words without suggestions are now preserved in output
- 🧹 Automatic cleanup of extra blank lines
- 🔧 Fixed UTF-8 handling for Sámi special characters

See [CHANGELOG.md](CHANGELOG.md) for full details.

# Install

1. Download the [latest release](https://github.com/divvun/see-modes/releases)
1. Unpack the downloaded package if it was not automatically unpacked
1. Double click on the SEE modes you want to install, and accept to install them

# Use

Make sure the wanted mode is displayed in the mode selection area - click and select if not:

![SEE Mode Selection area](images/SEE-mode-selection-area.png)
![SEE Mode Selection     ](images/SEE-mode-selection.png)

With the mode active, you can access mode-specific tools to be used on the whole document or the selection by choosing from the **Mode** menu or from the context menu, as well as lexicons or rules from the **Function** popup menu:

![SEE Mode Menu          ](images/SEE-mode-menu.png)
![SEE Context Menu       ](images/SEE-context-menu.png)

You can also use the keyboard shortcuts displayed in the menu.

# License

MIT - [LICENSE](LICENSE) or <http://opensource.org/licenses/MIT> (same as SubEthaEdit).

# Contribution

… is very welcome! 🙂

Fork and PR on Github.

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you shall be licensed as above, without any additional terms or conditions.
