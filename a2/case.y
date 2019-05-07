%{
    #include<stdio.h>
    #include<stdlib.h>
    #include "lex.yy.c"
    int yylex(void);
    void yyerror(char *s);
    extern char* yytext;
    extern FILE *yyin;
    extern FILE *yyout;
    
%}

%token S C NUM B ID D CHAR Q L M I DEF AB DOT
%left OPER
%right EQ

%%
Program             :   StatementBlock                              {fprintf(yyout,"program");exit(0);}
                    ;

StatementBlock      :   Statement StatementBlock                   
                    |								                
                    ;

Statement           :   SwitchStatement                             
                    |   Expression ';'                              {fprintf(yyout,";");if(tail)strcat(tail->s,";\n");}             
                    |   MExpression ';'                             {fprintf(yyout,";");if(tail)strcat(tail->s,";\n");}                                     
		        |   ID M '(' ')' '{' Statement '}'              {fprintf(yyout,"stmt}");}
		        |   I
		        ;
SwitchStatement     :   S '(' MExpression ')'                       {fprintf(yyout,";");}
                    |   SwitchStatement '{' CaseBlock '}'           {fprintf(yyout,"qwe}"); count--;}
                    ;
CaseBlock           :   CaseStatementBlock DefaultStatement 
                    |   CaseStatementBlock                          {fprintf(yyout,"//end}\n");}
                    ;
DefaultStatement    :   D L StatementBlock   
			  ;
CaseStatementBlock  :   CaseStatement CaseStatementBlock 
                    |
                    ;
CaseStatement       :   C NUM L StatementBlock CaseStatement      
                    |   C CHAR L StatementBlock CaseStatement     
                    |   C NUM L StatementBlock B ';' 
                    |   C CHAR L StatementBlock B ';'
                    |	C NUM L StatementBlock       
                    |   C CHAR L StatementBlock  
                    ;
Expression          :   ID EQ MExpression
//                    |   ID EQ FunctionStatement
                    ;
MExpression         :   MExpression OPER MExpression              
                    |   ID                                         
                    |   NUM                                       
                    ;
%%
void yyerror(char *s){
    printf("\nError: %s",s);
}


