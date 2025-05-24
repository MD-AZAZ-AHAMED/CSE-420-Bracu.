%option noyywrap

%{
#include "symbol_info.h"
#define YYSTYPE symbol_info*
#include "y.tab.h"
extern YYSTYPE yylval;
void yyerror(char *);
extern int lines;
%}

delim    [ \t\v\r\f]
newline  \r?\n
ws       {delim}+
letter_  [A-Za-z_]
digit    [0-9]
id       {letter_}({letter_}|{digit})*
integers {digit}+
floats   {digit}*(\.{digit}+)|{digit}*(\.{digit}+)?((E|e)[-]?{digit}+)

%%

{ws}      { /* ignore */ }
{newline} { lines++; }

"if"          { return IF; }
"else"        { return ELSE; }
"for"         { return FOR; }
"while"       { return WHILE; }
"int"         { return INT; }
"float"       { return FLOAT; }
"void"        { return VOID; }
"return"      { return RETURN; }
"printf"      { return PRINTLN; }

"+"|"-"       { yylval = new symbol_info(yytext, "ADDOP"); return ADDOP; }
"*"|"/"|"%"   { yylval = new symbol_info(yytext, "MULOP"); return MULOP; }
"++"          { return INCOP; }
"--"          { return DECOP; }
"<"|">"|"<="|">="|"=="|"!=" { yylval = new symbol_info(yytext, "RELOP"); return RELOP; }
"="           { return ASSIGNOP; }
"&&"|"||"     { yylval = new symbol_info(yytext, "LOGICOP"); return LOGICOP; }
"!"           { return NOT; }
"("           { return LPAREN; }
")"           { return RPAREN; }
"{"           { return LCURL; }
"}"           { return RCURL; }
"["           { return LTHIRD; }
"]"           { return RTHIRD; }
";"           { return SEMICOLON; }
","           { return COMMA; }

{id}       { yylval = new symbol_info(yytext, "ID"); return ID; }
{integers} { yylval = new symbol_info(yytext, "INT"); return CONST_INT; }
{floats}   { yylval = new symbol_info(yytext, "FLOAT"); return CONST_FLOAT; }

%%