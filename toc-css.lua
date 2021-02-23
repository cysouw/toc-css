--[[
toc-css.lua: lua script to add CSS and Vanilla Javascript to native Pandoc HTML output
Formats HTML table of content as produced by Pandoc to the top left of the document

Copyright © 2021 Michael Cysouw <cysouw@mac.com>

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
]]

css = [[ 
<!-- CSS added by filter 'toc-css.lua' for TOC hovering to the side -->
<style>
body {
  padding-left: 1cm;
  padding-right: 1cm;
  transition: 0.5s;
}
nav {
  width: 1em;
  margin-left: -1cm;
  font-size: smaller;
  color: grey;
  transition: 0.5s;
  float: left;
  position: fixed;
  top: 0;
  bottom: 0;
  white-space: nowrap; 
  overflow: hidden;
  overflow-y: scroll;
  transition: 0.5s;
}
nav::-webkit-scrollbar {
  display: none;
}
nav a, nav a:visited {
  color: grey;
}
nav h2:before {
  content: "≡ ";
  font-size: 150%;
}
nav h2:after {
  content: " ◀";
}
nav li {
  margin-left: -0.5em;
  white-space: nowrap; 
  overflow: hidden;
  text-overflow: ellipsis;
}
nav li > a:not(:only-child):before {
  content: "▶ ";
}
nav li > a:only-child {
  margin-left: 0.75em;
}
nav li li {
  margin-left: 1em;
}
nav li li li {
  margin-left: -0.5em;
  font-size: smaller;
}
nav ul li ul  {
  visibility: hidden;
  display: none;
  margin-top: 0.2em;
  margin-bottom: 0.2em;
  transition: 0.5s;
}
.bodysmall {
  padding-left: 9cm;
  transition: 0.5s;
}
.navside {
  width: 7cm;
  margin-left: -8.5cm;
  padding-right: 1cm;
  transition: 0.5s;
}
.navside h2:after {
  content: " ▶";
}
.navshown {
  width: 50%;
  transition: 0.5s;
  background-color: rgba(255, 255, 255, 0.95);
}
.subShow > ul {
  visibility: visible;
  display: block;
  transition: 0.5s;
  margin-left: -1em;
}
.subShow > a:not(:only-child):before {
  content: "▼ ";
}
</style>
]]

-----------------------------

script = [[

<!-- Javascript added by toc-css.lua to make TOC expandable on click -->
<script>

  const b = document.querySelector("body");
  const n = document.querySelector("nav");
  const buttonsize = 15;

  // click on "toc-title" to show TOC to the side
  document.querySelector("#toc-title").addEventListener("click", function(e) {
    if (e.clientX < e.currentTarget.getBoundingClientRect().left + buttonsize) {
      n.classList.toggle("navshown");
    } else {
      b.classList.toggle("bodysmall");
      n.classList.toggle("navside");
      n.classList.remove("navshown");
    };
  });

  // by default show TOC in large window
  window.onload = function() {
    if (window.innerWidth > 1000) {
      b.classList.add("bodysmall");
      n.classList.add("navside");
    };
  };

  // show/hide TOC on resize
  window.onresize = function () {
    if (window.innerWidth > 1000) {
      b.classList.add("bodysmall");
      n.classList.add("navside");
    } else {
      b.classList.remove("bodysmall");
      n.classList.remove("navside");
    };
  };

  // show/hide subsections
  function toggleSub(lis) {
    for (const li of lis) {
      li.addEventListener('click', function (e) {
        if (e.clientX < e.currentTarget.getBoundingClientRect().left + buttonsize) {
          li.classList.toggle('subShow');
          e.preventDefault();
        };
      });
    };
  };

  const allLis = document.querySelectorAll("nav li");
  toggleSub(allLis);

</script>
]]

----------------------------

function addCSS (meta)
  -- read current "header-includes" from metadata, or make a new one
  -- and add css to the end of "header-includes"
  local current = meta['header-includes'] or pandoc.MetaList{meta['header-includes']}
  current[#current+1] = pandoc.MetaBlocks(pandoc.RawBlock("html", css))
  meta['header-includes'] = current
  -- add default toc-title if there is none
  if meta['toc-title'] == nil then
    meta['toc-title'] = "CONTENTS"
  end
  -- return metadata
  return(meta)
end

----------------------------

function addScript (doc)
  -- add javascript to the end of the document
  table.insert(doc.blocks, pandoc.RawBlock("html", script) )
  return(doc)
end

----------------------------

return {
  { Meta = addCSS },
  { Pandoc = addScript }
}
