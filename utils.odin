package breakout

import "core:math/linalg"
import rl "vendor:raylib"


reflect :: proc(dir: rl.Vector2, normal: rl.Vector2) -> rl.Vector2 {
	new_direction := linalg.reflect(dir, linalg.normalize(normal))
	return linalg.normalize(new_direction)
}
