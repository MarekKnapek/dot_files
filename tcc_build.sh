set -x
set -e
#git clone https://repo.or.cz/tinycc.git
cd tinycc
my_root=~

./configure --prefix=${my_root}/opt/tcc
make
make install
git clean -dfx
git reset --hard

CC=${my_root}/opt/tcc/bin/tcc bash -c "./configure --prefix=${my_root}/opt/tcc"
make
rm -rf ${my_root}/opt/tcc
make install
git clean -dfx
git reset --hard

CC=${my_root}/opt/tcc/bin/tcc bash -c "./configure --prefix=${my_root}/opt/tcc"
make
rm -rf ${my_root}/opt/tcc
make install
git clean -dfx
git reset --hard

CC=${my_root}/opt/tcc/bin/tcc bash -c "./configure --prefix=${my_root}/opt/tcc"
make
rm -rf ${my_root}/opt/tcc
make install
git clean -dfx
git reset --hard

cd ..
