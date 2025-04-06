#+feature dynamic-literals
package interpreter

Token :: struct {
	type:    TokenType,
	literal: string,
}

TokenType :: enum {
	ILLEGAL,
	EOF,

	// Identifiers + literals
	IDENT,
	INT,

	// Operators
	ASSIGN,
	PLUS,

	// Delimiters
	COMMA,
	SEMICOLON,
	LPAREN,
	RPAREN,
	LBRACE,
	RBRACE,

	// Keywords
	FUNCTION,
	LET,
}

keywords := map[string]TokenType {
	"fn"  = .FUNCTION,
	"let" = .LET,
}
// defer delete(keywords)

lookup_ident :: proc(ident: string) -> TokenType {
	type, ok := &keywords[ident]
	if ok {
		return type^
	}
	return .IDENT
}
