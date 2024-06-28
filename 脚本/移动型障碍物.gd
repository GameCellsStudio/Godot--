extends AnimatableBody3D

@export var 目的地坐标: Vector3
@export var 持续时间: float = 1.0

func _ready() -> void:
	var tween = create_tween()
	#设置循环次数 0或留空表示无限循环
	tween.set_loops()
	#为此 Tween 设置动画化的过渡类型。如果未指定，则默认值为 TRANS_LINEAR 线性插值。
	tween.set_trans(Tween.TRANS_SINE) #设置为正弦函数插值
	tween.tween_property(self,"global_position",global_position + 目的地坐标,持续时间)
	tween.tween_property(self,"global_position",global_position,持续时间)
