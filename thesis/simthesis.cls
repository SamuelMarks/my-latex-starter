%
% File for the simthesis LaTeX class.
%
% Original author: Federico Zenith @ 2007/03/25 Class for PhD theses at NTNU Trondheim
%

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{simthesis}

%
% Set default values for the variables used by our implementation of \maketitle
%
\newcommand{\SubTitle}{}
\newcommand{\DegreeType}{PhD}
\newcommand{\Faculty}{ Engineering}
\newcommand{\Department}{Computer Science and Eng}
\newcommand{\CopyrightNotice}{}
\newcommand{\ISBNPrinted}{N/A}
\newcommand{\ISBNElectronic}{N/A}
\newcommand{\SerialNumber}{\number\year:N/A}
\newcommand{\Month}{\ifcase\month\or
	January\or February\or March\or April\or May\or June\or
	July\or August\or September\or October\or November\or December\fi}
\newcommand{\Year}{\number\year}
\renewcommand{\@author}{Forfatter Forfattersen}
\renewcommand{\@title}{Tull}


%
% Set the default values for margin settings
%
\newcommand{\GeometryOptions}{margin=2cm,top=2cm,bottom=2cm,bindingoffset=0mm}
\newcommand{\CropOptions}{}
\newcommand{\CropLandscapeFlag}{}

%
% Commodity command to give two different versions of code, the first for printout mode
% and the second for screen mode. Useful for large pictures and layouts in absolute units.
%
\newcommand{\printandscreen}[2]{\ifthenelse{\isundefined{\ScreenMode}}{#1}{#2}}

%
% Process options passed to the class
%
\DeclareOption{a4crop}{\renewcommand{\CropOptions}{cam,a4,center}}
\DeclareOption{draft}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{final}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{screen}{
	\renewcommand{\CropLandscapeFlag}{landscape}
	\renewcommand{\GeometryOptions}{margin=12mm,screen}
	\newcommand{\ScreenMode}{true}
}
\DeclareOption*{\PackageWarning{simthesis}{Unknown option `\CurrentOption´.}}
\ProcessOptions\relax

\LoadClass[b5paper,12pt,twoside,openright,onecolumn,titlepage]{book}

% Set appropriate margins
\RequirePackage[\GeometryOptions,includeheadfoot,headheight=14.5pt]{geometry}

% Set cropping marks, if a4crop has been specified.
\RequirePackage[\CropOptions,\CropLandscapeFlag]{crop}

% Necessary to set the headers; notice that right and left headers are swapped.
\RequirePackage{fancyhdr}

% Used in some conditional statements
\RequirePackage{ifthen}

% Necessary to include the NTNU logo
\RequirePackage{graphicx}

%
% Define the commands to set the variables used by \maketitle
%
\newcommand{\subtitle}[1]{\renewcommand{\SubTitle}{#1}}
\newcommand{\degreetype}[1]{\renewcommand{\DegreeType}{#1}}
\newcommand{\faculty}[1]{\renewcommand{\Faculty}{#1}}
\newcommand{\department}[1]{\renewcommand{\Department}{#1}}
\newcommand{\copyrightnotice}[1]{\renewcommand{\CopyrightNotice}{#1}}
\newcommand{\isbnprinted}[1]{\renewcommand{\ISBNPrinted}{#1}}
\newcommand{\isbnelectronic}[1]{\renewcommand{\ISBNElectronic}{#1}}
\newcommand{\serialnumber}[1]{\renewcommand{\SerialNumber}{#1}}
\newcommand{\setyear}[1]{\renewcommand{\Year}{#1}}
\newcommand{\setmonth}[1]{\renewcommand{\Month}{#1}}
%
% Override the \maketitle command
%
\def \Institute{University of New South Wales}
\renewcommand{\maketitle}{
	\begin{titlepage}
	\parindent=0cm
	\addtolength{\parskip}{\baselineskip}
	{\Huge \@author}
	\printandscreen{\vspace{2cm}}{\vspace{0.5cm}}

	{\Huge \textbf{\@title}}

	{\LARGE \SubTitle}
	\vfill

	{\large A thesis submitted in fulfilment of the requirements for the degree of Doctor of Philosophy

	%Sydney, \Month\
	\Year

	\Institute\\
	\Faculty\ \\
	\Department}
	\printandscreen{\vspace{2cm}}{\vspace{0.75cm}}

	\begin{figure}[b]          
	  %\includegraphics[width=0.4\textwidth,bb=0mm 0mm 21mm 7.9mm]{USydLogo.pdf}
	  %\includegraphics{Contents/UNSW_Portrait.pdf}
	  %\includegraphics{Contents/UNSW_logo.png}
	  %\includegraphics{Contents/UNSWlogo-opengraph-squaresafe.png}
	  %\includegraphics{Contents/unsw_logo.pdf}
	  \includegraphics[width=0.4\textwidth,bb=0mm 0mm 21mm 7.9mm]{Contents/unsw_logo.pdf}
	\end{figure}

	\newpage
	% {~}
	% \vfill
	% {
	% \scriptsize
	% \textbf{\Institute}

	% Doctoral thesis\\
	% for the degree of \DegreeType

	% \Faculty\ \\
	% \Department

	% \copyright\ \Year\ \@author. \CopyrightNotice

	% ISBN \ISBNPrinted\ (printed version)\\
	% ISBN \ISBNElectronic\ (electronic version)\\
	% ISSN 0000-0000

	% Doctoral theses at the \Institute, \SerialNumber

	% }
	\end{titlepage}
}

\AtBeginDocument{
	\pagestyle{fancy}
	\renewcommand{\headrulewidth}{0.4pt}
	\renewcommand{\sectionmark}[1]{\markright{\textbf{\thesection.\ #1}}}
	\renewcommand{\chaptermark}[1]{\markboth{\textbf{#1}}{}}
	%\rhead{\nouppercase{\leftmark}}
	%\lhead{\nouppercase{\rightmark}}
	%\printandscreen{	
    %		\fancyhead[LE,RO]{\textbf{\thepage}}
	%}{	
	%	\fancyhead[R]{\textbf{\thepage}}
	%}
	\fancyfoot[C]{}
}
