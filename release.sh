#!/bin/bash
THEME_PATH=$PWD
CSS=$PWD/source/css
JS=$PWD/source/js
CSS_CURRENT=$(find $CSS/style-v*.css)
FONTS_CURRENT=$(find $CSS/fonts-v*.css)
JS_CURRENT=$(find $JS/js-v*.js)
CSS_FILES=$PWD/source/css/files
JS_FILES=$PWD/source/js/files
DATE=$(date +%Y%m%d)
PARTIALS=$THEME_PATH/layout/partials

cd $CSS
find style-v*.css > $THEME_PATH/tmp_css.sh
find fonts-v*.css > $THEME_PATH/tmp_fonts.sh
sed -i "s/.css//" $THEME_PATH/tmp_css.sh
sed -i "s/.css//" $THEME_PATH/tmp_fonts.sh
sed -i "s/^/HEAD_CURRENT=/" $THEME_PATH/tmp_css.sh
sed -i "s/^/FONTS_CURRENT=/" $THEME_PATH/tmp_fonts.sh
rm $CSS_CURRENT
rm $FONTS_CURRENT
source $THEME_PATH/tmp_css.sh
source $THEME_PATH/tmp_fonts.sh

cd $CSS_FILES
uglifycss outdatedbrowser.css mdui.custom.css font-awesome.css lightgallery.css lg-transitions.css prism-themes.css main.css --output ../style-v$DATE.min.css
uglifycss fonts.css --output ../fonts-v$DATE.min.css

cd $JS
find js-v*.js > $THEME_PATH/tmp_js.sh
sed -i "s/.js//" $THEME_PATH/tmp_js.sh
sed -i "s/^/IMPORT_JS_CURRENT=/" $THEME_PATH/tmp_js.sh
rm $JS_CURRENT
source $THEME_PATH/tmp_js.sh

cd $JS_FILES
uglifyjs mdui.custom.js lightgallery.js lg-hash.js lg-zoom.js lg-fullscreen.js lg-autoplay.js smooth-scroll.js es6-promise.js fetch.js main.js --output ../js-v$DATE.min.js

cd $PARTIALS
sed -i "s/$HEAD_CURRENT/style-v$DATE.min/" head.ejs
sed -i "s/$FONTS_CURRENT/fonts-v$DATE.min/" head.ejs
sed -i "s/$IMPORT_JS_CURRENT/js-v$DATE.min/" import_js.ejs

cd $THEME_PATH
rm $THEME_PATH/tmp_css.sh $THEME_PATH/tmp_js.sh $THEME_PATH/tmp_fonts.sh