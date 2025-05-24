%{
#include "symbol_table.h"
#define YYSTYPE symbol_info*
extern FILE *yyin;
int yyparse(void);
int yylex(void);
extern YYSTYPE yylval;

int lines = 1;
ofstream outlog;
symbol_table *symtab;
string current_type;
vector<string> current_param_types;

void yyerror(char *s) {
    outlog << "At line " << lines << ": " << s << endl << endl;
}
%}

%token IF ELSE FOR WHILE INT FLOAT VOID RETURN PRINTLN
%token ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT
%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON
%token CONST_INT CONST_FLOAT ID

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

// Your grammar rules here (maintain the ones you already have)
// Ensure they call symtab->enter_scope(), exit_scope(), insert(), etc.

%%

int main(int argc, char *argv[]) {
    if (argc != 2) {
        cout << "Usage: ./compiler input.c" << endl;
        return 1;
    }
    yyin = fopen(argv[1], "r");
    outlog.open("1805001_log.txt");
    symtab = new symbol_table(10);
    outlog << "ScopeTable# 1 created" << endl << endl;
    yyparse();
    outlog << endl << "Total lines: " << lines << endl;
    delete symtab;
    fclose(yyin);
    outlog.close();
    return 0;
}