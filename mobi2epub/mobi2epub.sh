#!/bin/zsh
find . -name "*.mobi" -exec ebook-convert {} {}.epub \;
zmv '(*).mobi.epub' '$1.epub'
