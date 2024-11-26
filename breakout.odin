package breakout

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

main :: proc() {
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Breakout!")
	rl.InitAudioDevice()
	rl.SetTargetFPS(FPS_TARGET)

	assets := load_assets()
	game := restart()

	for !rl.WindowShouldClose() {
		update(&game, &assets)
		camera := new_camera()

		rl.BeginDrawing()
		rl.ClearBackground(BACKGROUND_COLOR)
		rl.BeginMode2D(camera)

		draw(&game, &assets)

		rl.EndMode2D()
		rl.EndDrawing()

		free_all(context.temp_allocator)
	}

	rl.CloseAudioDevice()
	rl.CloseWindow()
}
