%option noyywrap

%{
#include<bits/stdc++.h>
using namespace std;

ofstream yyoutlog; //output filestream for log file

string loglist = ""; //list of tokens along with line numbers

// define necessary c++ variables and functions here (if any)
int lines = 1;

%}

/* Regular Definitions */

delim	 [ \t\v\r]

/* write regular expressions for whitespace and newline */
ws delim+		 

newline  

letter_	 [A-Za-z_]
digit	 [0-9]
int digit+
float [-+]?[0-9]*\.?[0-9]+
binaries 0b[01]+
octals 0o[0-7]+
hexadecimals  0x[0-9a-fA-F]+
floats_scientific [+-]?[0-9]*\.[0-9]+([eE][+-]?[0-9]+)?


/* write regular expressions for id, float and integers */
id		 


%%

{ws} { /* ignore whitespace */ }

{newline} {
			/* do necessary bookkeeping (line number tracking etc.) */
		}


{binaries} {
            loglist="Scope No "+to_string(scope)+": Token <CONST_BIN> Lexeme "+yytext+" found"+"\n"+"\n";
            yyoutlog<<loglist;
        }
{hexadecimals} {
            loglist="Scope No "+to_string(scope)+": Token <CONST_HEX> Lexeme "+yytext+" found"+"\n"+"\n";
            yyoutlog<<loglist;
        }
{octals} {
            loglist="Scope No "+to_string(scope)+": Token <CONST_OCT> Lexeme "+yytext+" found"+"\n"+"\n";
            yyoutlog<<loglist;
        }
{floats_scientific} {
            loglist="Scope No "+to_string(scope)+": Token <CONST_FLOAT_S> Lexeme "+yytext+" found"+"\n"+"\n";
            yyoutlog<<loglist;
        }

if {
			loglist="Line no "+to_string(lines)+": Token <IF> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

else {
			loglist="Scope No "+to_string(scope)+": Token <ELSE> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

range {
            loglist="Scope No "+to_string(scope)+": Token <RANGE> Lexeme "+yytext+" found"+"\n"+"\n";
            yyoutlog<<loglist;
        }

break {
			loglist="Scope No "+to_string(scope)+": Token <BREAK> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

not {
			loglist="Scope No "+to_string(scope)+": Token <NOT> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

catch {
			loglist="Scope No "+to_string(scope)+": Token <CATCH> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

elif {
			loglist="Scope No "+to_string(scope)+": Token <ELIF> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

try {
			loglist="Scope No "+to_string(scope)+": Token <TRY> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
	
except {
			loglist="Scope No "+to_string(scope)+": Token <EXCEPT> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

True {
			loglist="Scope No "+to_string(scope)+": Token <TRUE> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

False {
			loglist="Scope No "+to_string(scope)+": Token <FALSE> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

def {
			loglist="Scope No "+to_string(scope)+": Token <DEF> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

return {
			loglist="Scope No "+to_string(scope)+": Token <RETURN> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

finally {
			loglist="Scope No "+to_string(scope)+": Token <FINALLY> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

for {
			loglist="Line no "+to_string(lines)+": Token <FOR> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}


do {
			loglist="Line no "+to_string(lines)+": Token <DO> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

int {
			loglist="Line no "+to_string(lines)+": Token <CONST_INT> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

float {
			loglist="Line no "+to_string(lines)+": Token <CONST_FLOAT> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

void {
			loglist="Line no "+to_string(lines)+": Token <VOID> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

switch {
			loglist="Line no "+to_string(lines)+": Token <SWITCH> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

default {
			loglist="Line no "+to_string(lines)+": Token <DEFAULT> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

goto {
			loglist="Line no "+to_string(lines)+": Token <goto> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

while {
			loglist="Line no "+to_string(lines)+": Token <WHILE> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
and {
			loglist="Scope No "+to_string(scope)+": Token <AND> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

or {
			loglist="Scope No "+to_string(scope)+": Token <OR> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
	
print {
			loglist="Scope No "+to_string(scope)+": Token <PRINT> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

in {
			loglist="Scope No "+to_string(scope)+": Token <IN> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

continue {
			loglist="Scope No "+to_string(scope)+": Token <CONTINUE> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

pass {
			loglist="Scope No "+to_string(scope)+": Token <PASS> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

None {
			loglist="Scope No "+to_string(scope)+": Token <NONE> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
do {
			loglist="Scope No "+to_string(scope)+": Token <DO> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

"+"|"-" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <ADDOP> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

"*"|"/"|"%" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <MULOP> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

"++"|"--" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <INCOP> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

"<"|">"|"=="|"<="|">="|"!=" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <RELOP> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

"=" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <ASSIGNOP> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
"&&"|"||" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <LOGICOP> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

"!" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <NOT> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

"(" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <LPAREN> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

")" { /* to match two same operators use | */
			loglist="Line no "+to_string(lines)+": Token <RPAREN> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

"{" { /* to match two same operators use | */
			loglist="Scope No "+to_string(scope)+": Token <LCURL> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
		
"}" { /* to match two same operators use | */
			loglist="Scope No "+to_string(scope)+": Token <RCURL> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
		
"[" { /* to match two same operators use | */
			loglist="Scope No "+to_string(scope)+": Token <LTHIRD> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
		
"]" { /* to match two same operators use | */
			loglist="Scope No "+to_string(scope)+": Token <RTHIRD> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
		
"," { /* to match two same operators use | */
			loglist="Scope No "+to_string(scope)+": Token <COMMA> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}
		
":" { /* to match two same operators use | */
			loglist="Scope No "+to_string(scope)+": Token <COLON> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}

{id} {
			loglist="Line no "+to_string(lines)+": Token <ID> Lexeme "+yytext+" found"+"\n"+"\n";
			yyoutlog<<loglist;
		}


%%

int main(int argc, char *argv[])
{

	if(argc != 2) //check if file name is given
	{
		cout<<"Please input file name"<<endl;
		return 0;
	}

	yyin = fopen(argv[1], "r"); //the file to be read must be assigned to yyin

	yyoutlog.open("20301125.txt", ios::trunc); // remember to rename the log file as mentioned in the spec
	
	if(yyin == NULL) // file does not exist
	{
		// print error message and exit
	}
	
	yylex(); // start reading the input file in a loop
	
	//print total number of lines found in the input file
	yyoutlog<<"Total Lines "<< line;
	
	yyoutlog.close();  // close the log file
	
	fclose(yyin); // close the input file
}
