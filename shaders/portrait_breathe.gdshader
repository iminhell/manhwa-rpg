shader_type canvas_item;
// « Live2D-lite » : respiration et léger balancement d'un portrait fixe (sans rigging).
uniform float breathe_amount = 0.006;
uniform float breathe_speed = 1.6;
uniform float sway_amount = 0.003;

void vertex() {
	float t = TIME * breathe_speed;
	// Les pixels du haut (tête) bougent plus que ceux du bas (buste).
	float weight = 1.0 - UV.y;
	VERTEX.y += sin(t) * breathe_amount * 600.0 * weight;
	VERTEX.x += sin(t * 0.5) * sway_amount * 600.0 * weight;
}
