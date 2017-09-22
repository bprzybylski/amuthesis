# Klasa `amuthesis`
Klasa `amuthesis` została stworzona z myślą o studentach ostatnich lat studiów licencjackich, inżynierskich i magisterskich na Wydziale Matematyki i Informatyki Uniwersytetu im. Adama Mickiewicza w Poznaniu, choć równie dobrze może być wykorzystywana na innych uczelniach. Dobrym zwyczajem jest bowiem składać prace dyplomowe z wykorzystaniem systemu LaTeX i bynajmniej nie dotyczy to wyłącznie prac z matematyki i informatyki. Niestety, samodzielnie przygotowanie wszystkich elementów składowych pracy dyplomowej wymaga nie tylko zaawansowanej znajomości systemu LaTeX oraz zasad rządzących składem tekstu, ale przede wszystkim czasu. Klasa `amuthesis` dostarcza więc wszystko to, co jest potrzebne do stworzenia pięknej pracy dyplomowej w języku polskim lub w języku angielskim.

## Zawartość repozytorium
Główny plik klasy `amuthesis`, nazwany `amuthesis.cls`, zawiera definicje poleceń i otoczeń przydatnych w czasie tworzenia pracy dyplomowej. Opiera się przy tym na standardowych klasach: `book` dla prac w języku angielskim oraz `mwbk` dla prac w języku polskim. Klasa `amuthesis` współpracuje z najpopularniejszymi silnikami LaTeXa:

* `pdflatex`
* `xelatex`
* `lualatex`

Poza tym, repozytorium zawiera dodatkowe pliki:

* `thesis.tex` oraz `thesis.pdf` – pliki te zawierają opis możliwości klasy,
* `thesis-empty.tex` oraz `thesis-empty.pdf` – pliki te stanowią szkielet, na którym można oprzeć swoją pracę dyplomową.

## Jak używać klasy `amuthesis`?
* [Pobierz](https://github.com/bprzybylski/amuthesis/archive/master.zip) i wypakuj archiwum `zip` z aktualną zawartością repozytorium.
* Zapoznaj się z zawartością pliku `thesis.pdf`.
* Uzupełnij plik `thesis.empty.tex` treścią i skopiluj go z wykorzystaniem jednego z trzech wymienionych wyżej kompilatorów.
