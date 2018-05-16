TARGET := py
SRC := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/src
BUILD := build
CXXFLAGS := -I$(SRC) -g -std=c++17 -Wall -O3
LDFLAGS := -g

rwildcard = $(foreach d, $(wildcard $1*), $(call rwildcard, $d/, $2) $(filter $(subst *, %, $2), $d))

SRCS := $(patsubst $(SRC)/%, %, $(call rwildcard, $(SRC)/, *.cpp))
OBJECTS := $(SRCS:%.cpp=%.o)

TOTAL := $(words $(OBJECTS) .)
progress = $(or $(eval PROCESSED := $(PROCESSED) .),$(info [$(words $(PROCESSED))/$(TOTAL)] $1))

vpath %.o $(BUILD)/objects
vpath %.cpp $(SRC)

all: $(TARGET)
	@echo Done!
 
$(TARGET): $(OBJECTS)
	@$(call progress,Linking $@)
	@$(CXX) -o $@ $(OBJECTS:%=$(BUILD)/objects/%) $(LDFLAGS)

%.o: %.cpp
	@$(call progress,Compiling $<)
	@mkdir -p $(BUILD)/objects/$(dir $@)
	@$(CXX) -c $(CXXFLAGS) -o $(BUILD)/objects/$@ $<

clean:
	@echo Cleaning build files
	@rm -rf $(BUILD) $(TARGET)
	
run: all
	@./$(TARGET)

.PHONY: clean