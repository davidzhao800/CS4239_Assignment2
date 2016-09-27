SRCDIR := src
BUILDDIR := build
BINDIR := bin
TARGET := $(BINDIR)/runner
SOURCES := $(shell find $(SRCDIR) -type f -name *.cpp)
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.cpp=.o))

all: $(TARGET)

$(TARGET): $(OBJECTS)
	@echo " Linking..."
	@mkdir -p $(BINDIR)
	clang++-3.4 -std=c++11 $^ -o $@ -D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS `llvm-config -cppflags` `llvm-config --ldflags` `llvm-config --libs` -lpthread -lncurses -ldl

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(BUILDDIR)
	clang++-3.4 -std=c++11 -c -o $@ $< -D__STDC_CONSTANT_MACROS -D__STDC_LIMIT_MACROS `llvm-config -cppflags` `llvm-config --ldflags` `llvm-config --libs` -lpthread -lncurses -ldl

clean:
	@echo " Cleaning..."
	rm -r $(BINDIR) $(BUILDDIR)

.PHONY: clean
