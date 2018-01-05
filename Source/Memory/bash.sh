g++ *.cpp -c -std=c++14 -I /tmp/usr/local/include/
g++ *.o -o cpu-judge -L /tmp/usr/local/lib/ -lboost_program_options -lserial
