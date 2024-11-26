package breakout

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

// WINDOW & SCREEN
DELTA_TIME :: 1.0 / 60.0 // 0.016s
FPS_TARGET :: 60
UI_FONT_SIZE :: 15
SCREEN_SIZE :: 320
WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 1280

Game :: struct {
	ball:             Ball,
	paddle:           Paddle,
	blocks:           Blocks,
	accumulated_time: f32,
	dt:               f32,
	game_over:        bool,
	started:          bool,
	score:            int,
}

restart :: proc() -> Game {
	return {
		ball = new_ball(),
		blocks = initialize_blocks(),
		paddle = new_paddle(),
		dt = DELTA_TIME,
	}
}

draw :: proc(game: ^Game, assets: ^Assets) {
	draw_ball(&game.ball, assets)
	draw_paddle(&game.paddle, assets)
	draw_blocks(&game.blocks)
	draw_score_ui(game)

	if !game.started {
		draw_game_start(game)
	}

	if game.game_over {
		draw_game_over(game)
	}
}

update :: proc(game: ^Game, assets: ^Assets) {
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
	game.accumulated_time += rl.GetFrameTime()

	// In each frame, we run updates
	fmt.printfln("game.accumulated_time: %v", game.accumulated_time)
	for game.accumulated_time > game.dt {
		update_ball(&game.ball, &game.paddle, game, assets)
		update_paddle(&game.paddle, game)
		update_blocks(&game.blocks, &game.ball, game, assets)

		game.accumulated_time -= game.dt
	}

	blend := game.accumulated_time / game.dt
	calc_ball_blend_position(&game.ball, blend)
	calc_paddle_blend_position(&game.paddle, blend)
}
