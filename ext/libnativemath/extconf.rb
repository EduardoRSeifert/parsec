# ext/extconf.rb
require 'mkmf'
require "bundler/gem_tasks"

LIBDIR     = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']
MUPARSER_HEADERS = 'ext/equations-parser/parser'
MUPARSER_LIB = 'ext/equations-parser'

HEADER_DIRS = [INCLUDEDIR, MUPARSER_HEADERS]

puts HEADER_DIRS
puts LIBDIR

# setup constant that is equal to that of the file path that holds that static libraries that will need to be compiled against
LIB_DIRS = [LIBDIR, MUPARSER_LIB]

# array of all libraries that the C extension should be compiled against
libs = ['-lmuparserx']

dir_config('.', HEADER_DIRS, LIB_DIRS)

# iterate though the libs array, and append them to the $LOCAL_LIBS array used for the makefile creation
libs.each do |lib|
  $LOCAL_LIBS << "#{lib} "
end

Dir.chdir("ext/equations-parser/") do
  sh "cmake CMakeLists.txt -DCMAKE_BUILD_TYPE=Release"
  sh "make"
end

Dir.chdir("ext/libnativemath/") do
  sh "swig -c++ -ruby libnativemath.i"
  #ruby "extconf.rb"
  #sh "make"
end

create_makefile('ext/libnativemath/libnativemath')