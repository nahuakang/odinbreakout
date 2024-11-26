package breakout

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

// WINDOW & SCREEN
UI_FONT_SIZE :: 15
SCREEN_SIZE :: 320
WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 1280
FPS_TARGET :: 60

Game :: struct {
	ball:      Ball,
	paddle:    Paddle,
	blocks:    Blocks,
	dt:        f32,
	game_over: bool,
	started:   bool,
	score:     int,
}

restart :: proc() -> Game {
	return {ball = new_ball(), blocks = initialize_blocks(), paddle = new_paddle()}
}

draw :: proc(game: ^Game) {
	draw_ball(&game.ball)
	draw_paddle(&game.paddle)
	draw_blocks(&game.blocks)
	draw_score_ui(game)

	if !game.started {
		draw_game_start(game)
	}

	if game.game_over {
		draw_game_over(game)
	}
}

update :: proc(game: ^Game) {
	game.dt = rl.GetFrameTime()

	if !game.started {
		if rl.IsKeyPressed(.SPACE) {
			update_ball_direction_to_paddle(&game.ball, &game.paddle)
			game.started = true
		}
	} else if game.game_over {
		if rl.IsKeyPressed(.SPACE) {
			game^ = restart()
		}
	}

	update_ball(&game.ball, &game.paddle, game)
	update_paddle(&game.paddle, game)
	update_blocks(&game.blocks, &game.ball, game)
}
