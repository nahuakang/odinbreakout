package breakout

import rl "vendor:raylib"

new_camera :: proc() -> rl.Camera2D {
	return rl.Camera2D{zoom = f32(rl.GetScreenHeight()) / SCREEN_SIZE}
}
