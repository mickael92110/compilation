make realclean
make
echo
cp ./minicc ./Tests/Syntaxe/OK/
cd Tests/Syntaxe/OK/
list=`ls *.c`
for i in $list
do
  echo Nom fichier : $i :
  ./minicc -s $i
  echo return  : $?
  echo
done
rm minicc
echo Fin script test syntax OK
  
