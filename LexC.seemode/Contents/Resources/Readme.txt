LexC mode for SubEthaEdit
=========================

This is a syntax colouring mode for the LexC language as documented in:

Kenneth R. Beesley & Lauri Karttunen (2003): Finite State Morphology

In addition to the language syntax, it has support for a couple of (not so) widely used conventions:

- analysis tags will be correctly coloured if on the form +Tag, e.g. +Nom, +Sg, etc.
  as well as in the style <N><Pl><nom> (Apertium style)
- morphological borders will get a separate colour. Three border types are recognised:
    - inflectional borders: %< (prefix) %> (suffix)
    - derivational borders: « (prefix derivation) » (suffix derivation)
    - word boundary: #
- digraphs of the type LetterNumber (a1) etc, often used to encode archephonemes, are recognised
- Triggers of the form %^xxUPPER, often used as multichar symbos to trigger morphophonological processes

The mode makes heavy use of boldfacing, and is best viewed by turning on the synthesised boldface and italic (Preferences > Advanced > Font Rendering > Add synthesised bold and italic to fonts)

There are a couple of known bugs, please see the Changelog.txt file for details.

Feedback welcome to sjur.n.moshagen@uit.no or divvun@samediggi.no
