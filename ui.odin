package breakout

import "core:fmt"
import rl "vendor:raylib"

SCORE_FONT_SIZE :: 10

draw_score_ui :: proc(game: ^Game) {
	// raylib expects a C-String; allocated by temp_allocator
	score_text := fmt.ctprint(game.score)
	rl.DrawText(score_text, 5, 5, SCORE_FONT_SIZE, rl.WHITE)
}

draw_game_start :: proc(game: ^Game) {
	game_start_text := fmt.ctprint("Start by pressing SPACE")
	game_start_text_width := rl.MeasureText(game_start_text, UI_FONT_SIZE)
	rl.DrawText(
		game_start_text,
		SCREEN_SIZE / 2 - game_start_text_width / 2,
		BALL_START_Y - 30,
		UI_FONT_SIZE,
		rl.WHITE,
	)
}

draw_game_over :: proc(game: ^Game) {
	game_over_text := fmt.ctprintf("Score: %v. Restart by pressing SPACE", game.score)
	game_over_text_width := rl.MeasureText(game_over_text, UI_FONT_SIZE)
	rl.DrawText(
		game_over_text,
		SCREEN_SIZE / 2 - game_over_text_width / 2,
		BALL_START_Y - 30,
		UI_FONT_SIZE,
		rl.WHITE,
	)
}
