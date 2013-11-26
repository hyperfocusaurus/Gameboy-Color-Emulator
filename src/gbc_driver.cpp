#include <cassert>
#include <fstream>
#include "gbc_driver.hpp"
#include "gbc_scanner.hpp"

namespace GBC
{
	Driver::Driver()
	{
		scanner = nullptr;
		disassembler = nullptr;
	}

	Driver::~Driver()
	{

	}

	void Driver::parse(std::istream& in_file,unsigned int fsize)
	{
		if(scanner)
			delete scanner;
		try
		{
			scanner = new GBC::Scanner(&in_file);
		}
		catch(std::bad_alloc& ba)
		{
			std::cerr << "Error: could not allocate memory for scanner: " << ba.what() << std::endl;
			exit(-1);
		}
		if(disassembler)
			delete disassembler;
		try
		{
			disassembler = new GBC::Disassembler((*scanner),(*this));
		}
		catch(std::bad_alloc& ba)
		{
			std::cerr << "Error: could not allocate memory for parser: " << ba.what() << std::endl;
			exit(-1);
		}
		while(fsize--)
		{
			disassembler->parse();
		}
	}

	std::ostream& Driver::print(std::ostream &stream)
	{
		return stream;
	}
}