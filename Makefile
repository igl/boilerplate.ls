ifeq ($(OS), Windows_NT)
	# set default shell to cmd.exe:
	SHELL = C:\Windows\SysWOW64\cmd.exe
	# silent mkdir for windows:
	MKDIR = node_modules/".bin"/lsc mkdirp-win
else
	MKDIR = mkdir -p
endif

# bins
WATCH       = node make-watch.js
LS          = node_modules/LiveScript
LSC         = node_modules/".bin"/lsc
MOCHA       = node_modules/".bin"/mocha
MOCHAF      = -u tdd -R list -t 5000 -r test-adapter.js --compilers ls:$(LS) -c -S -b --recursive --check-leaks --inline-diffs
STYLC       = node_modules/".bin"/stylus
LESSC       = node_modules/".bin"/lessc
BROWSERIFYC = node_modules/".bin"/browserify

# sources
GLOB_APP    = $(shell find source/api -name "*.ls" -type f | sort)
GLOB_ROUTES = $(shell find source/routes -name "*.ls" -type f | sort)
GLOB_GUI    = $(shell find source/gui -name "*.ls" -type f -maxdepth 1 | sort)
GLOB_STYL   = $(shell find source/styles -name '*.styl' -type f -maxdepth 1 | sort)
GLOB_LESS   = $(shell find source/styles -name '*.less' -type f -maxdepth 1 | sort)
GLOB_JADE   = $(shell find source/views -name '*.jade' -type f | sort)

# destinations
DIRS   = $(shell find source/ -type d | sort | xargs)
APP    = $(GLOB_APP:source/%.ls=build/%.js)
ROUTES = $(GLOB_ROUTES:source/%.ls=build/%.js)
GUI    = $(GLOB_GUI:source/%.ls=build/%.js)
CSS_S  = $(GLOB_STYL:source/styles/%.styl=build/static/css/%.css)
CSS_L  = $(GLOB_LESS:source/styles/%.less=build/static/css/%.css)
VIEWS  = $(GLOB_JADE:source/%=build/%)

# flags
ifeq ($(NODE_ENV), development)
	LESSF = --source-map-map-inline
	STYLF = --line-numbers
else
	LESSF = --clean-css
	STYLF = --compress
endif

# commands
default: build

install:
	@npm install
	@make clean build

build: $(APP) $(ROUTES) $(GUI) $(CSS_S) $(CSS_L) $(VIEWS)
	@echo { "NODE_ENV": "$(NODE_ENV)" } > "build/.$(NODE_ENV)"

run: build
	@node .

watch: build
	@$(WATCH) $(DIRS)

test: build
	@$(MOCHA) specs $(MOCHAF)

watch-test: build
	@$(WATCH) "--test" "$(DIRS)"

clean:
	rm -rf build

.PHONY: default install build run  test watch watch-test clean

# targets
build/api/%.js: source/api/%.ls
	@$(MKDIR) $(shell dirname $@)
	$(LSC) --bare -o "$(shell dirname $@)" -c "$<"

build/routes/%.js: source/routes/%.ls
	@$(MKDIR) $(shell dirname $@)
	$(LSC) --bare -o "$(shell dirname $@)" -c "$<"

build/gui/%.js: source/gui/%.ls
	@$(MKDIR) "$(shell dirname $@)"
	$(BROWSERIFYC) -e "$<" -o "$@" -t liveify

build/static/css/%.css: source/styles/%.styl
	@$(MKDIR) "$(shell dirname $@)"
	$(STYLC) "$<" -o "$(shell dirname $@)" $(STYLF)

build/static/css/%.css: source/styles/%.less
	@$(MKDIR) "$(shell dirname $@)"
	$(LESSC) "$<" "$@" $(LESSF)

build/views/%.jade: source/views/%.jade
	@$(MKDIR) "$(shell dirname $@)"
	cp "$<" "$@"
