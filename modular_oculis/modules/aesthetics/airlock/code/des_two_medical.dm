/obj/machinery/door/airlock/des_two_medical
	name = "infirmary airlock"
	icon = 'modular_oculis/modules/aesthetics/airlock/icons/airlocks/des_two/des_two_medical.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_red_med

/obj/machinery/door/airlock/des_two_medical/glass
	name = "infirmary glass airlock"
	opacity = FALSE
	glass = TRUE

/obj/structure/door_assembly/door_assembly_red_med
	name = "infirmary airlock assembly"
	icon = 'icons/obj/doors/airlocks/station/medical.dmi'
	base_name = "medical airlock"
	glass_type = /obj/machinery/door/airlock/des_two_medical/glass
	airlock_type = /obj/machinery/door/airlock/des_two_medical
