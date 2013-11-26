#include <boost/program_options.hpp>
#include <fstream>
#include "gbc_driver.hpp"

#define VERSION "0.0.1"

namespace po = boost::program_options;

int main(const int argc, const char** argv)
{
	std::istream* infile;
	unsigned int fsize = -1;
	po::options_description desc("Allowed options");
	desc.add_options()
		("help,h","produce help message")
		("version,v","produce version information")
		("infile,i",po::value<std::string>()->required(),"input (rom) file")
	;
	po::positional_options_description positionalOptions; 
	positionalOptions.add("infile", -1); 

	po::variables_map vm;
	po::store(po::command_line_parser(argc, argv).options(desc) 
                  .positional(positionalOptions).run(),vm);
	po::notify(vm);

	if(vm.count("help")) {
		std::cout << desc << std::endl;
		return 1;
	}

	if(vm.count("version")) {
		std::cout << VERSION << std::endl;
		return 1;
	}

	if(vm.count("infile")) {
		std::ifstream* infile_tmp = new std::ifstream();
		infile_tmp->open(vm["infile"].as<std::string>().c_str(),std::ios::in|std::ios::binary|std::ios::ate);
		infile = (std::istream*) infile_tmp;
		fsize = infile_tmp->tellg();
		infile_tmp->seekg(0,std::ios::beg);
	} else {
		infile = &std::cin;
		fsize = std::cin.tellg();
	}
	if(!infile->good())
	{
		std::cerr << "Error: could not open " << vm["infile"].as<std::string>() << " for reading." << std::endl;
		exit(-1);
	}

	GBC::Driver driver;
	driver.parse(*infile,fsize);
	driver.print(std::cout) << "\n";

	return 0;
}