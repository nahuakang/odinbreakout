package breakout

import rl "vendor:raylib"

BLOCKS_NUM_X :: 10
BLOCKS_NUM_Y :: 8
BLOCK_WIDTH :: 28
BLOCK_HEIGHT :: 10
PADDING_X :: 20
PADDING_Y :: 40
LINE_THICKNESS :: 1

Blocks :: [BLOCKS_NUM_X][BLOCKS_NUM_Y]bool

Block_Color :: enum {
	Yellow,
	Green,
	Orange,
	Red,
}

row_colors := [BLOCKS_NUM_Y]Block_Color {
	.Red,
	.Red,
	.Orange,
	.Orange,
	.Green,
	.Green,
	.Yellow,
	.Yellow,
}

block_color_values := [Block_Color]rl.Color {
	.Yellow = BLOCK_YELLOW_COLOR,
	.Green  = BLOCK_GREEN_COLOR,
	.Orange = BLOCK_ORANGE_COLOR,
	.Red    = BLOCK_RED_COLOR,
}

block_color_score := [Block_Color]int {
	.Yellow = 2,
	.Green  = 4,
	.Orange = 6,
	.Red    = 8,
}

initialize_blocks :: proc() -> Blocks {
	blocks: Blocks
	for x in 0 ..< BLOCKS_NUM_X {
		for y in 0 ..< BLOCKS_NUM_Y {
			blocks[x][y] = true
		}
	}

	return blocks
}

block_exists :: proc(blocks: ^Blocks, x, y: int) -> bool {
	if x < 0 || y < 0 || x >= BLOCKS_NUM_X || y >= BLOCKS_NUM_Y {
		return false
	}

	return blocks[x][y]
}

calc_block_rect :: proc(x: int, y: int) -> rl.Rectangle {
	return {
		f32(PADDING_X + x * BLOCK_WIDTH),
		f32(PADDING_Y + y * BLOCK_HEIGHT),
		BLOCK_WIDTH,
		BLOCK_HEIGHT,
	}
}

draw_blocks :: proc(blocks: ^Blocks) {
	for x in 0 ..< BLOCKS_NUM_X {
		for y in 0 ..< BLOCKS_NUM_Y {
			if blocks[x][y] == false {
				continue
			}

			block_rect := calc_block_rect(x, y)

			top_left := rl.Vector2{block_rect.x, block_rect.y}
			top_right := rl.Vector2{block_rect.x + block_rect.width, block_rect.y}
			bottom_left := rl.Vector2{block_rect.x, block_rect.y + block_rect.height}
			bottom_right := rl.Vector2 {
				block_rect.x + block_rect.width,
				block_rect.y + block_rect.height,
			}

			rl.DrawRectangleRec(block_rect, block_color_values[row_colors[y]])
			rl.DrawLineEx(top_left, top_right, LINE_THICKNESS, LIGHT_LINE_COLOR)
			rl.DrawLineEx(top_left, bottom_left, LINE_THICKNESS, LIGHT_LINE_COLOR)
			rl.DrawLineEx(top_right, bottom_right, LINE_THICKNESS, DARK_LINE_COLOR)
			rl.DrawLineEx(bottom_left, bottom_right, LINE_THICKNESS, DARK_LINE_COLOR)
		}
	}
}

check_block_collision :: proc(blocks: ^Blocks, ball: ^Ball, game: ^Game) {
	block_x_loop: for x in 0 ..< BLOCKS_NUM_X {
		for y in 0 ..< BLOCKS_NUM_Y {
			if !blocks[x][y] {
				continue
			}

			block_rect := calc_block_rect(x, y)
			if rl.CheckCollisionCircleRec(ball.position, ball.radius, block_rect) {
				collision_normal: rl.Vector2
				// It's important to check for the previous position to ensure
				// that the collision normal calculation is correct
				if ball.prev_position.y < block_rect.y {
					collision_normal += {0, -1}
				}
				if ball.prev_position.y > block_rect.y + block_rect.height {
					collision_normal += {0, 1}
				}
				if ball.prev_position.x < block_rect.x {
					collision_normal += {-1, 0}
				}
				if ball.prev_position.x > block_rect.x + block_rect.width {
					collision_normal += {1, 0}
				}

				if block_exists(blocks, x + int(collision_normal.x), y) {
					collision_normal.x = 0
				}

				if block_exists(blocks, x, y + int(collision_normal.y)) {
					collision_normal.y = 0
				}
				if collision_normal != 0 {
					ball.direction = reflect(ball.direction, collision_normal)
				}

				blocks[x][y] = false
				row_color := row_colors[y]
				game.score += block_color_score[row_color]
				break block_x_loop
			}
		}
	}
}

update_blocks :: proc(blocks: ^Blocks, ball: ^Ball, game: ^Game) {
	check_block_collision(blocks, ball, game)
}
