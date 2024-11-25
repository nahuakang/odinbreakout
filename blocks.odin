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

initialize_blocks :: proc() -> Blocks {
	blocks: Blocks
	for x in 0 ..< BLOCKS_NUM_X {
		for y in 0 ..< BLOCKS_NUM_Y {
			blocks[x][y] = true
		}
	}

	return blocks
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
