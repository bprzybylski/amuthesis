\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{amuthesis}[2017/10/01 AMU Thesis]

% ======================================================== %
% Obsługa opcji pakietu                                    %
% ======================================================== %

% Praca w języku polskim
\newif\if@optpolski
\DeclareOption{polski}{\@optpolskitrue}
\ExecuteOptions{polski}
\DeclareOption{english}{\@optpolskifalse}

\newif\if@optindent
\DeclareOption{indent}{\@optindenttrue}

\newif\if@optlineno
\DeclareOption{lineno}{\@optlinenotrue}

% Obsłuż nieznane opcje
\DeclareOption*{
  \ClassWarning{amuthesis}{Nieznany parametr klasy: \CurrentOption}
}

\ProcessOptions\relax

% Oprzyj dokument na jednym z zestawów, w zależności
% od statusu opcji polski/english
\if@optpolski
  \LoadClass[oneside,12pt]{mwbk}
  \RequirePackage{polski}
\else
  \LoadClass[oneside,12pt]{book}
\fi

% Uruchom numerację wierszy, jeśli to konieczne
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
% Podstawowe pakiety                                       %
% ======================================================== %

% Upewnij się, że dokument jest składany UTF-8
\RequirePackage[utf8]{inputenc}

% Składaj dokument fontem 'Adobe Utopia'
\RequirePackage{fourier}

% Zmodyfikuj rozmiar dokumentu
\RequirePackage{geometry}
\geometry{a4paper,%
          innermargin=3.75cm,%
          outermargin=3.75cm,%
          tmargin=4.0cm,%
          bmargin=4.0cm,%
          headsep=24pt,%
          footskip=42pt}

% Zapewnij wsparcie dla PDF
\RequirePackage[hidelinks,unicode]{hyperref}

% Dołącz podstawowe pakiety
\RequirePackage{xcolor}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{graphicx}
\RequirePackage{microtype}

% ======================================================== %
% Konfiguracja i polecenia specjalne                       %
% ======================================================== %

\linespread{1.15}\selectfont
\raggedbottom

\newenvironment{abstract}{\chapter*{Abstract}}{}
\newenvironment{streszczenie}{\chapter*{Streszczenie}}{}
\newenvironment{podziekowania}{\chapter*{Podziękowania}}{}

\newenvironment{dedykacja}{%
  \clearpage\thispagestyle{empty}\mbox{}\vfill
  \hfill\begin{minipage}{0.4\textwidth}
}{
  \end{minipage}
  \vspace*{5cm}
}

% Strona tytułowa
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

\renewcommand*{\maketitle}{%
  \clearpage\thispagestyle{empty}%
  {\noindent\centering\scshape\large%
    Uniwersytet im. Adama Mickiewicza w Poznaniu%
  \strut\par}%
  {\noindent\centering\normalfont%
    Wydział Matematyki i Informatyki%
  \strut\par}%
  \vspace{2.5cm}
  {\noindent\centering\normalfont\@author\strut\par}%
  {\noindent\centering\normalfont%
    Numer albumu: %
    \@album\strut\par}%
  \vspace{2.5cm}
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
    napisana pod kierunkiem\\
    \bfseries{\@supervisor}%
  }\strut\par}%
  \vspace{2.5cm}%
  {\noindent\centering\normalfont\@date\strut\par}
}

\newif\if@stmale
\newcommand*{\stmale}{\@stmaletrue}
\newcommand*{\stfemale}{\@stfemaletrue}

\newcommand*{\stread}[1]{\gdef\@stread{#1}}
\newcommand*{\@stread}{}
\newcommand*{\stprotect}[1]{\gdef\@stprotect{#1}}
\newcommand*{\@stprotect}{}

\newcommand*{\stdate}[1]{\gdef\@stdate{#1}}
\newcommand*{\@stdate}{}

\newcommand*{\makestatement}{%
  \clearpage\thispagestyle{empty}%
  {\noindent\normalfont\flushright{\@stdate{}}\strut\par}%
  \vskip 2.5 \baselineskip
  \vbox to 6 \baselineskip{%
    \bgroup%
    \fontsize{18pt}{24pt}\selectfont\centering%
    \vskip 1.5 \baselineskip Oświadczenie\par%
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
  Ja, niżej %
  \if@stmale podpisany \else podpisana \fi %
  {\bfseries\@author}, %
  \if@stmale student \else studentka \fi %
  Wydziału Matematyki i~Informatyki Uniwersytetu im.~Adama Mickiewicza w Poznaniu oświadczam, że przedkładaną pracę dyplomową pt: %
  \emph{\@title} %
  \if@stmale napisałem \else napisałam \fi %
  samodzielnie. Oznacza to, że przy pisaniu pracy, poza niezbędnymi konsultacjami, nie %
  \if@stmale korzystałem \else korzystałam \fi %
  z pomocy innych osób, a w szczególności nie %
  \if@stmale zlecałem \else zlecałam \fi %
  opracowania rozprawy lub jej części innym osobom, ani nie %
  \if@stmale odpisywałem \else odpisywałam \fi %
  tej rozprawy lub jej części od innych osób. Oświadczam również, że egzemplarz pracy dyplomowej w~wersji drukowanej jest całkowicie zgodny z~egzemplarzem pracy dyplomowej w~wersji elektronicznej. Jednocześnie przyjmuję do wiadomości, że przypisanie sobie, w~pracy dyplomowej, autorstwa istotnego fragmentu lub innych elementów cudzego utworu lub ustalenia naukowego stanowi podstawę stwierdzenia nieważności postępowania w~sprawie nadania tytułu zawodowego.\par
  }
  {
  \vspace{2cm}%
  \small%
  \noindent[\uppercase{\@stread}] -- wyrażam zgodę na udostępnianie mojej pracy w czytelni Archiwum UAM\par
  \noindent[\uppercase{\@stprotect}] -- wyrażam zgodę na udostępnianie mojej pracy w zakresie koniecznym do ochrony mojego prawa do autorstwa lub praw osób trzecich\par
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
