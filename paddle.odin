package breakout

import "core:fmt"
import rl "vendor:raylib"

// PADDLE
PADDLE_WIDTH :: 50
PADDLE_HEIGHT :: 6
PADDLE_POS_Y :: 260
PADDLE_SPEED :: 200

Paddle :: struct {
	position: rl.Vector2,
}

new_paddle :: proc() -> Paddle {
	return {position = {SCREEN_SIZE / 2 - PADDLE_WIDTH / 2, PADDLE_POS_Y}}
}

get_rect :: proc(paddle: ^Paddle) -> rl.Rectangle {
	return {paddle.position.x, paddle.position.y, PADDLE_WIDTH, PADDLE_HEIGHT}
}

draw_paddle :: proc(paddle: ^Paddle, assets: ^Assets) {
	rl.DrawTextureV(assets.paddle_texture, paddle.position, rl.WHITE)
}

update_paddle_position :: proc(paddle: ^Paddle, game: ^Game) {
	paddle_move_velocity: f32
	if rl.IsKeyDown(.LEFT) {
		paddle_move_velocity = -PADDLE_SPEED
	}
	if rl.IsKeyDown(.RIGHT) {
		paddle_move_velocity = PADDLE_SPEED
	}

	if game.started {
		paddle.position.x += paddle_move_velocity * game.dt
	} else {
		paddle.position.x += paddle_move_velocity * rl.GetFrameTime()
	}

	paddle.position.x = clamp(paddle.position.x, 0, SCREEN_SIZE - PADDLE_WIDTH)
}

update_paddle :: proc(paddle: ^Paddle, game: ^Game) {
	update_paddle_position(paddle, game)
}
