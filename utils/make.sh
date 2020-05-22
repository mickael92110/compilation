gcc -c context.c
gcc -c main.c
gcc -c env.c
gcc context.o main.o env.o -o exec
./exec
rm *.o
