package interpreter

import "core:fmt"
import "core:strings"


Lexer :: struct {
	input:         string,
	position:      uint,
	read_position: uint,
	ch:            u8,
}

new :: proc(input: string) -> Lexer {
	l: Lexer
	l.input = input
	read_char(&l)
	return l
}

read_char :: proc(l: ^Lexer) {
	if l.read_position >= len(l.input) {
		l.ch = 0
	} else {
		l.ch = l.input[l.read_position]
	}
	l.position = l.read_position
	l.read_position += 1
}

next_token :: proc(l: ^Lexer) -> Token {
	tok: Token

	skip_whitespace(l)

	switch l.ch {
	case '=':
		tok = new_token(.ASSIGN, l.ch)
	case ';':
		tok = new_token(.SEMICOLON, l.ch)
	case 0:
		tok.literal = ""
		tok.type = .EOF
	case:
		if is_letter(l.ch) {
			tok.literal = read_identifier(l)
			tok.type = lookup_ident(tok.literal)
			return tok
		} else if is_digit(l.ch) {
			tok.type = .INT
			tok.literal = read_number(l)
			return tok
		} else {
			tok = new_token(.ILLEGAL, l.ch)
		}
	}
	read_char(l)
	return tok
}

is_digit :: proc(ch: u8) -> bool {
	return '0' <= ch && ch <= '9'
}

read_number :: proc(l: ^Lexer) -> string {
	position := l.position
	for is_digit(l.ch) {
		read_char(l)
	}
	return string(l.input[position:l.position])
}

is_letter :: proc(ch: u8) -> bool {
	return 'a' <= ch && ch <= 'z' || 'A' <= ch && ch <= 'Z' || ch == '_'
}

read_identifier :: proc(l: ^Lexer) -> string {
	position := l.position
	for is_letter(l.ch) {
		read_char(l)
	}
	return string(l.input[position:l.position])
}

new_token :: proc(token_type: TokenType, ch: u8) -> Token {
	buf := [1]u8{ch}
	literal := strings.clone(strings.string_from_ptr(&buf[0], 1))
	return Token{token_type, literal}
}

skip_whitespace :: proc(l: ^Lexer) {
	for l.ch == ' ' || l.ch == '\t' || l.ch == '\n' || l.ch == '\r' {
		read_char(l)
	}
}
