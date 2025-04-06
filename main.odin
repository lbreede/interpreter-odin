package interpreter

import "core:fmt"

main :: proc() {
	lexer := new("let foo = 42;")

	token := next_token(&lexer)
	fmt.println(token)
	for token.type != .EOF {
		token = next_token(&lexer)
		fmt.println(token)
	}
}
