
%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>
  #include<stdbool.h>
  #include "lex.yy.c"
  int yyerror();
  char valid[100][20],temp1[20];
  int validline[100];
  char invalid[100][20];
  int invalidline[100];
  int invalid_i=0;
  char labels[100][20];
  char gotol[100][20];
  int labels_i=0;
  int gotol_i=0;
  int gotoline[100];
  int gotoline_i=0;
  int valid_i=0;
  
  char* strcp(char* destination, const char* source);

  

%}



%token TAB  START NUM VAR INT FLOAT OPR EQUAL SEMI GOT DECIMAL CHAR CH

%left '+' '-'
%left '*'

%%
PRGM	:FUNC start FUNC '$'				{printf("DONE\n");return 0;}
	;
start:	START '(' ')'  '{'  BODY '}'	
     ;
FUNC	:IDT VAR '(' PARAM ')' '{' BODY '}' FUNC
	|
	;
IDT	:INT
	|FLOAT
	;
PARAM	:IDT VAR ',' PARAM
	|IDT VAR
	|
	;
BODY	:DECL STMT BODY			{chckgoto();initvars();}
	|
	;
LABEL	:VAR ':'		{strcp(temp1,(char *)$1);printf("label %s\n",temp1);insertlabel(temp1);}
	;
GOTO	:GOT L3 SE		
	;
L3	:VAR			{strcpy(temp1,(char *)$1);printf("goto %s\n",temp1);insertgoto(temp1);}
	;
DECL	:int L1 SE
	|int L2 EQ NUM SE	{strcpy(temp1,(char *)$2);printf("%s\n",temp1);}
	|FLOAT L1 SE
	|FLOAT L2 EQ DECIMAL SE
	|FLOAT L2 EQ NUM SE
	|CHAR L4 SE
	|CHAR L4 EQ CH SE
	|
	;
int	:INT
	;
L1	:VAR		{strcp(temp1,(char *)$1);printf("gh '%s'\n",temp1);insert(temp1);}
	;
L2	:VAR		{strcp(temp1,(char *)$1);printf("gh '%s'\n",temp1);insert(temp1);}
	;
L4	:VAR		{strcpy(temp1,(char *)$1);printf("gh '%s'\n",temp1);insertch(temp1);}
	;
STMT	:rhs EQ OP1 OPR OP2 SE
	|rhs EQ NUM OPR NUM SE
	|rhs EQ OP1 OPR NUM SE
	|rhs EQ NUM OPR OP2 SE
	|rhs EQ DECIMAL OPR DECIMAL SE
	|rhs EQ OP1 OPR DECIMAL SE
	|rhs EQ DECIMAL OPR OP2 SE
	|LABEL
	|GOTO 
	|rhs EQ NUM SE
	|rhs EQ DECIMAL SE
	|rhs EQ OP1 SE
	|
	;
EQ 	:EQUAL
	;
SE 	:SEMI
	;
rhs	:VAR			{strcp(temp1,(char *)$1);printf("sadas1 '%s'\n",temp1);chck(temp1);}
	;
OP1	:VAR			{strcpy(temp1,(char *)$1);printf("sada3 '%s'\n",temp1);chck(temp1);}
	;
OP2	:VAR			{strcpy(temp1,(char *)$1);printf("sadas4 '%s'\n",temp1);chck(temp1);}
	;
%%

int yyerror()
{
	printf("error\n");
	return 0;
}

int main()
{
  printf("begin\n");
  yyparse();

  return 1;
}

// Function to implement strcpy() function
char* strcp(char* destination, const char* source)
{
	// return if no memory is allocated to the destination
	if (destination == NULL)
		return NULL;

	// take a pointer pointing to the beginning of destination string
	char *ptr = destination;
	
	// copy the C-string pointed by source into the array
	// pointed by destination
	//int len = strlen(
	while (*source != '\0')
	{
		*destination = *source;
		destination++;
		source++;
	}
	destination--;
	// include the terminating null character
	*destination = '\0';

	// destination is returned by standard strcpy()
	return ptr;
}

extern void insert(char *temp){
	bool flg=false;
	bool flgch=false;
	for(int j=0;j<valid_i&&flg==false;j++){
		if(strcmp(temp,valid[j])==0){
			printf("'%s'already exists\n",temp);
			flg=true;
		}
	}
	for(int j=0;j<invalid_i&&flgch==false;j++){
		if(strcmp(temp,invalid[j])==0){
			printf("'%s'is of char datatype delcared on %d line\n",temp,invalidline[j]);
			flgch=true;
		}
	}
	if(flg==false&&flgch==false){
		strcpy(valid[valid_i],temp);
		validline[valid_i]=lineno;
		valid_i++;
		printf("'%s' inserted successfully\n",temp);
	}
}
extern void insertch(char *temp){
	bool flg=false;
	bool flgint=false;
	for(int j=0;j<invalid_i&&flg==false;j++){
		if(strcmp(temp,invalid[j])==0){
			printf("'%s'already exists\n",temp);
			flg=true;
		}
	}
	for(int j=0;j<valid_i&&flgint==false;j++){
		if(strcmp(temp,valid[j])==0){
			printf("'%s'is not of char datatype delcared on %d line\n",temp,validline[j]);
			flgint=true;
		}
	}
	if(flg==false&&flgint==false){
		strcpy(invalid[invalid_i],temp);
		invalidline[invalid_i]=lineno;
		invalid_i++;
		printf("'%s' inserted successfully\n",temp);
	}
}
extern void insertlabel(char *temp){
	bool flg=false;
	for(int j=0;j<valid_i&&flg==false;j++){
		if(strcmp(temp,labels[j])==0){
			printf("label '%s'already exists\n",temp);
			flg=true;
		}
	}
	if(flg==false){
		strcpy(labels[labels_i],temp);
		labels_i++;
		printf("'%s' inserted successfully\n",temp);
	}
}
extern void insertgoto(char *temp){
	
		strcpy(gotol[gotol_i],temp);
		gotoline[gotol_i]=lineno;
		gotol_i++;
		printf("'%s' inserted successfully\n",temp);
}
void chck(char *temp){
	bool flg=false;
	bool flgch=false;
	int lne;
	for(int j=0;j<valid_i&&flg==false;j++){
		if(strcmp(temp,valid[j])==0){
			flg=true;
		}
	}
	for(int j=0;j<invalid_i&&flgch==false;j++){
		if(strcmp(temp,invalid[j])==0){
			lne=invalidline[j];
			flgch=true;
		}
	}
	if(flgch==true){
		printf("%s is of char datatype declared on %d line\n",temp,lne);
	}
	else if(flg==false){
		printf("%s not declared\n",temp);
	}
}
void chckch(char *temp){
	bool flg=false;
	bool flgint=false;
	int lne;
	for(int j=0;j<invalid_i&&flg==false;j++){
		if(strcmp(temp,invalid[j])==0){
			flg=true;
		}
	}
	for(int j=0;j<valid_i&&flgint==false;j++){
		if(strcmp(temp,valid[j])==0){
			lne=validline[j];
			flgint=true;
		}
	}
	if(flgint==true){
		printf("%s is not of char datatype declared on %d line\n",temp,lne);
	}
	else if(flg==false){
		printf("%s not declared\n",temp);
	}
}
void initvars(){
	valid_i=0;
	labels_i=0;
	gotol_i=0;
}	
void chckgoto(){
	for(int i=0;i<gotol_i;i++){
		int flg=1;
		for(int j=0;j<labels_i&&flg;j++){
			if(strcmp(gotol[i],labels[j])==0){
				flg=0;
			}
		}
		if(flg==1){
			printf("label %s on line %d DNE\n",gotol[i],gotoline[i]);
		}
	}
}

