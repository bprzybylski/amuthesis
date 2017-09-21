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

\endinput
