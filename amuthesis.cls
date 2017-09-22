\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{amuthesis}[2017/10/01 AMU Thesis]

% ======================================================== %
% Obsługa opcji pakietu                                    %
% ======================================================== %

% Język dokumentu
\newif\if@optpolski
\DeclareOption{polski}{\@optpolskitrue}
\ExecuteOptions{polski}
\DeclareOption{english}{\@optpolskifalse}

% Wcięcia pierwszych akapitów w paragrafie
\newif\if@optindent
\DeclareOption{indent}{\@optindenttrue}

% Zamiana numeru i nazwy otoczenia
\newif\if@optswapthm
\DeclareOption{swapthm}{\@optswapthmtrue}

% Numerowanie wierszy
\newif\if@optlineno
\DeclareOption{lineno}{\@optlinenotrue}

% Wsparcie dla stron pustych
\newif\if@optleftblank
\DeclareOption{leftblank}{\@optleftblanktrue}

% Skład jedno- i dwustronny
\DeclareOption{oneside}{
  \PassOptionsToClass{oneside}{mwbk}
  \PassOptionsToClass{oneside}{book}
}
\DeclareOption{twoside}{
  \PassOptionsToClass{twoside}{mwbk}
  \PassOptionsToClass{twoside}{book}
}

% Obsłuż nieznane opcje
\DeclareOption*{
  \ClassWarning{amuthesis}{Nieznany parametr klasy: \CurrentOption}
}

% Przetwórz opcje
\ProcessOptions\relax

% Oprzyj dokument na jednym z zestawów, w zależności
% od statusu opcji 'optpolski'
\if@optpolski
  \LoadClass[oneside,11pt]{mwbk}
  \RequirePackage{polski}
\else
  \LoadClass[oneside,11pt]{book}
\fi

% Uruchom numerację wierszy, jeśli do klasy przekazano
% opcję 'lineno'
\if@optlineno
  \RequirePackage[mathlines]{lineno}
  \newcommand*\patchAmsMathEnvironmentForLineno[1]{%
  \expandafter\let\csname old#1\expandafter\endcsname\csname #1\endcsname
  \expandafter\let\csname oldend#1\expandafter\endcsname\csname end#1\endcsname
  \renewenvironment{#1}%
    {\linenomath\csname old#1\endcsname}%
    {\csname oldend#1\endcsname\endlinenomath}}%
  \newcommand*\patchBothAmsMathEnvironmentsForLineno[1]{%
    \patchAmsMathEnvironmentForLineno{#1}%
    \patchAmsMathEnvironmentForLineno{#1*}}%
  \AtBeginDocument{%
    \patchBothAmsMathEnvironmentsForLineno{equation}%
    \patchBothAmsMathEnvironmentsForLineno{align}%
    \patchBothAmsMathEnvironmentsForLineno{flalign}%
    \patchBothAmsMathEnvironmentsForLineno{alignat}%
    \patchBothAmsMathEnvironmentsForLineno{gather}%
    \patchBothAmsMathEnvironmentsForLineno{multline}%
  }
  \linenumbers
\fi

% ======================================================== %
% Podstawowe pakiety i ustawienia dokumentu                %
% ======================================================== %

\RequirePackage{ifxetex}
\RequirePackage{ifluatex}
\newif\if@xetexorluatex
\ifxetex
  \@xetexorluatextrue
\else
  \ifluatex
    \@xetexorluatextrue
  \else
    \@xetexorluatexfalse
  \fi
\fi

% Obsługa fontów
\if@xetexorluatex
  %\RequirePackage{unicode-math}
  \RequirePackage{fontspec}
  \RequirePackage{mathpazo}
  \RequirePackage{avant}
  \setmainfont
       [ BoldFont       = texgyrepagella-bold.otf ,
         ItalicFont     = texgyrepagella-italic.otf ,
         BoldItalicFont = texgyrepagella-bolditalic.otf ]
       {texgyrepagella-regular.otf}
  \newfontfamily\scshape[Letters=SmallCaps]{texgyrepagella-regular.otf}
\else
  \RequirePackage[sc]{mathpazo}
  \RequirePackage{avant}
\fi
% Dołącz font 'Souce Code Pro'
\RequirePackage[scale=.93,semibold]{sourcecodepro}

% Ustal rozmiar dokumentu
\RequirePackage{geometry}
\geometry{a4paper,%
          innermargin=3.75cm,%
          outermargin=3.75cm,%
          tmargin=4.0cm,%
          bmargin=4.0cm,%
          headsep=24pt,%
          footskip=42pt}

% Zapewnij poprawną interakcję wewnątrz pliku PDF
\RequirePackage[hidelinks,unicode]{hyperref}

% Obsłuż opis pustych stron
\newcommand*{\leftblank}[1]{\gdef\@leftblank{#1}}
\newcommand*{\@leftblank}{}
\leftblank{Ta strona jest pusta.}

\if@optleftblank
  \def\cleardoublepage{%
    \clearpage\if@twoside%
    \ifodd\c@page%
    \else
      \vspace*{\fill}
      \hfill
      \begin{center}
      \@leftblank
      \end{center}
      \vspace{\fill}
      \thispagestyle{empty}
      \newpage
      \if@twocolumn\hbox{}\newpage\fi
    \fi
  \fi
  }
\fi

% Dołącz podstawowe pakiety
\RequirePackage{xcolor}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{graphicx}
\RequirePackage{microtype}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{longtable}
\RequirePackage{makecell}
\RequirePackage{booktabs}

% ======================================================== %
% Otoczenia                                                %
% ======================================================== %

\if@optpolski
  \newcommand*{\amsthmtheorem}{Twierdzenie}
  \newcommand*{\amsthmlemma}{Lemat}
  \newcommand*{\amsthmstatement}{Hipoteza}
  \newcommand*{\amsthmproposition}{Stwierdzenie}
  \newcommand*{\amsthmcorollary}{Wniosek}

  \newcommand*{\amsthmdefinition}{Definicja}
  \newcommand*{\amsthmexample}{Przyk\l{}ad}
  \newcommand*{\amsthmtask}{Zadanie}
  \newcommand*{\amsthmexercise}{\'Cwiczenie}

  \newcommand*{\amsthmremark}{Spostrze\.zenie}
  \newcommand*{\amsthmnote}{Obserwacja}
\else
  \newcommand*{\amsthmtheorem}{Theorem}
  \newcommand*{\amsthmlemma}{Lemma}
  \newcommand*{\amsthmstatement}{Statement}
  \newcommand*{\amsthmproposition}{Proposition}
  \newcommand*{\amsthmcorollary}{Corollary}

  \newcommand*{\amsthmdefinition}{Definition}
  \newcommand*{\amsthmexample}{Example}
  \newcommand*{\amsthmtask}{Task}
  \newcommand*{\amsthmexercise}{Exercise}

  \newcommand*{\amsthmremark}{Remark}
  \newcommand*{\amsthmnote}{Note}
\fi

\if@optswapthm
\def\swappedhead#1#2#3{%
\if@optpolski
\thmnumber{#2.}%
\else
\thmnumber{#2}%
\fi
\thmname{\@ifnotempty{#2}{~}#1}%
\thmnote{ {\the\thm@notefont(#3)}}}
\swapnumbers
\fi

\theoremstyle{plain}
\newtheorem{theorem}{\amsthmtheorem}[chapter]
\newtheorem{twierdzenie}[theorem]{\amsthmtheorem}
\newtheorem{lemma}[theorem]{\amsthmlemma}
\newtheorem{lemat}[theorem]{\amsthmlemma}
\newtheorem{statement}[theorem]{\amsthmstatement}
\newtheorem{hipoteza}[theorem]{\amsthmstatement}
\newtheorem{proposition}[theorem]{\amsthmproposition}
\newtheorem{stwierdzenie}[theorem]{\amsthmproposition}
\newtheorem{corollary}[theorem]{\amsthmcorollary}
\newtheorem{wniosek}[theorem]{\amsthmcorollary}

\theoremstyle{definition}
\newtheorem{definition}{\amsthmdefinition}[chapter]
\newtheorem{definicja}[definition]{\amsthmdefinition}
\newtheorem{example}{\amsthmexample}[chapter]
\newtheorem{przyklad}[example]{\amsthmexample}
\newtheorem{task}{\amsthmtask}[chapter]
\newtheorem{zadanie}[task]{\amsthmtask}
\newtheorem{exercise}[task]{\amsthmexercise}
\newtheorem{cwiczenie}[task]{\amsthmexercise}

\theoremstyle{remark}
\newtheorem{remark}[theorem]{\amsthmremark}
\newtheorem{spostrzezenie}[theorem]{\amsthmremark}
\newtheorem{note}[theorem]{\amsthmnote}
\newtheorem{obserwacja}[theorem]{\amsthmnote}

\newenvironment{dowod}{\begin{proof}}{\end{proof}}

% ======================================================== %
% Konfiguracja i polecenia specjalne                       %
% ======================================================== %

% Ustawienia składu pionowego
\linespread{1.15}
\raggedbottom

% Zdefiniuj otoczenia dla abstraktów
\newenvironment{abstract}{\chapter*{Abstract}}{}
\newenvironment{streszczenie}{\chapter*{Streszczenie}}{}

% Zdefiniuj otoczenie dla dedykacji
\newenvironment{dedykacja}{%
  \cleardoublepage\thispagestyle{empty}\mbox{}\vfill
  \hfill\begin{minipage}{0.5\textwidth}
  \begin{flushleft}
}{
  \end{flushleft}
  \end{minipage}
  \vspace*{4cm}
}

% ======================================================== %
% Strona tytułowa                                          %
% ======================================================== %

% Zdefiniuj parametry strony tytułowej
\newcommand*{\titlePL}[1]{\gdef\@titlePL{#1}}
\newcommand*{\@titlePL}{}
\newcommand*{\titleEN}[1]{\gdef\@titleEN{#1}}
\newcommand*{\@titleEN}{}
\newcommand*{\album}[1]{\gdef\@album{#1}}
\newcommand*{\@album}{}
\newcommand*{\type}[1]{\gdef\@type{#1}}
\newcommand*{\@type}{}
\newcommand*{\field}[1]{\gdef\@field{#1}}
\newcommand*{\@field}{}
\newcommand*{\supervisor}[1]{\gdef\@supervisor{#1}}
\newcommand*{\@supervisor}{}

\if@optpolski
  \title{\@titlePL}
\else
  \title{\@titleEN}
\fi

% Zdefiniuj polecenie '\maketitle'
\renewcommand*{\maketitle}{%
  \clearpage\thispagestyle{empty}%
  {\noindent\centering\scshape\large%
    Uniwersytet im. Adama Mickiewicza w Poznaniu%
  \strut\par}%
  {\noindent\centering\normalfont%
    Wydzia\l{} Matematyki i Informatyki%
  \strut\par}%
  \vspace{2.5cm}
  {\noindent\centering\normalfont\@author\strut\par}%
  {\noindent\centering\normalfont%
    Numer albumu: %
    \@album\strut\par}%
  \vspace{2.5cm}
  % Uzależnij kolejność tytułów od wybranego języka
  \if@optpolski
    {\noindent\centering\Large\@titlePL\strut\par}%
    {\noindent\centering\normalfont\@titleEN\strut\par}%
  \else
    {\noindent\centering\Large\@titleEN\strut\par}%
    {\noindent\centering\normalfont\@titlePL\strut\par}%
  \fi
  \vfill
  {\noindent\normalfont\centering{%
    Praca \@type{} na kierunku \@field{}\\
    napisana pod opiek\k{a}\\
    \bfseries{\@supervisor}%
  }\strut\par}%
  \vspace{2.5cm}%
  {\noindent\centering\normalfont\@date\strut\par}
}

% ======================================================== %
% Oświadczenie                                             %
% ======================================================== %

\RequirePackage{ifthen}

% Zdefiniuj parametry oświadczenia
\newif\if@stmale
\@stmaletrue
\newcommand*{\stsex}[1]{%
  \ifthenelse{\equal{\unexpanded{#1}}{M}}{\@stmaletrue}{\@stmalefalse}%
}

\newcommand*{\stdate}[1]{\gdef\@stdate{#1}}
\newcommand*{\@stdate}{}
\newcommand*{\stread}[1]{\gdef\@stread{#1}}
\newcommand*{\@stread}{}
\newcommand*{\stprotect}[1]{\gdef\@stprotect{#1}}
\newcommand*{\@stprotect}{}

% Zdefiniuj polecenie '\makestatement'
\newcommand*{\makestatement}{%
  \cleardoublepage\thispagestyle{empty}%
  {\noindent\normalfont\flushright{\@stdate{}}\strut\par}%
  \vskip 2.5 \baselineskip
  \vbox to 6 \baselineskip{%
    \bgroup%
    \fontsize{18pt}{24pt}\selectfont\centering%
    \vskip 1.5 \baselineskip O\'swiadczenie\par%
    \vfill%
    \egroup%
  }%
  \if@optindent
    \makeatletter
    \@afterindenttrue
    \makeatother
  \else
    \makeatletter
    \@afterindentfalse
    \@afterheading
    \makeatother
  \fi%
  {%
  Ja, ni\.zej %
  \if@stmale podpisany \else podpisana \fi %
  {\bfseries\@author}, %
  \if@stmale student \else studentka \fi %
  Wydzia\l{}u Matematyki i~Informatyki Uniwersytetu im.~Adama Mickiewicza w Poznaniu o\'swiadczam, \.ze przedk\l{}adan\k{a} prac\k{e} dyplomow\k{a} pt: %
  \emph{\@title} %
  \if@stmale napisa\l{}em \else napisa\l{}am \fi %
  samodzielnie. Oznacza to, \.ze przy pisaniu pracy, poza niezb\k{e}dnymi konsultacjami, nie %
  \if@stmale korzysta\l{}em \else korzysta\l{}am \fi %
  z pomocy innych os\'ob, a~w~szczeg\'olno\'sci nie %
  \if@stmale zleca\l{}em \else zleca\l{}am \fi %
  opracowania rozprawy lub jej cz\k{e}\'sci innym osobom, ani nie %
  \if@stmale odpisywa\l{}em \else odpisywa\l{}am \fi %
  tej rozprawy lub jej cz\k{e}\'sci od innych os\'ob. O\'swiadczam r\'ownie\.z, \.ze egzemplarz pracy dyplomowej w~wersji drukowanej jest ca\l{}kowicie zgodny z~egzemplarzem pracy dyplomowej w~wersji elektronicznej. Jednocze\'snie przyjmuj\k{e} do wiadomo\'sci, \.ze przypisanie sobie, w~pracy dyplomowej, autorstwa istotnego fragmentu lub innych element\'ow cudzego utworu lub ustalenia naukowego stanowi podstaw\k{e} stwierdzenia niewa\.zno\'sci post\k{e}powania w~sprawie nadania tytu\l{}u zawodowego.\par%
  }%
  {
  \vspace{2cm}%
  \small%
  \noindent[\uppercase{\@stread}]{\hskip 4pt}--{\hskip 4pt}%
  wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w czytelni Archiwum UAM\par
  \noindent[\uppercase{\@stprotect}]{\hskip 4pt}--{\hskip 4pt}%
  wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w zakresie koniecznym do ochrony mojego prawa do autorstwa lub praw os\'ob trzecich\par
  }
  \clearpage
}

% ======================================================== %
% Definicje poleceń hierarchicznych                        %
% ======================================================== %

\RequirePackage{xparse}

% Rozdziały
\RenewDocumentCommand\chapter{sm}{%
  \cleardoublepage\mbox{}
  \vskip 3 \baselineskip
  \thispagestyle{plain}
  \IfBooleanTF{#1}{%
    \vbox to 6 \baselineskip{%
      \bgroup%
      \fontsize{18pt}{24pt}\selectfont\centering%
      \vskip 1.5 \baselineskip#2\par%
      \vfill%
      \egroup%
    }%
    \markboth{#2}{#2}%
  }{%
    \stepcounter{chapter}
    \vbox to 6 \baselineskip{%
      \bgroup%
      \fontsize{14pt}{24pt}\selectfont\centering%
      \textsc{\chaptername~\thechapter}\par%
      \vskip 0.5 \baselineskip%
      \fontsize{18pt}{24pt}\selectfont#2\par%
      \vfill%
      \egroup
    }%
    \addcontentsline{toc}{chapter}{\chaptername~\thechapter.~#2}%
    %\addtocontents{toc}{\vskip 1 \baselineskip}
    \markboth{\chaptername~\thechapter.~#2}{\chaptername~\thechapter.~#2}%
  }
  \if@optindent
    \makeatletter
    \@afterindenttrue
    \makeatother
  \else
    \makeatletter
    \@afterindentfalse
    \@afterheading
    \makeatother
  \fi
}

% Paragrafy
\RenewDocumentCommand\section{sm}{%
  \stepcounter{section}
  \vskip 2 \baselineskip
  \IfBooleanTF{#1}{%
    \vbox to 2 \baselineskip{%
      \bgroup%
      \fontsize{14pt}{24pt}\selectfont\centering%
      \textsc{#2}\par%
      \vfill%
      \egroup%
    }%
    \markright{#2}%
  }{%
    \vbox to 2 \baselineskip{%
    \bgroup%
      \fontsize{14pt}{24pt}\selectfont\centering%
      \if@optpolski
        \addcontentsline{toc}{section}{\thesection.~\hskip 0.25em #2}%
        \textsc{\thesection.~\hskip 0.25em #2}\par%
      \else
        \addcontentsline{toc}{section}{\thesection~\hskip 1em #2}%
        \textsc{\thesection~\hskip 1em #2}\par%
      \fi
      \vfill%
      \egroup%
    }%
    \markright{\thesection.~#2}%
  }
  \if@optindent
    \makeatletter
    \@afterindenttrue
    \makeatother
  \else
    \makeatletter
    \@afterindentfalse
    \@afterheading
    \makeatother
  \fi
}

% Podparagrafy
\RenewDocumentCommand\subsection{sm}{%
  \stepcounter{subsection}
  \vskip 2 \baselineskip
  \IfBooleanTF{#1}{%
    \vbox to 1 \baselineskip{%
      \bgroup%
      \noindent\textbf{#2}\par%
      \vfill%
      \egroup%
    }%
    \markright{#2}%
  }{%
    \vbox to 1 \baselineskip{%
    \bgroup%
      \noindent
      \if@optpolski
        \addcontentsline{toc}{subsection}{\thesubsection.~\hskip 0.25em #2}%
        \textbf{\thesubsection.~\hskip 0.25em #2}\par%
      \else
        \addcontentsline{toc}{subsection}{\thesubsection~\hskip 1em #2}%
        \textbf{\thesubsection~\hskip 1em #2}\par%
      \fi
      \vfill%
      \egroup%
    }%
    \markright{\thesubsection.~#2}%
  }
  \if@optindent
    \makeatletter
    \@afterindenttrue
    \makeatother
  \else
    \makeatletter
    \@afterindentfalse
    \@afterheading
    \makeatother
  \fi
}

% ======================================================== %
% Paginy                                                   %
% ======================================================== %

\RequirePackage{fancyhdr}

\renewcommand{\headrulewidth}{0pt}

\fancyhf{}
\fancyhead[RE]{\small\leftmark}
\fancyhead[LO]{\small\rightmark}
\fancyhead[LE,RO]{\small\thepage}

\pagestyle{fancy}

\renewcommand{\sectionmark}[1]{%
  \markright{#1}{}}
\renewcommand{\chaptermark}[1]{%
  \markboth{\ifnum\value{chapter}>0\chaptername~\thechapter{}.~ \fi#1}{}}

\fancypagestyle{closing}{
  \fancyhf{}
  \fancyhead[RE]{\small\leftmark}
  \fancyhead[LO]{\small\rightmark}
  \fancyhead[LE,RO]{\small\thepage}
}

\fancypagestyle{plain}{%
  \fancyhf{}
  \cfoot{\small\thepage}
}

\endinput
