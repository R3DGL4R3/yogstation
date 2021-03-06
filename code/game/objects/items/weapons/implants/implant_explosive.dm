/obj/item/weapon/implant/explosive
	name = "microbomb implant"
	desc = "And boom goes the weasel."
	icon_state = "explosive"
	origin_tech = "materials=2;combat=3;biotech=4;syndicate=4"
	actions_types = list(/datum/action/item_action/unrestricted/activate)
	var/weak = 2
	var/medium = 0.8
	var/heavy = 0.4
	var/delay = 7

/obj/item/weapon/implant/explosive/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Robust Corp RX-78 Employee Management Implant<BR>
				<b>Life:</b> Activates upon death.<BR>
				<b>Important Notes:</b> Explodes<BR>
				<HR>
				<b>Implant Details:</b><BR>
				<b>Function:</b> Contains a compact, electrically detonated explosive that detonates upon receiving a specially encoded signal or upon host death.<BR>
				<b>Special Features:</b> Explodes<BR>
				"}
	return dat

/obj/item/weapon/implant/explosive/trigger(emote, mob/source)
	if(emote == "deathgasp")
		activate("death")

/obj/item/weapon/implant/explosive/activate(cause)
	if(!cause || !imp_in)
		return 0
	if(cause == "action_button" && alert(imp_in, "Are you sure you want to activate your [name]? This will cause you to explode!", "[name] Confirmation", "Yes", "No") != "Yes")
		return 0
	heavy = round(heavy)
	medium = round(medium)
	weak = round(weak)
	imp_in << "<span class='notice'>You activate your [name].</span>"
	var/turf/boomturf = get_turf(imp_in)
	var/area/A = get_area(boomturf)
	message_admins("[key_name_admin(imp_in)]<A HREF='?_src_=holder;adminmoreinfo=\ref[imp_in]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[imp_in]'>FLW</A>) has activated their [name] at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[imp_in.x];Y=[imp_in.y];Z=[imp_in.z]'>[A.name] (JMP)</a>.")
//If the delay is short, just blow up already jeez
	if(delay <= 7)
		explosion(src,heavy,medium,weak,weak, flame_range = weak)
		if(imp_in)
			imp_in.gib(1)
		qdel(src)
		return
	timed_explosion()

/obj/item/weapon/implant/explosive/implant(mob/source)
	var/obj/item/weapon/implant/explosive/imp_e = locate(src.type) in source
	if(imp_e && imp_e != src)
		imp_e.heavy += heavy
		imp_e.medium += medium
		imp_e.weak += weak
		imp_e.delay += delay
		qdel(src)
		return 1

	return ..()

/obj/item/weapon/implant/explosive/proc/timed_explosion()
	imp_in.visible_message("<span class = 'warning'>[imp_in] starts beeping ominously!</span>")
	playsound(loc, 'sound/items/timer.ogg', 30, 0)
	sleep(delay/4)
	if(imp_in && !imp_in.stat)
		imp_in.visible_message("<span class = 'warning'>[imp_in] doubles over in pain!</span>")
		imp_in.Weaken(7)
	playsound(loc, 'sound/items/timer.ogg', 30, 0)
	sleep(delay/4)
	playsound(loc, 'sound/items/timer.ogg', 30, 0)
	sleep(delay/4)
	playsound(loc, 'sound/items/timer.ogg', 30, 0)
	sleep(delay/4)
	explosion(src,heavy,medium,weak,weak, flame_range = weak)
	if(imp_in)
		imp_in.gib(1)
	qdel(src)

/obj/item/weapon/implant/explosive/macro
	name = "macrobomb implant"
	desc = "And boom goes the weasel. And everything else nearby."
	icon_state = "explosive"
	origin_tech = "materials=3;combat=5;biotech=4;syndicate=5"
	weak = 16
	medium = 8
	heavy = 4
	delay = 70

/obj/item/weapon/implant/explosive/macro/implant(mob/source)
	var/obj/item/weapon/implant/explosive/imp_e = locate(src.type) in source
	if(imp_e && imp_e != src)
		return 0
	imp_e = locate(/obj/item/weapon/implant/explosive) in source
	if(imp_e && imp_e != src)
		heavy += imp_e.heavy
		medium += imp_e.medium
		weak += imp_e.weak
		delay += imp_e.delay
		qdel(imp_e)

	return ..()


/obj/item/weapon/implanter/explosive
	name = "implanter (explosive)"

/obj/item/weapon/implanter/explosive/New()
	imp = new /obj/item/weapon/implant/explosive(src)
	..()


/obj/item/weapon/implantcase/explosive
	name = "implant case - 'Explosive'"
	desc = "A glass case containing an explosive implant."

/obj/item/weapon/implantcase/explosive/New()
	imp = new /obj/item/weapon/implant/explosive(src)
	..()