# Запуск

Чтобы запустить интерпретатор, Вам нужно:
- открыть среду разработки RARS;
- выбрать в меню File > Open;
- найти появившуюся папку rars-v и открыть файл rars-v.s;
- ассемблировать файл, выбрав в меню Run > Assemble (или нажав F3);
- запустить программу, выбрав в меню Run > Go (или нажав F5).

Также можно запустить программу через командную строку из папки rars-v:

java -jar rars.jar rars-v.s
(где вместо "rars.jar" писать путь к Java-архиву RARS, а вместо "rars-v.s" - путь к файлу ассемблера rars-v.s)

Для выполнения кода из файла используйте команду:

java -jar rars.jar rars-v.s pa source1.f source2.f source3.f
(где вместо "rars.jar" писать путь к Java-архиву RARS, а вместо "rars-v.s" - путь к файлу ассемблера rars-v.s, после слова "pa" следуют пути к запускаемым файлам)

# Реализованные операции

## Математические
- операторы "+", "-", "*" и "/" соответственно складывают, вычитают, умножают и делят два числа на вершине стека;
- оператор "mod" находит остаток от деления второго от верха числа на самое верхнее;
- оператор "=" проверяет равенство двух чисел на вершине стека (0 = ложь, -1 = истина);
- оператор "0=" проверяет равенство верхнего числа с 0 (аналогично "0 =");
- операторы "<" и ">" сравнивают два числа на вершине стека (0 = ложь, -1 = истина);
- операторы "negative" и "positive" проверяют знак числа (положительное / отрицательное) на вершине стека (0 = ложь, -1 = истина).

## Побитовые
- операторы "and", "or", "nand", "nor", xor", "xnor", "invert" - классические побитовые операции.

## Ввод-вывод
- оператор "." выводит число на вершине стека на экран (само число при этом удаляется со стека);
- оператор "emit" выводит значение на вершине стека на экран как символ ASCII (само значение при этом так же удаляется со стека);
- оператор "key" запрашивает символ ASCII с клавиатуры и кладёт его на стек.

## Определение слов
- оператор ":" начинает определение нового слова (имя слова должно идти сразу после оператора), оператор ";" его завершает.

## Ветвление и циклы
- оператор if проверяет верхнее значение стека (при этом само значение удаляется) - если оно нулевое, код до соответствующего оператора "then" (идёт после if) не выполняется;
- оператор "else" выполняет код до соответствующего оператора "then" тогда и только тогда, когда соответствующий оператор "if" обнаружил значение 0;
- оператор "until" if проверяет верхнее значение стека (при этом само значение удаляется) - если оно нулевое, программа переходит к соответствующему оператору "begin" (идёт перед until, сам оператор begin значение на стеке НЕ проверяет!!!)

## Манипуляции со стеком
- оператор "dup" дублирует значение на вершине стека;
- оператор "drop" удаляет значение на вершине стека;
- оператор "swap" меняет местами два значения на вершине стека;
- оператор "over" копирует второе с верха значение на вершину стека;
- оператор "rot" перемещает (не копирует) третье с верха значение на вершину стека.

## Манипуляции с памятью
- оператор "sp@" кладёт на стек адрес вершины стека (до исполнения команды);
- оператор "@" берёт с вершины стека адрес в памяти и кладёт на стек значение, хранящееся по этому адресу;
- оператор "!" берёт с вершины стека адрес в памяти и значение, после чего сохраняет значение по адресу;
- оператор "allot" берёт со стека число N освобождает в памяти место для N байт (N брать кратное 4, т. к. одна ячейка состоит из 4 байт).

# Примеры программ
Примеры программ находятся в папке 'samples'.