/obj/item/weapon/storage/backpack/flammenwerfer
	name = "flammenwerfer backpack"
	desc = "You wear this on your back and then blast people with fire."
	icon_state = "fw_back"
	item_state_slots = null
	var/obj/item/weapon/flamethrower/flammenwerfer/flamethrower = null // thrower is taken by movable atoms!
	var/obj/item/weapon/tank/plasma/ptank = null
	nodrop = 0

/obj/item/weapon/storage/backpack/flammenwerfer/examine(var/mob/user)
	var/show = desc
	if (flamethrower && flamethrower.loc == src)
		show += " There is a flamethrower inside."
	user << "<span class = 'notice'>[show]</span>"

/obj/item/weapon/storage/backpack/flammenwerfer/New()
	..()

	flamethrower = new()
	ptank = new/obj/item/weapon/tank/plasma/super()
	flamethrower.ptank = ptank
	flamethrower.pressure_1 = ptank.air_contents.return_pressure()

/obj/item/weapon/storage/backpack/flammenwerfer/open()
	return

/obj/item/weapon/storage/backpack/flammenwerfer/equipped(var/mob/user, var/slot)
	..()

	if (src == user.back)

		if (!user.put_in_any_hand_if_possible(flamethrower) && !(user.l_hand == flamethrower) && !(user.r_hand == flamethrower))

			user.u_equip(src)
			user << "<span class = 'danger'>You don't have space to hold the flammenwerfer in your hands.</span>"


/obj/item/weapon/storage/backpack/flammenwerfer/MouseDrop(obj/over_object as obj)
	if (!nodrop) // if the flamethrower is in the bag, we can move it
		return ..(over_object)


/obj/item/weapon/storage/backpack/flammenwerfer/attackby(obj/item/W as obj, mob/user as mob)
	nodrop = 1

	if (istype(W, /obj/item/weapon/flamethrower/flammenwerfer))
		..(W, user)

	if (istype(W, /obj/item/weapon/flammenwerfer_fueltank))
		visible_message("<span class = 'notice'>[user] puts the flammenwerfer fuel tank in the flammenwerfer.</span>")
		qdel(W)
		flamethrower.ptank = new ptank.type
		flamethrower.pressure_1 = ptank.air_contents.return_pressure()

	for (var/atom/a in contents)
		if (istype(a, /obj/item/weapon/flamethrower/flammenwerfer))
			nodrop = 0
			break

/obj/item/weapon/storage/backpack/flammenwerfer/attack_hand(mob/user as mob)
	if (loc == user)
		if (contents.Find(flamethrower))
			if (user.get_active_hand() == null)
				user.put_in_any_hand_if_possible(flamethrower)
				user << "<span class = 'notice'>You take the flamethrower from [src].</span>"
	else
		..(user)



/*
/obj/item/weapon/storage/backpack/flammenwerfer/dropped(var/mob/user)
	..()

	if (user.get_active_hand() == flamethrower || user.get_inactive_hand() == flamethrower)
		user.u_equip(flamethrower)
		flamethrower.loc = null

	var/mob/m = flamethrower.loc

	if (m && istype(m))
		if (m.get_active_hand() == flamethrower || m.get_inactive_hand() == flamethrower)
			m.u_equip(flamethrower)
			flamethrower.loc = null*/


/obj/item/weapon/storage/backpack/flammenwerfer/proc/explode()
	if (istype(loc, /mob))
		var/mob/m = loc
		m.visible_message("<span class = 'danger'>[m]'s flammenwerfer explodes!</span>", "<span class = 'danger'><font size = 3>Your flammenwerfer explodes!</font></span>")
		explosion(get_turf(m), 0, 2, 3, 4)

		for (var/mob/mm in range(1, get_turf(m)))
			var/turf/t = get_turf(mm)
			t.hotspot_expose((ptank.air_contents.temperature*2) + 380,500)

		if (m.get_active_hand() == flamethrower || m.get_inactive_hand() == flamethrower)
			m.u_equip(flamethrower)
			flamethrower.loc = null

		qdel(src)



