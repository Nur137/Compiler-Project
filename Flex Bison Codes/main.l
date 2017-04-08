/* C Declarations */
%{
	#include<stdio.h>
	#include<wchar.h>
	#include "main.tab.h"
	#include<stdlib.h>
	
	int yylex();
	int yyerror(char *);

	extern int yylval;
%}

KEYWORD "মূল_ফাংশন"|"রিটার্ন"|"যদি"|"অথবা যদি"|"অথবা"|"ছাপান"|"খালি"|"ইনপুট"
OPERATOR "+"|"-"|"*"|"/"|"="|">"|"<"|"=="|"&"|"|"|"!"|">="|"<="
SPECIAL_CHAR ["("|")"|"{"|"}"|"'"|"""|","|"#"]
TYPES "বাস্তবসংখ্যা"|"পূর্ণসংখ্যা"


%%

#\*([^*]|[\r\n]|(\*+([^*#]|[\r\n])))*\*+# {printf(" @@মাল্টিলাইন কমেন্ট পাওয়া গেছে \n",yytext);}

[ ]*[#][#].*  {printf("@@এক লাইন এর কমেন্ট পাওয়া গেছে \n");}

[0-9]+	{
		yylval = atoi(yytext);
		return NUM;
	}
"ক"	{	
		yylval=0;
		return VAR;
	}


"খ"	{	
		yylval=1;
		return VAR;
	}
"গ"	{	
		yylval=2;
		return VAR;
	}


"ঘ"	{	
		yylval=3;
		return VAR;
	}
"ঙ"	{	
		yylval=4;
		return VAR;
	}


"চ"	{	
		yylval=5;
		return VAR;
	}
"ছ"	{	
		yylval=6;
		return VAR;
	}


"জ"	{	
		yylval=7;
		return VAR;
	}
"ঝ"	{	
		yylval=8;
		return VAR;
	}


"ঞ"	{	
		yylval=9;
		return VAR;
	}
"ট"	{	
		yylval=10;
		return VAR;
	}


"ঠ"	{	
		yylval=11;
		return VAR;
	}
"ড"	{	
		yylval=12;
		return VAR;
	}


"ঢ"	{	
		yylval=13;
		return VAR;
	}
"ণ"	{	
		yylval=14;
		return VAR;
	}


"ত"	{	
		yylval=15;
		return VAR;
	}
"থ"	{	
		yylval=16;
		return VAR;
	}


"দ"	{	
		yylval=17;
		return VAR;
	}
	


"ধ"	{	
		yylval=18;
		return VAR;
	}
"ন"	{	
		yylval=19;
		return VAR;
	}


"প"	{	
		yylval=20;
		return VAR;
	}
"ফ"	{	
		yylval=21;
		return VAR;
	}


"ব"	{	
		yylval=22;
		return VAR;
	}
"ভ"	{	
		yylval=23;
		return VAR;
	}


"ম"	{	
		yylval=24;
		return VAR;
	}


"যদি"		{ return IF;		}
"নতুবা"		{ return ELSE;		}
"বর্গ"  {return SQR;  }  



[-+/*<>=,(){};:] {
		yylval = yytext[0];
		return *yytext;
		}

"মূল_ফাংশন"	{ return VOIDMAIN; }
"পূর্ণ_সংখ্যা"  return(INT);
"বাস্তব_সংখ্যা" return(FLOAT);
"যতক্ষণ" {return WHILE; }
"পর্যবেক্ষণ" {return SWITCH; }
"প্রাপ্ত_ফল" {return CASE; }
"ব্রেক" {return BREAK;}
"ডিফল্ট" {return DEFAULT;}

"ছাপান" {return PRINT;} 
"ফ্যাক্ট"  {return FACT;}
"সাইন" {return SIN;}
"কস" {return COS;}


[ \t\n]*	;

.	{
		printf("%s",yytext);
		yyerror("Unknown Character.\n");
	}
%%

/* user subroutines */

int main()
{
	yyin = fopen("code.txt","r");
	yyparse();

}
