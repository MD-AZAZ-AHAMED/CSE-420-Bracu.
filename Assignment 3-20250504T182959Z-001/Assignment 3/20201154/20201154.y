%{

#include"symbol_info.h"
#include "symbol_table.h"

#define YYSTYPE symbol_info*

extern FILE *yyin;
int yyparse(void);
int yylex(void);
extern YYSTYPE yylval;
// create your symbol table here.
// You can store the pointer to your symbol table in a global variable
// or you can create an object


int lines = 1;
ofstream outerror;
ofstream outlog;
symbol_table st(10, &outlog);
vector<symbol_info *> params;

// you may declare other necessary variables here to store necessary info
// such as current variable type, variable list, function name, return type, function parameter types, parameters names etc.

int param_count = 0;
int error_count = 0;
void yyerror(char *s) {
    outlog<<"At line "<<lines<<" "<<s<<endl<<endl;
}
void report_error(string msg) {
    outerror << "Error at line " << lines << ": " << msg << endl;
    error_count++;
}

%}

%token IF ELSE FOR WHILE DO BREAK INT CHAR FLOAT DOUBLE VOID RETURN SWITCH CASE DEFAULT CONTINUE PRINTLN ADDOP MULOP INCOP DECOP RELOP ASSIGNOP LOGICOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON CONST_INT CONST_FLOAT ID

%nonassoc IFX
%nonassoc ELSE
%%

start : program
	{
		outlog<<"At line no: "<<lines<<" start : program "<<endl<<endl;
		outlog << "Symbol Table" << endl << endl;
		// Print your whole symbol table here
		st.print_all_scopes();
	}
	;

program : program unit
	{
		outlog<<"At line no: "<<lines<<" program : program unit "<<endl<<endl;
		outlog<<$1->getname()<<"\n"<<$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"\n"+$2->getname(),"program");
	}
	| unit
	{
		outlog<<"At line no: "<<lines<<" program : unit "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"program");
	}
	;

unit : var_declaration
	{
		outlog<<"At line no: "<<lines<<" unit : var_declaration "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;

		$$ = new symbol_info($1->getname(), "unit");
		
	}
	| func_definition
	{
		outlog<<"At line no: "<<lines<<" unit : func_definition "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;

		$$ = new symbol_info($1->getname(), "unit");
	}
	;
	
func_definition : type_specifier ID LPAREN parameter_list RPAREN 
	{
		$2->set_symbol_type("Function Definition");
		$2->set_return_type($1->getname());

		stringstream ss($4->getname());
		string token;
		while (getline(ss, token, ',')) {
        	$2->add_param_type(token);
    	}
		st.insert($2);
	}
	compound_statement
	{	
		outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement "<<endl<<endl;
		outlog<<$1->getname()<<" "<<$2->getname()<<"("<<$4->getname()<<")\n"<<$7->getname()<<endl<<endl;

		$$ = new symbol_info($1->getname()+" "+$2->getname()+"("+$4->getname()+")\n"+$7->getname(),"func_def");	
		// The function definition is complete.
	// You can now insert necessary information about the function into the symbol table
    // However, note that the scope of the function and the scope of the compound statement are different.

	}
	| type_specifier ID LPAREN RPAREN
	{
		$2->set_symbol_type("Function Definition");
		$2->set_return_type($1->getname());

		st.insert($2);
	}
	compound_statement
	{
		
		outlog<<"At line no: "<<lines<<" func_definition : type_specifier ID LPAREN RPAREN compound_statement "<<endl<<endl;
		outlog<<$1->getname()<<" "+$2->getname()<<"()\n"<<$6->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+" "+$2->getname()+"()\n"+$6->getname(),"func_def");	
		// The function definition is complete.
        // You can now insert necessary information about the function into the symbol table
        // However, note that the scope of the function and the scope of the compound statement are different.

	}
	;
	
parameter_list	: parameter_list COMMA type_specifier ID
	{
		outlog<<"At line no: "<<lines<<" parameter_list	: parameter_list COMMA type_specifier ID "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<" "<<$4->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+","+$3->getname()+" "+$4->getname(),"parameter_list");

		$4->set_symbol_type("Variable");
		$4->set_return_type($3->getname());

		params.push_back($4);
		param_count++;
	}
	| parameter_list COMMA type_specifier
	{
		outlog<<"At line no: "<<lines<<" parameter_list	: parameter_list COMMA type_specifier "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+","+$3->getname(),"parameter_list");	
		// store the necessary information about the function parameters
        // They will be needed when you want to enter the function into the symbol table
	}
	| type_specifier ID
	{
		outlog<<"At line no: "<<lines<<" parameter_list	: type_specifier ID "<<endl<<endl;
		outlog<<$1->getname()<<" "<<$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+" "+$2->getname(),"parameter_list");	

		$2->set_symbol_type("Variable");
		$2->set_return_type($1->getname());

		params.push_back($2);
		param_count++;
	}
	| type_specifier
	{
		outlog<<"At line no: "<<lines<<" parameter_list	: type_specifier "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"parameter_list");
		// store the necessary information about the function parameters
        // They will be needed when you want to enter the function into the symbol table
	
	}
	;

compound_statement : LCURL 
	{
		st.enter_scope();
		if (param_count > 0) {
			for (auto param : params) {
				st.insert(param);
			}
			param_count = 0;
			params.clear();
	}
	}
	statements RCURL
	{
		outlog<<"At line no: "<<lines<<" compound_statement : LCURL statements RCURL "<<endl<<endl;
		outlog<<"{\n"+$3->getname()+"\n}"<<endl<<endl;
		
		$$ = new symbol_info("{\n"+$3->getname()+"\n}","compound_statement");

		if (param_count > 0) {
			for (auto param : params) {
				st.insert(param);
			}
			param_count = 0;
			params.clear();
		}

		st.print_all_scopes();
		st.exit_scope();
	}
	| LCURL RCURL
	{
		outlog<<"At line no: "<<lines<<" compound_statement : LCURL RCURL "<<endl<<endl;
		outlog<<"{\n}"<<endl<<endl;
		
		$$ = new symbol_info("{\n}","compound_statement");
		// The compound statement is complete.
    // Print the symbol table here and exit the scope
	}
	;

var_declaration : type_specifier declaration_list SEMICOLON
	{
		outlog<<"At line no: "<<lines<<" var_declaration : type_specifier declaration_list SEMICOLON "<<endl<<endl;
		outlog<<$1->getname()<<" "<<$2->getname()<<";"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+" "+$2->getname()+";","var_declaration");

		stringstream ss_var($2->getname());
		string token_var;
		while (getline(ss_var, token_var, ',')) {
			symbol_info *func = new symbol_info(token_var, "ID");

			size_t index_lthird = token_var.find("[");
			size_t index_rthird = token_var.find("]");
			if (index_lthird != string::npos) {
				func->set_name(token_var.substr(0, index_lthird));
				func->set_symbol_type("Array");
				func->set_return_type($1->getname());

				string s = token_var.substr(index_lthird + 1, index_rthird - index_lthird - 1);
				func->set_size(stoi(s));
			} else {
				func->set_symbol_type("Variable");
				func->set_return_type($1->getname());
			}

			if (!st.insert(func)) {
				report_error("Multiple declaration of variable '" + func->getname() + "'");
			}
    	}
	}
	;

type_specifier : INT
	{
		outlog<<"At line no: "<<lines<<" type_specifier : INT "<<endl<<endl;
		outlog<<"int"<<endl<<endl;
		
		$$ = new symbol_info("int","type");
	
	}
	| FLOAT
	{
		outlog<<"At line no: "<<lines<<" type_specifier : FLOAT "<<endl<<endl;
		outlog<<"float"<<endl<<endl;
		
		$$ = new symbol_info("float","type");
	
	}
	| VOID
	{
		outlog<<"At line no: "<<lines<<" type_specifier : VOID "<<endl<<endl;
		outlog<<"void"<<endl<<endl;
		
		$$ = new symbol_info("void","type");
	}
	;

declaration_list : declaration_list COMMA ID
	{
		outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+","+$3->getname(),"declaration_list");
	}
	| declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
	{
		outlog<<"At line no: "<<lines<<" declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
		outlog<<$1->getname()+","<<$3->getname()<<"["<<$5->getname()<<"]"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+","+$3->getname()+"["+$5->getname()+"]","declaration_list");
	}
	| ID
	{
		outlog<<"At line no: "<<lines<<" declaration_list : ID "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"declaration_list");
	}
	| ID LTHIRD CONST_INT RTHIRD
	{
		outlog<<"At line no: "<<lines<<" declaration_list : ID LTHIRD CONST_INT RTHIRD "<<endl<<endl;
		outlog<<$1->getname()<<"["<<$3->getname()<<"]"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"["+$3->getname()+"]","declaration_list");
	}
	;

statements : statement
	{
		outlog<<"At line no: "<<lines<<" statements : statement "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"statements");
	}
	| statements statement
	{
		outlog<<"At line no: "<<lines<<" statements : statements statement "<<endl<<endl;
		outlog<<$1->getname()<<"\n"<<$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"\n"+$2->getname(),"statements");
	}
	;

statement : var_declaration
	{
		outlog<<"At line no: "<<lines<<" statement : var_declaration "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"statement");
	}
	| func_definition
	{
	  		outlog<<"At line no: "<<lines<<" statement : func_definition "<<endl<<endl;
            outlog<<$1->getname()<<endl<<endl;

            $$ = new symbol_info($1->getname(),"stmnt");
	  		
	}
	| expression_statement
	{
		outlog<<"At line no: "<<lines<<" statement : expression_statement "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"statement");
	}
	| compound_statement
	{
		outlog<<"At line no: "<<lines<<" statement : compound_statement "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"statement");
	}
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement
	{
		outlog<<"At line no: "<<lines<<" statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement "<<endl<<endl;
		outlog<<"for("<<$3->getname()<<$4->getname()<<$5->getname()<<")\n"<<$7->getname()<<endl<<endl;
		
		$$ = new symbol_info("for("+$3->getname()+$4->getname()+$5->getname()+")\n"+$7->getname(),"statement");
	}
	| IF LPAREN expression RPAREN statement %prec IFX
	{
		outlog<<"At line no: "<<lines<<" statement : IF LPAREN expression RPAREN statement "<<endl<<endl;
		outlog<<"if("<<$3->getname()<<")\n"<<$5->getname()<<endl<<endl;
	
		$$ = new symbol_info("if("+$3->getname()+")\n"+$5->getname(),"statement");
	}
	| IF LPAREN expression RPAREN statement ELSE statement
	{
		outlog<<"At line no: "<<lines<<" statement : IF LPAREN expression RPAREN statement ELSE statement "<<endl<<endl;
		outlog<<"if("<<$3->getname()<<")\n"<<$5->getname()<<"\nelse\n"<<$7->getname()<<endl<<endl;
	
		$$ = new symbol_info("if("+$3->getname()+")\n"+$5->getname()+"\nelse\n"+$7->getname(),"statement");
	}
	| WHILE LPAREN expression RPAREN statement
	{
		outlog<<"At line no: "<<lines<<" statement : WHILE LPAREN expression RPAREN statement "<<endl<<endl;
		outlog<<"while("<<$3->getname()<<")\n"<<$5->getname()<<endl<<endl;
		
		$$ = new symbol_info("while("+$3->getname()+")\n"+$5->getname(),"statement");
	}
	| PRINTLN LPAREN ID RPAREN SEMICOLON
	{
		outlog<<"At line no: "<<lines<<" statement : PRINTLN LPAREN ID RPAREN SEMICOLON "<<endl<<endl;
		outlog<<"printf("<<$3->getname()<<");"<<endl<<endl; 
		
		$$ = new symbol_info("printf("+$3->getname()+");","statement");
	}
	| RETURN expression SEMICOLON
	{
		outlog<<"At line no: "<<lines<<" statement : RETURN expression SEMICOLON "<<endl<<endl;
		outlog<<"return "<<$2->getname()<<";"<<endl<<endl;
		
		$$ = new symbol_info("return "+$2->getname()+";","statement");
	}
	;

expression_statement : SEMICOLON
	{
		outlog<<"At line no: "<<lines<<" expression_statement : SEMICOLON "<<endl<<endl;
		outlog<<";"<<endl<<endl;

		$$ = new symbol_info(";","expression_statement");
	}
	| expression SEMICOLON
	{
		outlog<<"At line no: "<<lines<<" expression_statement : expression SEMICOLON "<<endl<<endl;
		outlog<<$1->getname()<<";"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+";","expression_statement");
	}
	;

variable : ID
	{
		outlog<<"At line no: "<<lines<<" variable : ID "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"variable");
		$$->set_return_type("int");
		symbol_info* sym = st.lookup(new symbol_info($1->getname(), "ID"));
		if (sym) {
			if (sym->get_symbol_type() == "Array") {
				report_error("variable is of array type :" + $1->getname());
			}
			$$->set_return_type(sym->get_return_type());
	    }
		if (!sym) {
			report_error("Undeclared variable '" + $1->getname() + "'");
			$$->set_return_type(""); // safe fallback
		}
		else {
			$$->set_return_type(sym->get_return_type());
		}
	    
	}
	
	| ID LTHIRD expression RTHIRD
	{
		outlog<<"At line no: "<<lines<<" variable : ID LTHIRD expression RTHIRD "<<endl<<endl;
		outlog<<$1->getname()<<"["<<$3->getname()<<"]"<<endl<<endl;
	
		$$ = new symbol_info($1->getname()+"["+$3->getname()+"]","variable");
        	// Lookup the array symbol
		symbol_info* sym = st.lookup(new symbol_info($1->getname(), "ID"));

		if (sym) {
			// Check if the symbol is actually an array
			if (sym->get_symbol_type() != "Array") {
				report_error("Variable '" + $1->getname() + "' is not of array type");
			}

			// Check index type
			string idx_type = $3->get_return_type();
			if (idx_type != "int") {
				report_error("Array index is not of integer type : " + $1->getname());
			}

			// Set return type as element type
			$$->set_return_type(sym->get_return_type());
	}
	}
	;

expression : logic_expression
	{
		outlog<<"At line no: "<<lines<<" expression : logic_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"expression");
		$$->set_return_type($1->get_return_type());
	}
	| variable ASSIGNOP logic_expression

	{
		outlog << "At line no: " << lines << " expression : variable ASSIGNOP logic_expression" << endl << endl;
		outlog << $1->getname() << " = " << $3->getname() << endl << endl;

		$$ = new symbol_info($1->getname() + "=" + $3->getname(), "expression");

		// Only fetch LHS type
		symbol_info* lhs = st.lookup(new symbol_info($1->getname(), "ID"));
		if (lhs) {
			string lhs_type = lhs->get_return_type();
			string rhs_type = $3->get_return_type();

			$$->set_return_type(lhs_type); // propagate

			if (lhs_type == "int" && rhs_type == "float") {
				outerror << "Warning at line " << lines << ": Assignment of float value into variable of integer type" << endl;
			    error_count++;
			}
		}
	}
	;

logic_expression : rel_expression
	{
		outlog<<"At line no: "<<lines<<" logic_expression : rel_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"logic_expression");
		$$->set_return_type($1->get_return_type());
	}
	| rel_expression LOGICOP rel_expression
	{
		outlog<<"At line no: "<<lines<<" logic_expression : rel_expression LOGICOP rel_expression "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"logic_expression");
	}
	;

rel_expression : simple_expression
	{
		outlog<<"At line no: "<<lines<<" rel_expression : simple_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"rel_expression");
		$$->set_return_type($1->get_return_type());
	}
	| simple_expression RELOP simple_expression
	{
		outlog<<"At line no: "<<lines<<" rel_expression : simple_expression RELOP simple_expression "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"rel_expression");
	}
	;

simple_expression : term
	{
		outlog<<"At line no: "<<lines<<" simple_expression : term "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"simple_expression");
		$$->set_return_type($1->get_return_type());
	}
	| simple_expression ADDOP term
	{
		outlog<<"At line no: "<<lines<<" simple_expression : simple_expression ADDOP term "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"simple_expression");
	}
	;

term : unary_expression
	{
		outlog<<"At line no: "<<lines<<" term : unary_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"term");
		$$->set_return_type($1->get_return_type());
	}
	| term MULOP unary_expression
	{
		outlog<<"At line no: "<<lines<<" term : term MULOP unary_expression "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname()+$3->getname(),"term");
		string left_type = $1->get_return_type();
		string right_type = $3->get_return_type();
		string op = $2->getname();

		// Modulus operator check
		if (op == "%") {
			if (left_type != "int" || right_type != "int") {
				report_error("Modulus operator on non integer type");
			} else {
				$$->set_return_type("int");
			}
		}
			// Division or Modulus by zero check — only for constants
		if ((op == "/" || op == "%") && $3->getname() == "0") {
			report_error("Division or Modulus by Zero");
		}
		// Set return type
		if (op == "*" || op == "/" || op == "%") {
			if (left_type == "float" || right_type == "float")
				$$->set_return_type("float");
			else
				$$->set_return_type("int");
		}
	}
	;

unary_expression : ADDOP unary_expression // un_expr can be void because of factor
	{
		outlog<<"At line no: "<<lines<<" unary_expression : ADDOP unary_expression "<<endl<<endl;
		outlog<<$1->getname()<<$2->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+$2->getname(),"unary_expression");
	}
	| NOT unary_expression
	{
		outlog<<"At line no: "<<lines<<" unary_expression : NOT unary_expression "<<endl<<endl;
		outlog<<"!"<<$2->getname()<<endl<<endl;
		
		$$ = new symbol_info("!"+$2->getname(),"unary_expression");
	}
	| factor
	{
		outlog<<"At line no: "<<lines<<" unary_expression : factor "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"unary_expression");
		$$->set_return_type($1->get_return_type());
	}
	;

factor : variable
	{
		outlog<<"At line no: "<<lines<<" factor : variable "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"factor");
	}
	| ID LPAREN argument_list RPAREN
	{
		outlog<<"At line no: "<<lines<<" factor : ID LPAREN argument_list RPAREN "<<endl<<endl;
		outlog<<$1->getname()<<"("<<$3->getname()<<")"<<endl<<endl;

		$$ = new symbol_info($1->getname()+"("+$3->getname()+")","factor");
		symbol_info* func = st.lookup(new symbol_info($1->getname(), "ID"));
		if (!func) {
			report_error("Undeclared function '" + $1->getname() + "'");
		} else {
			if (func->get_symbol_type() != "Function Definition") {
				report_error("'" + $1->getname() + "' is not a function");
			} else {
				$$->set_return_type(func->get_return_type());
			}
		}
	}
	| LPAREN expression RPAREN
	{
		outlog<<"At line no: "<<lines<<" factor : LPAREN expression RPAREN "<<endl<<endl;
		outlog<<"("<<$2->getname()<<")"<<endl<<endl;
	
		$$ = new symbol_info("("+$2->getname()+")","factor");
	}
	| CONST_INT
	{
		outlog<<"At line no: "<<lines<<" factor : CONST_INT "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"factor");
		$$->set_return_type("int");
	}
	| CONST_FLOAT
	{
		outlog<<"At line no: "<<lines<<" factor : CONST_FLOAT "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"factor");
		$$->set_return_type("float");
	}
	| variable INCOP
	{
		outlog<<"At line no: "<<lines<<" factor : variable INCOP "<<endl<<endl;
		outlog<<$1->getname()<<"++"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"++","factor");
	}
	| variable DECOP
	{
		outlog<<"At line no: "<<lines<<" factor : variable DECOP "<<endl<<endl;
		outlog<<$1->getname()<<"--"<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+"--","factor");
	}
	;

argument_list : arguments
	{
		outlog<<"At line no: "<<lines<<" argument_list : arguments "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"argument_list");
	}
	|
	{
		outlog<<"At line no: "<<lines<<" argument_list :  "<<endl<<endl;
		outlog<<""<<endl<<endl;
					
		$$ = new symbol_info("","argument_list");
	}
	;

arguments : arguments COMMA logic_expression
	{
		outlog<<"At line no: "<<lines<<" arguments : arguments COMMA logic_expression "<<endl<<endl;
		outlog<<$1->getname()<<","<<$3->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname()+","+$3->getname(),"arguments");
	}
	| logic_expression
	{
		outlog<<"At line no: "<<lines<<" arguments : logic_expression "<<endl<<endl;
		outlog<<$1->getname()<<endl<<endl;
		
		$$ = new symbol_info($1->getname(),"arguments");
	}
	;

%%

int main(int argc, char *argv[])
{
	if(argc != 2) 
	{
		cout << "Please input file name" << endl;
		return 0;
	}

	yyin = fopen(argv[1], "r");
	outlog.open("my_log.txt", ios::trunc);      // your existing log file
	outerror.open("20201154_error.txt", ios::trunc); // new error file

	st.enter_scope();  // already used, keep it

	if(yyin == NULL)
	{
		cout << "Couldn't open file" << endl;
		return 0;
	}

	yyparse();

	outlog << endl << "Total lines: " << lines << endl;
	outlog << "Total errors: " << error_count << endl;

	outerror << "Total errors: " << error_count << endl;

	outlog.close();
	outerror.close();
	fclose(yyin);

	return 0;
}
