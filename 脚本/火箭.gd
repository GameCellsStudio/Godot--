extends RigidBody3D

@onready var 坠毁音效: AudioStreamPlayer = $"坠毁音效"
@onready var 成功音效: AudioStreamPlayer = $"成功音效"
@onready var 火箭推动音效: AudioStreamPlayer = $"火箭推动音效"
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


##移动时施加的垂直力大小
@export_range(750.0,2500.0) var 推力 := 1000.0
##控制左右旋转的速度
@export var 扭力 := 100.0

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("起飞"):
		apply_central_force(basis.y * delta * 推力)
		if not 火箭推动音效.playing:
			火箭推动音效.play()
		if not booster_particles.emitting:
			booster_particles.emitting = true
	elif 火箭推动音效.playing:
		火箭推动音效.stop()
	else :
		booster_particles.emitting = false
	
	if Input.is_action_pressed("左旋转"):
		apply_torque(Vector3.BACK * 扭力 * delta)
	if Input.is_action_pressed("右旋转"):
		apply_torque(-Vector3.BACK * 扭力 * delta)


func _on_body_entered(body: Node) -> void:
	if "着陆台" in body.get_groups():
		完成关卡(body.下一关场景路径)
	if "障碍物" in body.get_groups():
		坠毁()

func 坠毁() -> void:
	if not 坠毁音效.playing:
		坠毁音效.play()
	if 火箭推动音效.playing:
		火箭推动音效.stop()
	if not explosion_particles.emitting:
		explosion_particles.emitting = true
	
	set_process(false)
	print("KBOOM~火箭坠毁了！")
	call_deferred("set_contact_monitor",false)
	await get_tree().create_timer(1.5).timeout
	call_deferred("延迟重载关卡")
	

func 完成关卡(下一关场景文件:String) -> void:
	print("叮当！恭喜你已成功着陆！")
	if not 成功音效.playing:
		成功音效.play()
	if 火箭推动音效.playing:
		火箭推动音效.stop()
	if not success_particles.emitting:
		success_particles.emitting = true
	
	set_process(false)
	call_deferred("set_contact_monitor",false)
	await get_tree().create_timer(1.5).timeout
	call_deferred("延迟加载关卡",下一关场景文件)
	
	
func 延迟重载关卡() -> void:
	get_tree().reload_current_scene()

func 延迟加载关卡(下一关场景文件) -> void:
	get_tree().change_scene_to_file(下一关场景文件)
