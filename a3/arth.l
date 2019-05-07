%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "y.tab.h"
  int lvl = 0;
  int line_num = -1;
  extern int flag=0;
  extern int lineno=1;
%}

alpha [a-zA-Z]
digit [0-9]

%%


[\t] 				
[\n] 				{lineno++;}	
"main"  			return START;
"="				{printf("eq\n");return EQUAL;}
"int"				{printf("int\n");return INT;}
"float"				{printf("f\n");return FLOAT;}
"char"				{return CHAR;}
"goto"				return GOT; 
"+"				return OPR;
"-"				return OPR;
"*"				return OPR;
"/"				return OPR;
"%"				return OPR;
{digit}+			{printf("n\n");return NUM;}
{digit}+[\.]{digit}+		{printf("n\n");return DECIMAL;}
{alpha}({alpha}|{digit})* 	{yylval=yytext;printf("%s\n",yytext);return VAR;}
['].[']				return CH;
" "

";"				return SEMI;
. {return *yytext;}

%%

yywrap()
{
	return 1;
}
