# Introducing toc-css

Pandoc Lua Filter to add floating table of contents to HTML

**Michael Cysouw** <cysouw@mac.com>

## Pandoc

[Pandoc](https://pandoc.org) is a fabulous system to prepare text and export it to (almost) every format of your liking. Pandoc includes an option to add a table of contents, but by default this is just added at the top of the document. This Lua filter adds some better layout of the table of contents for HTML documents.

The filter adds a bit CSS and vanilla Javascript to the HTML output as created by the Pandoc defaults. The actual html is not changed in any way. If you have not added a title for the table of contents then the title "Contents" is automatically added.

Please note that I am not a very proficient CSS/Javascript programmer. I welcome suggestions and improvements! The current version was specifically made for a long book with a very complex structure, the current version can be found [here](https://cysouw.github.io/diathesis/) as an example.

## Usage

- For this filter to work, the HTML export needs to have the options `--standalone` and `--toc` to produce the basic table of contents.
- To add a title to the table of contents, either add the following to your metadata: `toc-title: MY-TITLE` or add the option `--metadat=toc-title:"MY-TITLE"` when producing the HTML.
- The filter itself is added by using `--lua-filter toc-css.lua`.

As an example, consider the following command to convert this `README.md` into [`README.html`](https://cysouw.github.io/toc-css/README.html):

```
pandoc README.md \
    --to html \
    --output docs/README.html \
    --lua-filter toc-css.lua \
    --standalone \
    --toc \
    --number-sections \
    --metadata toc-title="Table of Contents" \
    --metadata title="Introducing toc-css"
```

## Functionality

- If the window is large enough, the table of contents will be shown to the side. With smaller windows it will be hidden. Show/hide also works on resizing the window.
- Clicking on the 'hamburger' will expand the view. The tab-key will also expand the view. Clicking again on the 'hamburger' will hide the contents again. The escape-key also works, and so does clicking anywhere outside of the expanded view.
- Clicking on the triangle to the right of the title will fix the contents to the side, or hide it.

# Another first level heading

The remaining headers in this readme are only added to showcase the result in the HTML file.

## With subheading

### Going deeper

### More

### Let's try a completely long and superfluous title

## Another subheading

### Example 1

### Example 2

### Example 3

# Next Chapter

## Next Subheading

## Another very long title that will not fit
