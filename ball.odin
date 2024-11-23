package breakout

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

// BALL
BALL_RADIUS :: 4
BALL_SPEED :: 260
BALL_START_Y :: 160

Ball :: struct {
	position:      rl.Vector2,
	prev_position: rl.Vector2,
	direction:     rl.Vector2,
	radius:        f32,
	speed:         f32,
}

check_border_collision :: proc(ball: ^Ball, game: ^Game) {
	// Check right border collision
	if ball.position.x + ball.radius > SCREEN_SIZE {
		ball.position.x = SCREEN_SIZE - ball.radius
		update_ball_direction_with_norm(ball, rl.Vector2{-1, 0})
	}
	// Check left border collision
	if ball.position.x - ball.radius < 0 {
		ball.position.x = ball.radius
		update_ball_direction_with_norm(ball, rl.Vector2{1, 0})
	}
	// Check top border collision
	if ball.position.y - ball.radius < 0 {
		ball.position.y = ball.radius
		update_ball_direction_with_norm(ball, rl.Vector2{0, 1})
	}
	// Check bottom border
	if ball.position.y > SCREEN_SIZE + ball.radius {
		// TODO: Enable restart
		game^ = restart()
	}
}

check_paddle_collision :: proc(ball: ^Ball, paddle: ^Paddle) {
	paddle_rect := get_rect(paddle)

	if rl.CheckCollisionCircleRec(ball.position, ball.radius, paddle_rect) {
		collision_normal: rl.Vector2

		// Collision with upside of the paddle
		if ball.prev_position.y < paddle_rect.y + paddle_rect.height {
			collision_normal += {0, -1}
			ball.position.y = paddle_rect.y - ball.radius
		}

		// Collision with underside of the paddle
		if ball.prev_position.y > paddle_rect.y + paddle_rect.height {
			collision_normal += {0, 1}
			ball.position.y = paddle_rect.y + paddle_rect.height + ball.radius
		}

		// Collision from the left of the paddle
		if ball.prev_position.x < paddle_rect.x {
			collision_normal += {-1, 0}
		}

		// Collision from the right of the paddle
		if ball.prev_position.x > paddle_rect.x + paddle_rect.width {
			collision_normal += {1, 0}
		}

		if collision_normal != 0 {
			update_ball_direction_with_norm(ball, linalg.normalize(collision_normal))
		}
	}
}

draw_ball :: proc(ball: ^Ball) {
	// fmt.printfln("ball.position: %v", ball.position)
	rl.DrawCircleV(ball.position, ball.radius, BALL_COLOR)
}

update_ball_position :: proc(ball: ^Ball, game: ^Game) {
	ball.prev_position = ball.position

	if game.started {
		ball.position += ball.direction * ball.speed * game.dt
	} else {
		ball.position = {
			SCREEN_SIZE / 2 + f32(math.cos(rl.GetTime())) * (SCREEN_SIZE / 2.5),
			BALL_START_Y,
		}
	}
}

update_ball :: proc(ball: ^Ball, paddle: ^Paddle, game: ^Game) {
	update_ball_position(ball, game)
	check_border_collision(ball, game)
	check_paddle_collision(ball, paddle)
}

update_ball_direction_to_paddle :: proc(ball: ^Ball, paddle: ^Paddle) {
	paddle_middle := rl.Vector2{paddle.position.x + PADDLE_WIDTH / 2, paddle.position.y}
	ball_to_paddle := paddle_middle - ball.position
	ball.direction = linalg.normalize0(ball_to_paddle)
}

update_ball_direction_with_norm :: proc(ball: ^Ball, collision_norm: rl.Vector2) {
	ball.direction = reflect(ball.direction, collision_norm)
}
