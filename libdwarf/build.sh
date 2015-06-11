wget http://sourceforge.net/code-snapshots/git/l/li/libdwarf/code.git/libdwarf-code-a33289863d582e5e74f2f34dfdcbe6ec7fb76227.zip
wget http://www.mr511.de/software/libelf-0.8.13.tar.gz
tar -xzf libelf-0.8.13.tar.gz
unzip -q libdwarf-code-a33289863d582e5e74f2f34dfdcbe6ec7fb76227.zip
mv libdwarf-code-a33289863d582e5e74f2f34dfdcbe6ec7fb76227 libdwarf

export HERE=`pwd`
export LDFLAGS="-L$HERE/lib/"
export CFLAGS="-I$HERE/include/libelf -I$HERE/include/"
export CPPFLAGS="-I$HERE/include/libelf -I$HERE/include/"
export CXXFLAGS="-I$HERE/include/libelf -I$HERE/include/"
cd libelf-0.8.13/
./configure --prefix=$HERE --enable-compat
make
make install
cd ..
cd libdwarf
./configure --prefix=$HERE
cd dwarfdump2
./configure --prefix=$HERE
cd ..
cd dwarfexample/
sed -i -e "s|LIBDIR= -L\.\.\/libdwarf|LIBDIR= -L../libdwarf -L$HERE/lib/|g" Makefile
cd ..
make
