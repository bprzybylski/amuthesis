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

% Logo zamiast nazwy uczelni
\newif\if@optlogo
\DeclareOption{logo}{\@optlogotrue}

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

\setlength{\textfloatsep}{2\baselineskip}

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

\if@optpolski
  \leftblank{Ta strona jest pusta.}
\else
  \leftblank{This page intentionally left blank.}
\fi

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
\RequirePackage{verbatim}

% ======================================================== %
% Etykiety                                                 %
% ======================================================== %

\RequirePackage[justification=centering,
                singlelinecheck=false,
                labelsep=period]{caption}
\DeclareCaptionFormat{stdcap}{\textbf{#1#2}#3\vspace*{0.5em}}
\captionsetup[table]{justification=centering}
\captionsetup{format=stdcap}

% ======================================================== %
% Listingi                                                 %
% ======================================================== %

\RequirePackage{listings}
\AtBeginDocument{%
  \renewcommand*{\thelstlisting}{\thechapter-\arabic{lstlisting}}%
}

\if@optpolski
  \renewcommand{\lstlistingname}{Wyci\k{a}g}
\else
  \renewcommand{\lstlistingname}{Listing}
\fi

\lstset{
  basicstyle=\small\ttfamily,
  breaklines=true,
  xleftmargin=26pt,
  showstringspaces=false,
  belowskip=9pt,
  aboveskip=9pt,
  extendedchars=true,
  inputencoding=utf8,
  frame=l,
  framesep=5pt,
  numbers=left,
  numberstyle=\footnotesize\ttfamily\color{gray},
  rulecolor=\color{gray!50},
  extendedchars=true
}

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

\RequirePackage{ifthen}

% Zdefiniuj parametry strony tytułowej
\newcommand*{\titlePL}[1]{\gdef\@titlePL{#1}}
\newcommand*{\@titlePL}{}
\newcommand*{\titleEN}[1]{\gdef\@titleEN{#1}}
\newcommand*{\@titleEN}{}

% \firstAuthor
\newcommand*{\firstAuthor}[1]{\gdef\@firstAuthor{#1}}
\newcommand*{\@firstAuthor}{}
% \secondAuthor
\newcommand*{\secondAuthor}[1]{\gdef\@secondAuthor{#1}}
\newcommand*{\@secondAuthor}{}
% \thirdAuthor
\newcommand*{\thirdAuthor}[1]{\gdef\@thirdAuthor{#1}}
\newcommand*{\@thirdAuthor}{}
% \fourthAuthor
\newcommand*{\fourthAuthor}[1]{\gdef\@fourthAuthor{#1}}
\newcommand*{\@fourthAuthor}{}

% \firstAlbum
\newcommand*{\firstAlbum}[1]{\gdef\@firstAlbum{#1}}
\newcommand*{\@firstAlbum}{}
% \secondAlbum
\newcommand*{\secondAlbum}[1]{\gdef\@secondAlbum{#1}}
\newcommand*{\@secondAlbum}{}
% \thirdAlbum
\newcommand*{\thirdAlbum}[1]{\gdef\@thirdAlbum{#1}}
\newcommand*{\@thirdAlbum}{}
% \fourthAlbum
\newcommand*{\fourthAlbum}[1]{\gdef\@fourthAlbum{#1}}
\newcommand*{\@fourthAlbum}{}

\newcommand*{\type}[1]{\gdef\@type{#1}}
\newcommand*{\@type}{}
\newcommand*{\field}[1]{\gdef\@field{#1}}
\newcommand*{\@field}{}
\newcommand*{\supervisor}[1]{\gdef\@supervisor{#1}}
\newcommand*{\@supervisor}{}
\newcommand*{\specialty}[1]{\gdef\@specialty{#1}}
\newcommand*{\@specialty}{}
\specialty{}

% Wydział
\newcommand*{\faculty}[1]{\gdef\@faculty{#1}}
\newcommand*{\@faculty}{}
\newcommand*{\facultyM}[1]{\gdef\@facultyM{#1}}
\newcommand*{\@facultyM}{}
\newcommand*{\facultyD}[1]{\gdef\@facultyD{#1}}
\newcommand*{\@facultyD}{}

\facultyM{\emph{[Zdefiniuj wydzia\l{}]}}
\facultyD{\emph{[Zdefiniuj wydzia\l{}]}}

\newcommand*{\setfaculty}{
  % --- WA --- Wydział Anglistyki
  \ifthenelse{\equal{\@faculty}{WA}}{
    \facultyM{Wydzia\l{} Anglistyki}
    \facultyD{Wydzia\l{}u Anglistyki}
  }{}
  % --- WAiK --- Wydział Antropologii i Kulturoznawstwa
  \ifthenelse{\equal{\@faculty}{WAiK}}{
    \facultyM{Wydzia\l{} Antropologii i Kulturoznawstwa}
    \facultyD{Wydzia\l{}u Antropologii i Kulturoznawstwa}
  }{}
  % --- WAr --- Wydział Archeologii
  \ifthenelse{\equal{\@faculty}{WAr}}{
    \facultyM{Wydzia\l{} Archeologii}
    \facultyD{Wydzia\l{}u Archeologii}
  }{}
  % --- WB --- Wydział Biologii
  \ifthenelse{\equal{\@faculty}{WB}}{
    \facultyM{Wydzia\l{} Biologii}
    \facultyD{Wydzia\l{}u Biologii}
  }{}
  % --- WCh --- Wydział Chemii
  \ifthenelse{\equal{\@faculty}{WCh}}{
    \facultyM{Wydzia\l{} Chemii}
    \facultyD{Wydzia\l{}u Chemii}
  }{}
  % --- WFPiK --- Wydział Filologii Polskiej i Klasycznej
  \ifthenelse{\equal{\@faculty}{WFPiK}}{
    \facultyM{Wydzia\l{} Filologii Polskiej i~Klasycznej}
    \facultyD{Wydzia\l{}u Filologii Polskiej i~Klasycznej}
  }{}
  % --- WFi --- Wydział Filozoficzny
  \ifthenelse{\equal{\@faculty}{WFi}}{
    \facultyM{Wydzia\l{} Filozoficzny}
    \facultyD{Wydzia\l{}u Filolozoficznego}
  }{}
  % --- WF --- Wydział Fizyki
  \ifthenelse{\equal{\@faculty}{WF}}{
    \facultyM{Wydzia\l{} Fizyki}
    \facultyD{Wydzia\l{}u Fizyki}
  }{}
  % --- WGSE --- Geografii Społeczno-Ekonomicznej i Gospodarki Przestrzennej
  \ifthenelse{\equal{\@faculty}{WGSE}}{
    \facultyM{Wydzia\l{} Geografii Spo\l{}eczno-Ekonomicznej i~Gospodarki Przestrzennej}
    \facultyD{Wydzia\l{}u Geografii Spo\l{}eczno-Ekonomicznej i~Gospodarki Przestrzennej}
  }{}
  % --- WH --- Wydział Historii
  \ifthenelse{\equal{\@faculty}{WH}}{
    \facultyM{Wydzia\l{} Historii}
    \facultyD{Wydzia\l{}u Historii}
  }{}
  % --- WMiI --- Wydział Matematyki i Informatyki
  \ifthenelse{\equal{\@faculty}{WMiI}}{
    \facultyM{Wydzia\l{} Matematyki i~Informatyki}
    \facultyD{Wydzia\l{}u Matematyki i~Informatyki}
  }{}
  % --- WNGiG --- Wydział Nauk Geograficznych i Geologicznych
  \ifthenelse{\equal{\@faculty}{WNGiG}}{
    \facultyM{Wydzia\l{} Nauk Geograficznych i~Geologicznych}
    \facultyD{Wydzia\l{}u Nauk Geograficznych i~Geologicznych}
  }{}
  % --- WNoS --- Wydział Nauk o Sztuce
  \ifthenelse{\equal{\@faculty}{WNoS}}{
    \facultyM{Wydzia\l{} Nauk o~Sztuce}
    \facultyD{Wydzia\l{}u Nauk o~Sztuce}
  }{}
  % --- WNPiD --- Wydział Nauk Politycznych i Dziennikarstwa
  \ifthenelse{\equal{\@faculty}{WNPiD}}{
    \facultyM{Wydzia\l{} Nauk Politycznych i~Dziennikarstwa}
    \facultyD{Wydzia\l{}u Nauk Politycznych i~Dziennikarstwa}
  }{}
  % --- WN --- Wydział Neofilologii
  \ifthenelse{\equal{\@faculty}{WN}}{
    \facultyM{Wydzia\l{} Neofilologii}
    \facultyD{Wydzia\l{}u Neofilologii}
  }{}
  % --- WPiK --- Wydział Psychologii i Kognitywistyki
  \ifthenelse{\equal{\@faculty}{WPiK}}{
    \facultyM{Wydzia\l{} Psychologii i Kognitywistyki}
    \facultyD{Wydzia\l{}u Psychologii i Kognitywistyki}
  }{}
  % --- WPAK --- Wydział Pedagogiczno-Artystyczny w Kaliszu
  \ifthenelse{\equal{\@faculty}{WPAK}}{
    \facultyM{Wydzia\l{} Pedagogiczno-Artystyczny w~Kaliszu}
    \facultyD{Wydzia\l{}u Pedagogiczno-Artystycznego w~Kaliszu}
  }{}
  % --- WPiA --- Wydział Prawa i Administracji
  \ifthenelse{\equal{\@faculty}{WPiA}}{
    \facultyM{Wydzia\l{} Prawa i~Administracji}
    \facultyD{Wydzia\l{}u Prawa i~Administracji}
  }{}
  % --- WS --- Wydział Socjologii
  \ifthenelse{\equal{\@faculty}{WS}}{
    \facultyM{Wydzia\l{} Socjologii}
    \facultyD{Wydzia\l{}u Socjologii}
  }{}
  % --- WSE --- Wydział Studiów Edukacyjnych
  \ifthenelse{\equal{\@faculty}{WSE}}{
    \facultyM{Wydzia\l{} Studi\'ow Edukacyjnych}
    \facultyD{Wydzia\l{}u Studi\'ow Edukacyjnych}
  }{}
  % --- WT --- Wydział Teologiczny
  \ifthenelse{\equal{\@faculty}{WT}}{
    \facultyM{Wydzia\l{} Teologiczny}
    \facultyD{Wydzia\l{}u Teologicznego}
  }{}
  % --- IKE --- Instytut Kultury Europejskiej w Gnieźnie
  \ifthenelse{\equal{\@faculty}{IKE}}{
    \facultyM{Instytut Kultury Europejskiej w~Gnie\'znie}
    \facultyD{Instytutu Kultury Europejskiej w~Gnie\'znie}
  }{}
}

\if@optpolski
  \title{\@titlePL}
\else
  \title{\@titleEN}
\fi

% Zdefiniuj polecenie '\maketitle'
\renewcommand*{\maketitle}{%
  \clearpage\thispagestyle{empty}%
  \setfaculty
  \if@optlogo
    {\noindent\centering%
    \includegraphics[width=5cm]{uam-logo.pdf}\par}%
    {\noindent\centering\normalfont%
      \@facultyM
    \strut\par}%
    \vspace{1.5cm}

    {\vspace{0.3cm}\noindent\centering\normalfont\@firstAuthor\strut\par
    Numer albumu: \@firstAlbum\strut\par}%
     
    \ifthenelse{\equal{\@secondAuthor}{}}{}{
    \vspace{0.3cm}\noindent\centering\normalfont\@secondAuthor\strut\par
    Numer albumu: \@secondAlbum\strut\par}
    
    \ifthenelse{\equal{\@thirdAuthor}{}}{}{
    \vspace{0.3cm}\noindent\centering\normalfont\@thirdAuthor\strut\par
	  Numer albumu: \@thirdAlbum\strut\par}
    
    \ifthenelse{\equal{\@fourthAuthor}{}}{}{
    \vspace{0.3cm}\noindent\centering\normalfont\@fourthAuthor\strut\par
    \noindent Numer albumu: \@fourthAlbum\strut\par}

    \vspace{1.8cm}
  \else
    {\noindent\centering\scshape\large%
      Uniwersytet im. Adama Mickiewicza w Poznaniu%
    \strut\par}%
    {\noindent\centering\normalfont%
      \@facultyM
    \strut\par}%
    \vspace{2.5cm}
    
    {\vspace{0.3cm}\noindent\centering\normalfont\@firstAuthor\strut\par
    Numer albumu: \@firstAlbum\strut\par}%
     
    \ifthenelse{\equal{\@secondAuthor}{}}{}{
    \vspace{0.3cm}\noindent\centering\normalfont\@secondAuthor\strut\par
    Numer albumu: \@secondAlbum\strut\par}
    
    \ifthenelse{\equal{\@thirdAuthor}{}}{}{
    \vspace{0.3cm}\noindent\centering\normalfont\@thirdAuthor\strut\par
	  Numer albumu: \@thirdAlbum\strut\par}
    
    \ifthenelse{\equal{\@fourthAuthor}{}}{}{
    \vspace{0.3cm}\noindent\centering\normalfont\@fourthAuthor\strut\par
    \noindent Numer albumu: \@fourthAlbum\strut\par}

    \vspace{2.8cm}
  \fi
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
    Praca \@type{} na kierunku {\bfseries\@field{}}\\
    \ifthenelse{\equal{\@specialty}{}}{}{
      (specjalno\'s\'c: \@specialty)\\
    }
    napisana pod opiek\k{a}\\
    \bfseries{\@supervisor}%
  }\strut\par}%
  \vspace{2cm}%
  {\noindent\centering\normalfont\@date\strut\par}
}

% ======================================================== %
% Oświadczenie                                             %
% ======================================================== %

% Zdefiniuj parametry oświadczenia
\newif\if@stmale
\@stmaletrue
\newcommand*{\stsex}[1]{%
  \ifthenelse{\equal{\unexpanded{#1}}{M}}{\@stmaletrue}{\@stmalefalse}%
}

\newif\if@stmaleFirstAuthor
\@stmaleFirstAuthortrue
\newcommand*{\stsexFirstAuthor}[1]{%
  \ifthenelse{\equal{\unexpanded{#1}}{M}}{\@stmaleFirstAuthortrue}{\@stmaleFirstAuthorfalse}%
}

\newif\if@stmaleSecondAuthor
\@stmaleSecondAuthortrue
\newcommand*{\stsexSecondAuthor}[1]{%
  \ifthenelse{\equal{\unexpanded{#1}}{M}}{\@stmaleSecondAuthortrue}{\@stmaleSecondAuthorfalse}%
}

\newif\if@stmaleThirdAuthor
\@stmaleThirdAuthortrue
\newcommand*{\stsexThirdAuthor}[1]{%
  \ifthenelse{\equal{\unexpanded{#1}}{M}}{\@stmaleThirdAuthortrue}{\@stmaleThirdAuthorfalse}%
}

\newif\if@stmaleFourthAuthor
\@stmaleFourthAuthortrue
\newcommand*{\stsexFourthAuthor}[1]{%
  \ifthenelse{\equal{\unexpanded{#1}}{M}}{\@stmaleFourthAuthortrue}{\@stmaleFourthAuthorfalse}%
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
  \setfaculty
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
  \if@stmaleFirstAuthor podpisany \else podpisana \fi %
  {\bfseries\@firstAuthor}, %
  \if@stmaleFirstAuthor student \else studentka \fi %
  \@facultyD{} Uniwersytetu im.~Adama Mickiewicza w Poznaniu o\'swiadczam, \.ze przedk\l{}adan\k{a} prac\k{e} dyplomow\k{a} pt. %
  \emph{\@title} %
  \if@stmaleFirstAuthor napisa\l{}em \else napisa\l{}am \fi %
  samodzielnie. Oznacza to, \.ze przy pisaniu pracy, poza niezb\k{e}dnymi konsultacjami, nie %
  \if@stmaleFirstAuthor korzysta\l{}em \else korzysta\l{}am \fi %
  z pomocy innych os\'ob, a~w~szczeg\'olno\'sci nie %
  \if@stmaleFirstAuthor zleca\l{}em \else zleca\l{}am \fi %
  opracowania rozprawy lub jej cz\k{e}\'sci innym osobom, ani nie %
  \if@stmaleFirstAuthor odpisywa\l{}em \else odpisywa\l{}am \fi %
  tej rozprawy lub jej cz\k{e}\'sci od innych os\'ob. O\'swiadczam r\'ownie\.z, \.ze egzemplarz pracy dyplomowej w~wersji drukowanej jest ca\l{}kowicie zgodny z~egzemplarzem pracy dyplomowej w~wersji elektronicznej. Jednocze\'snie przyjmuj\k{e} do wiadomo\'sci, \.ze przypisanie sobie, w~pracy dyplomowej, autorstwa istotnego fragmentu lub innych element\'ow cudzego utworu lub ustalenia naukowego stanowi podstaw\k{e} stwierdzenia niewa\.zno\'sci post\k{e}powania w~sprawie nadania tytu\l{}u zawodowego.\par%
  }%
  {
  \vspace{2cm}%
  \small\noindent\begin{tabularx}{\textwidth}{@{}lX}
  {[\texttt{\uppercase{\@stread}}]} & wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w czytelni Archiwum UAM\\[1ex]
  {[\texttt{\uppercase{\@stprotect}}]} & wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w zakresie koniecznym do ochrony mojego prawa do autorstwa lub praw os\'ob trzecich\\
  \end{tabularx}
  }
  \clearpage
  % Statement of second person.
  \ifthenelse{\equal{\@secondAuthor}{}}{}{%
  \cleardoublepage\thispagestyle{empty}%
  \setfaculty
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
  \if@stmaleSecondAuthor podpisany \else podpisana \fi %
  {\bfseries\@secondAuthor}, %
  \if@stmaleSecondAuthor student \else studentka \fi %
  \@facultyD{} Uniwersytetu im.~Adama Mickiewicza w Poznaniu o\'swiadczam, \.ze przedk\l{}adan\k{a} prac\k{e} dyplomow\k{a} pt. %
  \emph{\@title} %
  \if@stmaleSecondAuthor napisa\l{}em \else napisa\l{}am \fi %
  samodzielnie. Oznacza to, \.ze przy pisaniu pracy, poza niezb\k{e}dnymi konsultacjami, nie %
  \if@stmaleSecondAuthor korzysta\l{}em \else korzysta\l{}am \fi %
  z pomocy innych os\'ob, a~w~szczeg\'olno\'sci nie %
  \if@stmaleSecondAuthor zleca\l{}em \else zleca\l{}am \fi %
  opracowania rozprawy lub jej cz\k{e}\'sci innym osobom, ani nie %
  \if@stmaleSecondAuthor odpisywa\l{}em \else odpisywa\l{}am \fi %
  tej rozprawy lub jej cz\k{e}\'sci od innych os\'ob. O\'swiadczam r\'ownie\.z, \.ze egzemplarz pracy dyplomowej w~wersji drukowanej jest ca\l{}kowicie zgodny z~egzemplarzem pracy dyplomowej w~wersji elektronicznej. Jednocze\'snie przyjmuj\k{e} do wiadomo\'sci, \.ze przypisanie sobie, w~pracy dyplomowej, autorstwa istotnego fragmentu lub innych element\'ow cudzego utworu lub ustalenia naukowego stanowi podstaw\k{e} stwierdzenia niewa\.zno\'sci post\k{e}powania w~sprawie nadania tytu\l{}u zawodowego.\par%
  }%
  {
  \vspace{2cm}%
  \small\noindent\begin{tabularx}{\textwidth}{@{}lX}
  {[\texttt{\uppercase{\@stread}}]} & wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w czytelni Archiwum UAM\\[1ex]
  {[\texttt{\uppercase{\@stprotect}}]} & wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w zakresie koniecznym do ochrony mojego prawa do autorstwa lub praw os\'ob trzecich\\
  \end{tabularx}
  }
  \clearpage
  }
  % Statement of third person.
  \ifthenelse{\equal{\@thirdAuthor}{}}{}{%
  \cleardoublepage\thispagestyle{empty}%
  \setfaculty
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
  \if@stmaleThirdAuthor podpisany \else podpisana \fi %
  {\bfseries\@thirdAuthor}, %
  \if@stmaleThirdAuthor student \else studentka \fi %
  \@facultyD{} Uniwersytetu im.~Adama Mickiewicza w Poznaniu o\'swiadczam, \.ze przedk\l{}adan\k{a} prac\k{e} dyplomow\k{a} pt. %
  \emph{\@title} %
  \if@stmaleThirdAuthor napisa\l{}em \else napisa\l{}am \fi %
  samodzielnie. Oznacza to, \.ze przy pisaniu pracy, poza niezb\k{e}dnymi konsultacjami, nie %
  \if@stmaleThirdAuthor korzysta\l{}em \else korzysta\l{}am \fi %
  z pomocy innych os\'ob, a~w~szczeg\'olno\'sci nie %
  \if@stmaleThirdAuthor zleca\l{}em \else zleca\l{}am \fi %
  opracowania rozprawy lub jej cz\k{e}\'sci innym osobom, ani nie %
  \if@stmaleThirdAuthor odpisywa\l{}em \else odpisywa\l{}am \fi %
  tej rozprawy lub jej cz\k{e}\'sci od innych os\'ob. O\'swiadczam r\'ownie\.z, \.ze egzemplarz pracy dyplomowej w~wersji drukowanej jest ca\l{}kowicie zgodny z~egzemplarzem pracy dyplomowej w~wersji elektronicznej. Jednocze\'snie przyjmuj\k{e} do wiadomo\'sci, \.ze przypisanie sobie, w~pracy dyplomowej, autorstwa istotnego fragmentu lub innych element\'ow cudzego utworu lub ustalenia naukowego stanowi podstaw\k{e} stwierdzenia niewa\.zno\'sci post\k{e}powania w~sprawie nadania tytu\l{}u zawodowego.\par%
  }%
  {
  \vspace{2cm}%
  \small\noindent\begin{tabularx}{\textwidth}{@{}lX}
  {[\texttt{\uppercase{\@stread}}]} & wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w czytelni Archiwum UAM\\[1ex]
  {[\texttt{\uppercase{\@stprotect}}]} & wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w zakresie koniecznym do ochrony mojego prawa do autorstwa lub praw os\'ob trzecich\\
  \end{tabularx}
  }
  \clearpage
  }
  % Statement of fourth person.
  \ifthenelse{\equal{\@fourthAuthor}{}}{}{%
  \cleardoublepage\thispagestyle{empty}%
  \setfaculty
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
  \if@stmaleFourthAuthor podpisany \else podpisana \fi %
  {\bfseries\@fourthAuthor}, %
  \if@stmaleFourthAuthor student \else studentka \fi %
  \@facultyD{} Uniwersytetu im.~Adama Mickiewicza w Poznaniu o\'swiadczam, \.ze przedk\l{}adan\k{a} prac\k{e} dyplomow\k{a} pt. %
  \emph{\@title} %
  \if@stmaleFourthAuthor napisa\l{}em \else napisa\l{}am \fi %
  samodzielnie. Oznacza to, \.ze przy pisaniu pracy, poza niezb\k{e}dnymi konsultacjami, nie %
  \if@stmaleFourthAuthor korzysta\l{}em \else korzysta\l{}am \fi %
  z pomocy innych os\'ob, a~w~szczeg\'olno\'sci nie %
  \if@stmaleFourthAuthor zleca\l{}em \else zleca\l{}am \fi %
  opracowania rozprawy lub jej cz\k{e}\'sci innym osobom, ani nie %
  \if@stmaleFourthAuthor odpisywa\l{}em \else odpisywa\l{}am \fi %
  tej rozprawy lub jej cz\k{e}\'sci od innych os\'ob. O\'swiadczam r\'ownie\.z, \.ze egzemplarz pracy dyplomowej w~wersji drukowanej jest ca\l{}kowicie zgodny z~egzemplarzem pracy dyplomowej w~wersji elektronicznej. Jednocze\'snie przyjmuj\k{e} do wiadomo\'sci, \.ze przypisanie sobie, w~pracy dyplomowej, autorstwa istotnego fragmentu lub innych element\'ow cudzego utworu lub ustalenia naukowego stanowi podstaw\k{e} stwierdzenia niewa\.zno\'sci post\k{e}powania w~sprawie nadania tytu\l{}u zawodowego.\par%
  }%
  {
  \vspace{2cm}%
  \small\noindent\begin{tabularx}{\textwidth}{@{}lX}
  {[\texttt{\uppercase{\@stread}}]} & wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w czytelni Archiwum UAM\\[1ex]
  {[\texttt{\uppercase{\@stprotect}}]} & wyra\.zam zgod\k{e} na udost\k{e}pnianie mojej pracy w zakresie koniecznym do ochrony mojego prawa do autorstwa lub praw os\'ob trzecich\\
  \end{tabularx}
  }
  \clearpage
  }
}

% ======================================================== %
% Definicje poleceń hierarchicznych                        %
% ======================================================== %

\RequirePackage{xparse}

% Rozdziały
\RenewDocumentCommand\chapter{sm}{%
  \cleardoublepage\phantomsection\mbox{}
  \vskip 3 \baselineskip
  \thispagestyle{plain}
  \IfBooleanTF{#1}{%
    \bgroup%
    \fontsize{18pt}{24pt}\selectfont\centering%
    \vskip 1.5 \baselineskip#2\par%
    \vskip 1.5 \baselineskip%
    \egroup%
    \markboth{#2}{#2}%
  }{%
    \stepcounter{chapter}
    \protected@edef\@currentlabel{\p@chapter\thechapter}%
    \bgroup%
    \fontsize{14pt}{24pt}\selectfont\centering%
    \textsc{\chaptername~\thechapter}\par%
    \vskip 0.5 \baselineskip%
    \fontsize{18pt}{24pt}\selectfont#2\par%
    \vskip 1.5 \baselineskip%
    \egroup
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
  \vskip 1 \baselineskip
  \IfBooleanTF{#1}{%
    \bgroup%
    \fontsize{14pt}{18pt}\selectfont\centering%
    \textsc{#2}\par%
    \vskip 0.75 \baselineskip%
    \egroup%
    \markright{#2}%
  }{%
    \stepcounter{section}
    \protected@edef\@currentlabel{\p@section\thesection}%
    \bgroup%
    \fontsize{14pt}{18pt}\selectfont\centering%
    \if@optpolski
      \phantomsection
      \addcontentsline{toc}{section}{\thesection.~\hskip 0.25em #2}%
      \textsc{\thesection.~\hskip 0.25em #2}\par%
    \else
      \phantomsection
      \addcontentsline{toc}{section}{\thesection~\hskip 1em #2}%
      \textsc{\thesection~\hskip 1em #2}\par%
    \fi
    \vskip 0.75 \baselineskip%
    \egroup%
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
  \nopagebreak[4]
}

% Podparagrafy
\RenewDocumentCommand\subsection{sm}{%
  \vskip 1 \baselineskip
  \IfBooleanTF{#1}{%
    \bgroup%
    \noindent\textbf{#2}\par%
    \vskip 0.75 \baselineskip%
    \egroup%
    \markright{#2}%
  }{%
    \stepcounter{subsection}
    \protected@edef\@currentlabel{\p@subsection\thesubsection}%
    \bgroup%
    \noindent
    \if@optpolski
      \phantomsection
      \addcontentsline{toc}{subsection}{\thesubsection.~\hskip 0.25em #2}%
      \textbf{\thesubsection.~\hskip 0.25em #2}\par%
    \else
      \phantomsection
      \addcontentsline{toc}{subsection}{\thesubsection~\hskip 1em #2}%
      \textbf{\thesubsection~\hskip 1em #2}\par%
    \fi
    \vskip 0.75 \baselineskip%
    \egroup%
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
  \nopagebreak[4]
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
