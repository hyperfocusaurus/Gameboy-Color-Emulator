#ifndef GBC_DRIVER_HPP
#define GBC_DRIVER_HPP

#include "gbc_disassemble.tab.hpp"

namespace GBC
{
	class Driver
	{
	public:
		Driver();
		virtual ~Driver();
		void parse(std::istream& in_file,unsigned int fsize);

		std::ostream& print(std::ostream &stream);
	private:
		GBC::Disassembler* disassembler;
		GBC::Scanner* scanner;

	};
}

#endif