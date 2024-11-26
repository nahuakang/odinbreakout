package breakout

import "core:fmt"
import rl "vendor:raylib"

draw_ui :: proc(game: ^Game) {
	// raylib expects a C-String; allocated by temp_allocator
	score_text := fmt.ctprint(game.score)
	rl.DrawText(score_text, 5, 5, 10, rl.WHITE)
}
