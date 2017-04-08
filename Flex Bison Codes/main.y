%{
	#include<stdio.h>
	#include<stdlib.h>
	
	#include <math.h>
	#include <string.h>
        #define YYSTYPE int
	
	int yylex();
	int yyerror(char *);
	
	int sym[26];
	char ch;
	char rev[100],act[100];
	int cond1,cond2,condop,i,j;

	int op1[100],op2[100],op3[100],op2type[100],op3type[100],opr[100],pos=0;
	

	int swtrack[100],sval=0,swrange[100];
int if_flag = 1, if_else_flag = 1, check = 1;
	

	int sop1[100][100],sop2[100][100],sop3[100][100],sopr[100][100],spos=0;
	int swin;	
	
			
			int checkdef(int val)
			{
				int flag=0;
			for(i=0;i<swin;i++)
			{
				if(swtrack[i]==val)
				{
					return 1;
				}
					
			}
			return 0;
			}
	
	
	int fact(int val)
	{
		int res=1,i;
		for(i=1;i<=val;i++)
		res*=i;
		return res;
	}

	void operation()
	{
		//printf("pos %d\n",pos);
		//printf("%d %d %d %d\n",op1[0],op2[0],op3[0],opr[0]);
		//printf("cond1 %d\n",cond1);


		for(i=0;i<pos;i++)
		{
			if(opr[i]==1)
			sym[op1[i]] = sym[op2[i]] +op3[i];
			else
			sym[op1[i]] = sym[op2[i]] -op3[i];
			//printf("%d\n",sym[op1[i]]);
		}
	}



	void soperation(int val)
	{
			
			//printf("ad %d\n",swin);
			for(i=0;i<swin;i++)
			{
				if(swtrack[i]==val)
				{
					break;
				}
				//printf("%d\n", swtrack[i]);	
			}
			//printf("ad1 %d\n",swin);
			//for(j=0;j<swin;j++)
			//{
			//	printf("%d\n", swrange[j]);	
			//}
			

			//printf("\n");
			//for(i=0;i<swin;i++)
			//{
			int k=0;
				for(j=0;j<swrange[i];j++)
				{
					if(sopr[i][j]==1)
					sym[sop1[i][j]] = sym[sop2[i][j]] +sop3[i][j];
					else
					sym[sop1[i][j]] = sym[sop2[i][j]] -sop3[i][j];
					//printf("%d\n",sym[sop1[i][j]]);

					//printf("abc %d %d %d %d ", sop1[i][j],sop2[i][j],sop3[i][j],sopr[i][j]);
				}
			//printf("\n");
			//}
		
			}
%}

/* BISON Declarations */

%token NUM VAR IF ELSE VOIDMAIN INT FLOAT  ID WHILE SWITCH CASE BREAK DEFAULT PRINT SQR FACT SIN COS
%nonassoc IFX
%nonassoc ELSE
%left '<' '>'
%left '+' '-'
%left '*' '/'


/* Simple grammar rules */


%%

sprogram: VOIDMAIN '(' ')' '{' cstatement '}'
	 ;

cstatement: /* empty */   { }

	| cstatement statement  { }
	;

statement:
	';'  {}
	| declaration ';'						{ }

	| expression ';' 			{  }

	| loop  {printf("লুপ শেষ হয়েছে:\n ");}

	| switchcase  {swin=0;printf("পর্যবেক্ষণ শেষ হয়েছে:\n");}
	
	| P ';' {}

	| IF '(' expression ')' statement %prec IFX  {
								if($3)
								{
									//printf("\nonly if true and value: %d",$3);
									printf("\nvalue of expression in IF: %d\n",$5);
									//if_else_flag = 0;
									if_flag = 1;
									check = 1;
								}
								
								else
								{
									if(if_flag == 1)
									{
										printf("condition value zero in IF block\n");
										if_flag = 0;
										if_else_flag = 0;
										check = 1;
									}
								}
								
							}


	| IF '(' expression ')' statement ELSE statement {
								 	if($3  )
									{
										if_flag = 0;
										if_else_flag = 0;
										//printf("\nonly else if true and value: %d",$3);
										printf("\nvalue of expression in IF: %d\n",$5);
										check = 1;
									}
									else
									{	
										if(if_else_flag == 1)
										{
											check = 1;
											if_flag = 0;
											if_else_flag = 0;
											//printf("\nonly else else true");
											printf("\nvalue of expression in ELSE: %d\n",$7);
										}
									}
								   }
;
P:PRINT PRINTABLE  
;

PRINTABLE: VAR  		{ $$ = sym[$1];printf("%d ছাপা হয়েছে:\n",$$); } 
	| SQR '(' N_V  ')'    { $$ = $3*$3; printf("%d ছাপা হয়েছে:\n",$$); }
	|  FACT '(' N_V  ')'   { $$ = fact($3);printf("%d ছাপা হয়েছে:\n",$$); }
	| SIN '(' N_V ')'  { double v=sin($3*3.1416/180); printf("%lf ছাপা হয়েছে:\n",v); }
	
	| COS '(' N_V ')'  { double v=cos($3*3.1416/180); printf("%lf ছাপা হয়েছে:\n",v); }
;

N_V: 
NUM {$$=$1;} 
|VAR {$$=sym[$1];}
;
switchcase: SWITCH '(' expression ')' '{' sstatement DEFAULT ':' wstatement '}' 
{	
	soperation($3);
	if(checkdef($3)==0)
	{
	 	operation();   
	}
}
;

sstatement: /* empty */

	| sstatement ss 
;

ss: CASE expression ':' swstatement BREAK
{
	swtrack[swin]=$2;
	swin++;	
	sval++;
	swrange[sval-1]=spos;
	//printf("qqahdjkahd  %d %d\n",sval,spos);
	spos=0;
}
;


swstatement: /* empty */   { }

	| swstatement swstats  { }
	;

swstats:
	VAR '=' VAR '+' NUM ';' {sop1[sval][spos]=$1; sop2[sval][spos]=$3; sop3[sval][spos]=$5;  sopr[sval][spos]=1; spos++; }

	| VAR '=' VAR '-' NUM ';' { sop1[sval][spos]=$1; sop2[sval][spos]=$3; sop3[sval][spos]=$5;  sopr[sval][spos]=2; spos++; }
;

declaration : TYPE ID1					{ }
			;

loop:
		 WHILE '(' condition  ')' '{' wstatement '}'
{
if(cond2==-1)
{
		while(sym[cond1])
		{
			operation();
		}
}

else
{
	if(condop==1)
	{
		while(sym[cond1]<cond2)
		{
			operation();
		}

	}
	else if(condop==2)
	{

		while(sym[cond1]>cond2)
		{
			operation();
		}
	}
	else if(condop==3)
	{

		while(sym[cond1]==cond2)
		{
			operation();
		}
	}
}
}
;


wstatement: /* empty */   {}

	| wstatement stats  {}
	;

stats:
	VAR '=' VAR '+' NUM ';' { op1[pos]=$1; op2[pos]=$3; op3[pos]=$5;  opr[pos]=1; pos++; }
	| VAR '=' VAR '-' NUM ';' { op1[pos]=$1; op2[pos]=$3; op3[pos]=$5;  opr[pos]=2; pos++; }
;

condition:
		VAR
{
	pos=0;
	cond1=$1;
	cond2=-1;
	//printf("only var");
}

| VAR '<' NUM
{
	pos=0;
	cond1=$1;
	cond2=$3;
	condop=1;
//	printf("var < num");
}




| VAR '>' NUM
{
	pos=0;
	cond1=$1;
	cond2=$3;
	condop=2;
	//printf("var > num");
}


| VAR '=''=' NUM
{
	pos=0;
	cond1=$1;
	cond2=$3;
	condop=3;
	//printf("var == num");
}
;

TYPE : INT							{}
     | FLOAT						{}
     
     ;


ID1 : ID1 ',' expression				{}
    |expression							{}
    ;

expression: NUM				{ $$ = $1;  	}


	| VAR '=' expression 		{
							sym[$1] = $3;}
	| expression '+' expression	{ $$ = $1 + $3; }

	| expression '-' expression	{ $$ = $1 - $3; }

	| expression '*' expression	{ $$ = $1 * $3; }

	| expression '/' expression	{ 	if($3)
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		}
				    	}

	| expression '<' expression	{ $$ = $1 < $3;  }

	| expression '>' expression	{ $$ = $1 > $3; }

	| '(' expression ')'		{ $$ = $2;	}
	;
%%

int yywrap()
{
return 1;
}


int yyerror(char *s){
	printf( "%s\n", s);
	return 0;
}
