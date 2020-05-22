gcc -c context.c
gcc -c env.c
gcc -c main.c
gcc context.o env.o main.o -o exec
./exec
rm *.o
