cp ./minicc ./Tests/Syntaxe/OK/
cd Tests/Syntaxe/OK/
list=`ls *.c`
for i in $list
do
  ./minicc -s $i
  echo $?
done
rm minicc 
echo fin script test
