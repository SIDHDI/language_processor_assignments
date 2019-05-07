%{
    #include"y.tab.h"	
    #include<string.h>
    #include<stdlib.h>
    extern int Dbool=0;
    extern int Bbool=0;
    extern int Cbool=0;
    extern int count=0;
    extern int First=1;
    extern FILE *yyout;
    typedef struct tag{
    	char s[200];
    	struct tag* next;
    }ListNode;
    extern ListNode *head=NULL,*tail=NULL,*temp1=NULL,*temp2=NULL;
%}
alpha [a-zA-Z]
digit [0-9]
op [+-/*^&|]
%%

[ \t\n]				            {fprintf(yyout,"%s",yytext);}

switch                          {   
                                    fprintf(yyout,"var_exp%d=",count++); 
                                    Dbool=0;
                                    Bbool=1;
                                    Cbool=0;
                                    First=1;
                                    return S;
                                }

case                            {   
                                    Cbool=1;
                                    if(Bbool==1){
                                    	temp1=head;
                                    	while(head){
                                    		fprintf(yyout,"%s\n",head->s);
                                    		head=head->next;
//                                    		fprintf(yyout,"hi\n");
                                    		temp1=head;
                                    		while(temp1){
  //                                  			fprintf(yyout,"hello\n");
                                    			fprintf(yyout,"%s\n",temp1->s);
                                    			temp1=temp1->next;
                                    			if(temp1){
                                    				temp1=temp1->next;
                                    			}
                                    		}
                                    		fprintf(yyout,"\n");
                                    		if(head){
                                    			head=head->next;
                                    		}
                                    	}
		                              if(First==1){
		                              	fprintf(yyout,"if(var_exp%d==",count-1);
		                              	First=0;
		                              }
		                              else if(Dbool==0){
		                              	fprintf(yyout,"}\nelse if(var_exp%d==",count-1);
		                              }
		                              else{
		                              	fprintf(yyout,"}\nelse{",count-1);
		                              }
		                        }
		                        else{
		                        	temp1=(ListNode*)malloc(sizeof(ListNode));
		                        	temp1->next=NULL;
		                        	if(head==NULL){
		                        		tail=head=temp1;
		                        	}
							else{
								tail->next=temp1;
								tail=temp1;
							}
							char buffer[54];
							snprintf(buffer,10,"%d", count-1);
							//itoa(count-1,buffer,10);
							strcat(temp1->s,"}\nelse if(var_exp");
							strcat(temp1->s, buffer);
							strcat(temp1->s,"==");
							temp2=(ListNode*)malloc(sizeof(ListNode));
		                        	temp2->next=NULL;
		                        	tail->next=temp2;
		                        	tail=temp2;
		                        }
		                        	
                                    /*if(Bbool==0 && Dbool==0)
                                    {
                                        if(First==0){
                                            fprintf(yyout,"//}");
                                        }
                                        fprintf(yyout,"if(var_exp%d==",count-1); 
                                        if(First!=0)
                                            First=0;
                                    }else if (Bbool==1 && Dbool==0){
                                        fprintf(yyout,"}else if(var_exp%d==",count-1);
                                    }*/
                                    Bbool=0;
                                    Dbool=0;
                                    return C;
                                }

break                           {   
                                    Bbool=1; 
                                    Cbool=0;
                                    return B;
                                }

default                         {   
                                    Dbool=1; 
                                    fprintf(yyout,"}\nelse{");
                                    if(count!=0){
                                       // count--;
                                        Bbool=-1;
                                        Cbool=-1;
                                    }
                                    return D;
                                }
                                
main				            {fprintf(yyout,"%s(){",yytext);return M;}
#.*\n                           {fprintf(yyout,"%s",yytext);return I;}
'\.'                            {fprintf(yyout,"%s",yytext);return DOT;}
{digit}+                        {if(temp1==NULL){fprintf(yyout,"%s){",yytext);} 
					else {strcat(temp1->s,yytext);strcat(temp1->s,"){");}return NUM;}
{alpha}+({digit}|{alpha}|"_")*  {fprintf(yyout,"%s",yytext);if(tail) strcat(tail->s,yytext);return ID;}
\'.\'                           {fprintf(yyout,"%s",yytext);return CHAR;}
[+-/*^&|]                       {fprintf(yyout,"%s",yytext);if(tail) strcat(tail->s,yytext);return OPER;}
:                               {   
                                    if(Dbool==0 && Cbool==1 && Bbool!=1 )
                                    {
                                        //fprintf(yyout,"){");
                                    } else if(Dbool==1 && Bbool==1 )
                                    {
                                        fprintf(yyout,"}else{");
                                  
                                    }
                                    return L;
                                }
=                               {fprintf(yyout,"%s",yytext);if(tail) strcat(tail->s,yytext);return EQ;}
.                               {return yytext[0];}
        

%%

int yywrap(){
    return 1;
}

char * newelem(char * s)
{
  return s++;
}

int main(){
	yyin=fopen("sample1.c","r+");
	yyout = fopen("output.c", "w");
	if(yyin==NULL)
	{
		printf("\n Error ! \n");
	}
	else 
	{
	    printf("am parsing !");
	    yyparse();
	    fprintf(yyout,"asdf\n");
	    printf("wer\n");
	}

    //   printf("var_exp%d=%s",count++,exp);
    //BRACKETS,DEFAULT,FLUSH OF LAST LINKED LIST 
    return 0;
}




