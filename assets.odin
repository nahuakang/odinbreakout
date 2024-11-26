package breakout

import rl "vendor:raylib"

Assets :: struct {
	ball_texture:     rl.Texture2D,
	paddle_texture:   rl.Texture2D,
	hit_block_sound:  rl.Sound,
	hit_paddle_sound: rl.Sound,
	game_over_sound:  rl.Sound,
}


load_assets :: proc() -> Assets {
	return {
		ball_texture = rl.LoadTexture("assets/graphics/ball.png"),
		paddle_texture = rl.LoadTexture("assets/graphics/paddle.png"),
		hit_block_sound = rl.LoadSound("assets/audio/hit_block.wav"),
		hit_paddle_sound = rl.LoadSound("assets/audio/hit_paddle.wav"),
		game_over_sound = rl.LoadSound("assets/audio/game_over.wav"),
	}
}
