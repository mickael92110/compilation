gcc -c context.c
gcc -c env.c
gcc -c main.c
<<<<<<< HEAD
gcc context.o env.o main.o -o exec
=======
gcc -c env.c
gcc context.o main.o env.o -o exec
>>>>>>> 2405a1288e8e2a53093d1a6ec87fe87186d418e9
./exec
rm *.o
