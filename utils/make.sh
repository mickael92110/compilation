gcc -c context.c
gcc -c main.c
gcc context.o main.o -o exec
./exec
rm *.o
