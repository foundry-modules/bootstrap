all: clear build bootstrap

include ../../build/modules.mk

MODULE = bootstrap3

SOURCE_SCRIPT_FILES = dist/js/bootstrap.js \
modules/notify/js/bootstrap-notify.js

NOTIFY_STYLE_FILES = modules/notify/css/bootstrap-notify.css \
modules/notify/css/styles/alert-bangtidy.css \
modules/notify/css/styles/alert-blackgloss.css

build:
	grunt dist

fd:
	echo "var jQuery = $$;" | \
		cat - ${TARGET_SCRIPT_UNCOMPRESSED} | \
		sed 's/data-dismiss/data-bp-dismiss/g' | \
		sed 's/data-toggle/data-bp-toggle/g' | \
		sed 's/data-spy/data-bp-spy/g' | \
		sed 's/data-ride/data-bp-ride/g' | \
		sed 's/data-slide/data-bp-slide/g' | \
		sed 's/data-slide-to/data-bp-slide-to/g' | \
		sed 's/'\''.modal'\''/'\''.modal.bs'\''/g' | \
		sed 's/'\''.dropdown form'\''/'\''.dropdown.bs form'\''/g' \
		> ${TARGET_SCRIPT_RAW}

	rm -fr ${TARGET_SCRIPT_UNCOMPRESSED}
	mv ${TARGET_SCRIPT_RAW} ${TARGET_SCRIPT_UNCOMPRESSED}

bootstrap: join-script-files fd wrap-script resolve-namespace minify-script create-style-folder

	cp -Rp less/*.less ${TARGET_STYLE_FOLDER}
	mkdir -p ${TARGET_STYLE_FOLDER}/fonts
	cp -Rp fonts/* ${TARGET_STYLE_FOLDER}/fonts

	# variables.less
	cat ${TARGET_STYLE_FOLDER}/variables.less | sed 's/..\/fonts\//\@\{global_uri\}\/bootstrap3\/fonts\//g' > ${TARGET_STYLE_FOLDER}/variables.raw
	rm -fr ${TARGET_STYLE_FOLDER}/variables.less
	mv ${TARGET_STYLE_FOLDER}/variables.raw ${TARGET_STYLE_FOLDER}/variables.less

	# modules/notify
	cat ${NOTIFY_STYLE_FILES} > ${TARGET_STYLE_FOLDER}/notify.less
	cat modules/notify/css/styles/alert-blackgloss-animations.css > ${TARGET_STYLE_FOLDER}/notify-animations.less
