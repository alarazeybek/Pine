%token INT_TYPE CONSTANT_INTEGER INPUT WHILE_LOOP FOR_LOOP FUNCTION IF ELSE_IF ELSE
%token ASSIGN_OP EQU_OP INEQU_OP GREATER_EX SMALLER_EX ADD_OP SUB_OP MULT_OP DIV_OP MOD_OP EXP_OP
%token LEFT_PAREN RIGHT_PAREN LEFT_BRA RIGHT_BRA LEFT_SQBRA RIGHT_SQBRA SC NL QUO
%token IDENTIFIER INTEGER STRING OUTPUT COMMA EXC_MARK OR_OP AND_OP TRUE FALSE
%token ML_COMMENT COMMENT RETURN

%start program

%%

program:  function_declarations
        | comment_statement
        ;

function_declarations
        : empty_statement
        | function_declaration
        | function_declaration function_declarations;

function_declaration
    : function_declarator block
    | function_declarator SC
    ;

block
    : LEFT_BRA RIGHT_BRA
    | LEFT_BRA block_statements RIGHT_BRA
    ;

block_statements
    :
    statements
    ;

function_declarator
    : FUNCTION IDENTIFIER LEFT_PAREN parameter_list RIGHT_PAREN
    | FUNCTION IDENTIFIER LEFT_PAREN RIGHT_PAREN
    ;

statements
    : empty_statement
    | statement
| statement statements;

statement
    : expression SC
    | conditional_statement
    | input_statement SC
    | output_statement SC
    | wloop_statement
    | roll_statement
    | return_statement SC
    | comment_statement;

expression
    : array_initialization
    | array_declaration
    | variable_declaration
    | assignment
    | wo_assignment_expression
    | array_index_assign
    | array_index_access
    | constant_declaration
    ;

wo_assignment_expression
    : logical_expression
    | function_invocation
    ;

math_expression
    :
     math_expression ADD_OP term
    | math_expression SUB_OP term
    | term;

term
    :
   term MULT_OP factor
    | term DIV_OP factor
    |factor;

factor
    : factor EXP_OP base
    | factor MOD_OP base
    | base
    ;

base
    : INTEGER
    | IDENTIFIER
    | wo_assignment_expression
    | LEFT_PAREN math_expression RIGHT_PAREN
    | array_index_access
    ;

conditional_statement
    : if_statement
    | else_statement
    | else_if_statements
    ;

else_statement
    : if_statement ELSE block
    | else_if_statements ELSE block
    ;

else_if_statements
    : if_statement else_if_statement
    |else_if_statements else_if_statement
    ;

else_if_statement
    : ELSE_IF LEFT_PAREN logical_expression RIGHT_PAREN block
    ;

if_statement
    : IF LEFT_PAREN logical_expression RIGHT_PAREN block
    ;


wloop_statement
    : WHILE_LOOP LEFT_PAREN logical_expression RIGHT_PAREN block
    ;

roll_statement
    : FOR_LOOP LEFT_PAREN roll_init SC logical_expression SC assignment RIGHT_PAREN block
    ;

roll_init
    : variable_declaration
    | assignment
    ;

input_statement
    : INPUT LEFT_PAREN RIGHT_PAREN
    ;

output_statement
    :  OUTPUT LEFT_PAREN STRING RIGHT_PAREN
    |  OUTPUT LEFT_PAREN INTEGER RIGHT_PAREN
    |  OUTPUT LEFT_PAREN IDENTIFIER RIGHT_PAREN
    | OUTPUT LEFT_PAREN wo_assignment_expression RIGHT_PAREN
    | OUTPUT LEFT_PAREN array_index_access RIGHT_PAREN;

empty_statement
    : SC
    ;

return_statement
    : RETURN math_expression
    | RETURN
    ;

constant_declaration
    : CONSTANT_INTEGER INT_TYPE variable_declarator
    ;

assignment
    :
    IDENTIFIER ASSIGN_OP math_expression
    | IDENTIFIER ASSIGN_OP input_statement;

variable_declaration
    : INT_TYPE variable_declarators
    ;

variable_declarators
    : variable_declarator
    ;

variable_declarator
    : IDENTIFIER
    | assignment
    ;

array_declaration
    : array_dec_one
    | array_dec_multi
    ;

array_dec_one
    : INT_TYPE IDENTIFIER array_dimension_one
    ;

array_dec_multi
    : INT_TYPE IDENTIFIER array_dimension_multi
    ;

array_dimension_one
    : LEFT_SQBRA INTEGER RIGHT_SQBRA
    ;

array_dimension_multi
    : array_dimension_one array_dimension_one
    | array_dimension_multi array_dimension_one
    ;

array_initialization
    : array_init_one
    | array_init_multi
    ;

array_init_one
    : array_dec_one ASSIGN_OP array_dimension_init_one
    | IDENTIFIER ASSIGN_OP array_dimension_init_one
    ;

array_init_multi
    : array_dec_multi ASSIGN_OP array_dimension_init_multi
    | IDENTIFIER ASSIGN_OP array_dimension_init_multi
    ;

array_dimension_init_one
    : LEFT_BRA int_list RIGHT_BRA
    ;

array_dimension_init_multi
    : LEFT_BRA array_dim_init_multi_element RIGHT_BRA
    ;

array_dim_init_multi_element
    : array_dimension_init_one COMMA array_dimension_init_one
    | array_dim_init_multi_element COMMA array_dimension_init_one
    ;

int_list
    : INTEGER
    | boolean
    | boolean COMMA int_list
    | INTEGER COMMA int_list
    ;

array_index_access
    : IDENTIFIER array_index_access_one_element
    | IDENTIFIER array_index_access_multi_element
    ;

array_index_access_multi_element
    : array_index_access_one_element array_index_access_one_element
    | array_index_access_multi_element array_index_access_one_element
    ;

array_index_access_one_element
    : LEFT_SQBRA boolean RIGHT_SQBRA
    |  LEFT_SQBRA INTEGER RIGHT_SQBRA
    | LEFT_SQBRA IDENTIFIER RIGHT_SQBRA
    ;

array_index_assign
    :
     array_index_access ASSIGN_OP math_expression
     | array_index_access ASSIGN_OP input_statement
    ;

logical_expression
    : logical_block
        | EXC_MARK logical_expression
    ;

logical_block
    : logical_term
    | logical_block OR_OP logical_term
    ;

logical_term
    : logical_factor
    | logical_term AND_OP logical_factor
    ;

logical_factor
    : equality_comparison_expression
    | boolean
    ;

equality_comparison_expression
    : value EQU_OP value
    | value INEQU_OP value
    | smaller_than
    | greater_than
    ;

smaller_than
        : value SMALLER_EX value
        | value SMALLER_EX EQU_OP value
        ;

greater_than
        : value GREATER_EX value
        | value GREATER_EX EQU_OP value
        ;

parameter_list
    : parameter_list COMMA parameter
    | parameter
    ;

parameter
    : IDENTIFIER
    | INTEGER
    ;

function_invocation
    : IDENTIFIER LEFT_PAREN argument_list RIGHT_PAREN
    | IDENTIFIER LEFT_PAREN RIGHT_PAREN
    ;

argument_list
    : value
    | argument_list COMMA value
    ;

comment_statement
    : single_line_comment
    | multiline_comment
    ;

single_line_comment
    : COMMENT
    ;

multiline_comment
    : ML_COMMENT
    ;

value
    : IDENTIFIER
    | INTEGER
    | literal
    | array_index_access
    ;

literal
    : boolean
    ;

boolean
    : TRUE
    | FALSE
    ;

/* ... More rules will be added here for loops, expressions, etc. ... */

/* Error rule for syntax errors */

%%
#include <stdio.h>
#include "y.tab.h"
/* C code to invoke the parser, define yyerror, etc. will go here. */
int yylex(void);
int lineno = 0;
int yydebug = 1;

int main(){
        if (yyparse() == 0) {
                printf("Input program is valid\n");
        }
        return 0;
}

void yyerror(char *s) {
    printf( "%s on line %d\n", s, lineno);
}