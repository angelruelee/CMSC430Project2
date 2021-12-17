/* CMSC 430: Compiler Theory and Design */
/* Name: Angel Lee */
/* Project 2* /
/* Date: Oct 31, 2021*/
/* This file is the parser with parsing methods, edited from lecture source file to fit Project 2 criteria */

%{

#include <string>

using namespace std;

#include "listing.h"

int yylex();
void yyerror(const char* message);

%}

%define parse.error verbose

%token IDENTIFIER TYPE
%token INT_LITERAL REAL_LITERAL BOOL_LITERAL

%token ARROW CASE ELSE ENDCASE ENDIF IF OTHERS REAL THEN WHEN

%token ADDOP MULOP RELOP ANDOP OROP NOTOP REMOP EXPOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS

%%

function: ///counts the whole text
	function_header optional_variable body ;
	
function_header: ///first line, must start with "function", and IDENTIFIER or test name based off the id in scanner.l, optional parameter, "returns", and then type
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	error ';' ; ///added otherwise parser will stop at error at function header

optional_variable: ///optional variable can include a variable or nothing/blank
	optional_variable variable | ///another optional_variable added in case of 2 or more variable lines such as in test12
	;

variable: ///identifier + ':' + 'is', then type (int, real, or bool), word 'is', then statement
	IDENTIFIER ':' type IS statement_ |
	error ';' ; ///added otherwise parser will stop at error at variable problems

parameters: ///used in function header
	'(' parameters ')' | ///put stuff in parenthesis
	parameter ; ///or parameter

parameter: ///used in parameters
	IDENTIFIER ':' type | ///identifier or test name with ':' and then type (int, real, or bool)
	; ///or be blank

type: ///used in function header, can be integer, real, or boolean
	INTEGER | 
	REAL | 
	BOOLEAN ;

body: ///used in function
	BEGIN_ statement_ END ';' ; /// begin + statement + end
    
statement_: ///statement with parenthesis, used in body and variable
	statement ';' | ///a statement
	error ';' ;
	
statement:
	expression | ///can be OR relation, or just and
	REDUCE operator reductions ENDREDUCE | /// 'reduce' + '+-*/' + 'reduction or blank' + 'endreduce'
	IF expression THEN statement_ ELSE statement_ ENDIF | /// if _ then 'statement' else 'statement' endif
	CASE expression IS case_ OTHERS ARROW statement_ ENDCASE ; ///case _ is 'when int. => statement' others => statement endcase
	
operator: // +-*/
	ADDOP |
	MULOP ;
	
case_: ///can be a case, or blank
	case_ case | ///edited
	;
		
case: ///used in statement
	WHEN INT_LITERAL ARROW statement_ ; ///when int. => 'statement'

reductions:
	reductions statement_ |
	; ///or blank

expression:
	expression OROP relation | ///changed to OROP as this has least precedence
	andop;

andop:
	expression ANDOP relation |
	relation;

relation:
	relation RELOP term |
	term;

term:
	term ADDOP remop |
	remop ;
  
remop:
	remop REMOP factor|
	factor;
    
factor:
	factor MULOP expop | ///factor * expop/expression which can be in parenthesis
	expop ; ///or just expop

expop:
	primary EXPOP expop | ///primary ** expop, right associative
	primary; ///or just primary

primary: ///can be the (expression) OR int lit OR real lit OR bool lit token OR identifier
	'(' expression ')' |
	INT_LITERAL | 
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER ;
    
%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])    
{
	firstLine();
	yyparse();
	lastLine();
	return 0;
} 
