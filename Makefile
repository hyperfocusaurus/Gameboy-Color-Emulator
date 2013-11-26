# choose C++ compiler explicitly
CXX := g++


# directories
SRC_DIR := src
GEN_SRC := $(SRC_DIR)/generated
OBJ := obj

# C++ flags
CXXFLAGS := -Iinclude -I$(GEN_SRC) -std=c++0x -g

# LD flags
LDFLAGS := -lboost_program_options

# DO NOT ATTEMPT AN IN-SOURCE BUILD WITH THIS MAKEFILE.  YOU WILL NUKE EVERYTHING ON MAKE CLEAN!!!
BUILD := build

.PHONY: default
default: disasm

disasm: $(SRC_DIR)/disasm_main.cpp $(OBJ)/gbc_driver.o $(OBJ)/disassembler.o $(OBJ)/rom_lexer.o | $(BUILD)
	$(CXX) $(LDFLAGS) $(CXXFLAGS) $? -o $(BUILD)/disasm

$(GEN_SRC)/gbc_disassemble.tab.cpp: $(SRC_DIR)/gbc_disassemble.yy | $(GEN_SRC)
	bison -d -v $< -o $(GEN_SRC)/gbc_disassemble.tab.cpp

$(OBJ)/disassembler.o: $(GEN_SRC)/gbc_disassemble.tab.cpp | $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(GEN_SRC)/gbc_disassemble.tab.cpp -o $(OBJ)/disassembler.o

$(GEN_SRC)/gbc_rom.cpp: $(SRC_DIR)/gbc_rom.lex | $(GEN_SRC)
	flex --outfile=$(GEN_SRC)/gbc_rom.cpp $<

$(OBJ)/rom_lexer.o: $(GEN_SRC)/gbc_rom.cpp | $(OBJ)
	$(CXX) $(CXXFLAGS) -c $(GEN_SRC)/gbc_rom.cpp -o $(OBJ)/rom_lexer.o

$(OBJ)/gbc_driver.o: $(SRC_DIR)/gbc_driver.cpp | $(OBJ)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ):
	mkdir -p $(OBJ)

$(GEN_SRC):
	mkdir -p $(GEN_SRC)

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(OBJ)
	rm -rf $(BUILD)