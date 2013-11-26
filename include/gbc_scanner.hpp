#ifndef GBC_SCANNER_HPP
#define GBC_SCANNER_HPP

#ifndef yyFlexLexerOnce
#include <FlexLexer.h>
#endif

#undef YY_DECL
#define YY_DECL int GBC::Scanner::yylex()

#include "gbc_disassemble.tab.hpp"

namespace GBC
{
	class Scanner 
	: public yyFlexLexer
	{
	public:
		Scanner(std::istream *in) : yyFlexLexer(in), yylval( nullptr ){};
		int yylex(GBC::Disassembler::semantic_type* lval)
		{
			yylval = lval;
			return yylex();
		}
	private:
		int yylex();
		GBC::Disassembler::semantic_type* yylval;
	};
}

#endif