package breakout

import rl "vendor:raylib"

Assets :: struct {
	ball:   rl.Texture2D,
	paddle: rl.Texture2D,
}


load_assets :: proc() -> Assets {
	return {ball = rl.LoadTexture("assets/ball.png"), paddle = rl.LoadTexture("assets/paddle.png")}
}
