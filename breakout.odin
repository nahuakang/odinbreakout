package breakout

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Breakout!")
	rl.SetTargetFPS(FPS_TARGET)

	game := restart()

	for !rl.WindowShouldClose() {
		update(&game)
		camera := rl.Camera2D {
			zoom = f32(rl.GetScreenHeight()) / SCREEN_SIZE,
		}

		rl.BeginDrawing()
		rl.ClearBackground(BACKGROUND_COLOR)
		rl.BeginMode2D(camera)

		draw(&game)

		rl.EndMode2D()
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
