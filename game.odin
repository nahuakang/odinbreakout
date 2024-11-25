package breakout

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

// WINDOW & SCREEN
SCREEN_SIZE :: 320
WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 1280
FPS_TARGET :: 60

Game :: struct {
	ball:    Ball,
	paddle:  Paddle,
	blocks:  Blocks,
	dt:      f32,
	started: bool,
}

restart :: proc() -> Game {
	return {
		started = false,
		ball = new_ball(),
		blocks = initialize_blocks(),
		paddle = new_paddle(),
	}
}

draw :: proc(game: ^Game) {
	draw_ball(&game.ball)
	draw_paddle(&game.paddle)
	draw_blocks(&game.blocks)
}

update :: proc(game: ^Game) {
	game.dt = rl.GetFrameTime()

	if !game.started {
		if rl.IsKeyPressed(.SPACE) {
			update_ball_direction_to_paddle(&game.ball, &game.paddle)
			game.started = true
		}
	}

	update_ball(&game.ball, &game.paddle, game)
	update_paddle(&game.paddle, game)
}
