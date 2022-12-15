extends laser_gun

func fire():
	match (firemode): 
		2:
			if can_fire == true and magazines[0]>0 and magazines.size()>0:
				if magazines[0]>3:
					while burst<3:
						dropped_recently = false
						check_collision()
						$gun/l3g4ll/AnimationPlayer.play("trigger_pull")
						remain = battery_l.get_surface_material(0).get_shader_param("sizey")
						battery_l.get_surface_material(0).set_shader_param("sizey", remain - minus)
						batteries[0] = remain - minus
						magazines[0] -=1
						ammo=magazines[0]
						can_fire = false
						yield(get_tree().create_timer(fire_rate), "timeout")
						burst += 1
						if burst == 3:
							burst = 0
							can_fire = true
							break
				else: 
					while magazines[0]>0:
						dropped_recently = false
						check_collision()
						$gun/l3g4ll/AnimationPlayer.play("trigger_pull")
						remain = battery_l.get_surface_material(0).get_shader_param("sizey")
						battery_l.get_surface_material(0).set_shader_param("sizey", remain - minus)
						batteries[0] = remain - minus
						magazines[0] -=1
						ammo=magazines[0]
						can_fire = false
						yield(get_tree().create_timer(fire_rate), "timeout")
						if magazines[0] == 0:
							can_fire = true
							break
			else:
				can_fire = false
		
		_:
			if can_fire == true and magazines.size()>0 and magazines[0]>0:
				dropped_recently = false
				check_collision()
				$gun/l3g4ll/AnimationPlayer.play("trigger_pull")
				#remain = battery_l.material_override.get_shader_param("sizey")
				remain = battery_l.get_surface_material(0).get_shader_param("sizey")
				#battery_l.material_override.set_shader_param("sizey", remain - minus)
				battery_l.get_surface_material(0).set_shader_param("sizey", remain - minus)
				batteries[0] = remain - minus
				magazines[0] = magazines[0] -1
				ammo=magazines[0]
				can_fire = false
				yield(get_tree().create_timer(fire_rate), "timeout")
				can_fire = true
			
			else:
				can_fire = false

func change_fire():
	match (firemode):
		1: 
			match (type_of_gun):
				1.4:
					firemode = 2
					$gun/l3g4ll/AnimationPlayer.play("burst")
				1.9:
					firemode = 3
					$gun/l3g4ll/AnimationPlayer.play("full_auto")
				2.9:
					firemode = 2
					$gun/l3g4ll/AnimationPlayer.play("burst")
					
		2: 
			match (type_of_gun):
				1.4:
					firemode = 1
					$gun/l3g4ll/AnimationPlayer.play("semi_auto001")
				2.5:
					firemode = 3
					$gun/l3g4ll/AnimationPlayer.play("full_auto")
				2.9:
					firemode = 3
					$gun/l3g4ll/AnimationPlayer.play("full_auto")
		3:
			match (type_of_gun):
				1.9:
					firemode = 1
					$gun/l3g4ll/AnimationPlayer.play("semi_auto001")
				2.5:
					firemode = 2
					$gun/l3g4ll/AnimationPlayer.play("burst")
				2.9:
					firemode = 1
					$gun/l3g4ll/AnimationPlayer.play("semi_auto001")
