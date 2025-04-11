/obj/structure/vampdoor
	name = "\improper door"
	desc = "It opens and closes."
	icon = 'code/modules/wod13/doors.dmi'
	icon_state = "door-1"
	plane = GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER
	pixel_w = -16
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

	var/baseicon = "door"

	var/closed = TRUE
	var/locked = FALSE
	var/lock_id = null
	var/glass = FALSE
	var/hacking = FALSE
	var/lockpick_timer = 17 //[Lucifernix] - Never have the lockpick timer lower than 7. At 7 it will unlock instantly!!
	var/lockpick_difficulty = 2

	var/open_sound = 'code/modules/wod13/sounds/door_open.ogg'
	var/close_sound = 'code/modules/wod13/sounds/door_close.ogg'
	var/lock_sound = 'code/modules/wod13/sounds/door_locked.ogg'
	var/burnable = FALSE
	/// Whether to grant an apartment_key
	var/grant_apartment_key = FALSE
	var/apartment_key_amount = 1
	/// The type of a key the resident will get
	var/apartment_key_type

/obj/structure/vampdoor/proc/try_award_apartment_key(mob/user)
	if(!grant_apartment_key)
		return FALSE
	if(!lock_id)
		return FALSE
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/human = user
	if(human.received_apartment_key)
		return FALSE
	var/alert = tgui_alert(user, "Is this my apartment?", "Apartment", list("Yes", "No"))
	if(alert != "Yes")
		return
	if(!grant_apartment_key)
		return
	var/spare_key = tgui_alert(user, "Do I have an extra spare key?", "Apartment", list("Yes", "No"))
	if(!grant_apartment_key)
		return
	if(spare_key == "Yes")
		apartment_key_amount = 2
	else
		apartment_key_amount = 1
	for(var/i in 1 to apartment_key_amount)
		var/obj/item/vamp/keys/key
		if(apartment_key_type)
			key = new apartment_key_type(get_turf(human))
		else
			key = new /obj/item/vamp/keys(get_turf(human))
		key.accesslocks = list("[lock_id]")
		human.put_in_hands(key)
	human.received_apartment_key = TRUE
	grant_apartment_key = FALSE
	if(apartment_key_amount > 1)
		to_chat(human, span_notice("They're just where I left them..."))
	else
		to_chat(human, span_notice("It's just where I left it..."))
	return TRUE

/obj/structure/vampdoor/New()
	..()
	switch(lockpick_difficulty) //This is fine because any overlap gets intercepted before
		if(LOCKDIFFICULTY_7 to INFINITY)
			lockpick_timer = LOCKTIMER_7
		if(LOCKDIFFICULTY_6 to LOCKDIFFICULTY_7)
			lockpick_timer = LOCKTIMER_6
		if(LOCKDIFFICULTY_5 to LOCKDIFFICULTY_6)
			lockpick_timer = LOCKTIMER_5
		if(LOCKDIFFICULTY_4 to LOCKDIFFICULTY_5)
			lockpick_timer = LOCKTIMER_4
		if(LOCKDIFFICULTY_3 to LOCKDIFFICULTY_4)
			lockpick_timer = LOCKTIMER_3
		if(LOCKDIFFICULTY_2 to LOCKDIFFICULTY_3)
			lockpick_timer = LOCKTIMER_2
		if(-INFINITY to LOCKDIFFICULTY_2) //LOCKDIFFICULTY_1 is basically the minimum so we can just do LOCKTIMER_1 from -INFINITY
			lockpick_timer = LOCKTIMER_1

/obj/structure/vampdoor/examine(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.is_holding_item_of_type(/obj/item/vamp/keys/hack))
		return
	var/message //So the code isn't flooded with . +=, it's just a visual thing
	var/difference = (H.lockpicking * 2 + H.dexterity) - lockpick_difficulty //Lower number = higher difficulty
	switch(difference) //Because rand(1,20) always adds a minimum of 1 we take that into consideration for our theoretical roll ranges, which really makes it a random range of 19.
		if(-INFINITY to -11) //Roll can never go above 10 (-11 + 20 = 9), impossible to lockpick.
			message = "<span class='warning'>You don't have any chance of lockpicking this with your current skills!</span>"
		if(-10 to -7)
			message = "<span class='warning'>This door looks extremely complicated. You figure you will have to be lucky to break it open."
		if(-6 to -3)
			message = "<span class='notice'>This door looks very complicated. You might need a few tries to lockpick it.</span>"
		if(-2 to 0) //Only 3 numbers here instead of 4.
			message = "<span class='notice'>This door looks mildly complicated. It shouldn't be too hard to lockpick it.</span>"
		if(1 to 4) //Impossible to break the lockpick from here on because minimum rand(1,20) will always move the value to 2.
			message = "<span class='nicegreen'>This door is somewhat simple. It should be pretty easy for you to lockpick it.</span>"
		if(5 to INFINITY) //Becomes guaranteed to lockpick at 9.
			message = "<span class='nicegreen'>This door is really simple to you. It should be very easy to lockpick it.</span>"
	. += "[message]"
	if(H.lockpicking >= 5) //The difference between a 1/19 and a 4/19 is about 4x. An expert in lockpicks is more discerning.
		//Converting the difference into a number that can be divided by the max value of the rand() used in lockpicking calculations.
		var/max_rand_value = 20
		var/minimum_lockpickable_difference = -10 //Minimum value, any lower and lockpicking will always fail.
		//Add those together then reduce by 1
		var/number_difference = max_rand_value + minimum_lockpickable_difference - 1
		//max_rand_value and number_difference will output 11 currently.
		var/value = difference + max_rand_value - number_difference
		//I'm sure there has to be a better method for this because it's ugly, but it works.
		//Putting a condition here to avoid dividing 0.
		var/odds = value ? clamp((value/max_rand_value), 0, 1) : 0
		. += "<span class='notice'>As an expert in lockpicking, you estimate that you have a [round(odds*100, 1)]% chance to lockpick this door successfully.</span>"

/obj/structure/vampdoor/MouseDrop_T(atom/dropping, mob/user, params)
	. = ..()

	LoadComponent(/datum/component/leanable, dropping)

/obj/structure/vampdoor/attack_hand(mob/user)
	. = ..()
	var/mob/living/N = user
	if(try_award_apartment_key(user))
		return
	if(locked)
		if(N.a_intent != INTENT_HARM)
			playsound(src, lock_sound, 75, TRUE)
			to_chat(user, "<span class='warning'>[src] is locked!</span>")
		else
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(H.potential > 0)
					if((H.potential * 2) >= lockpick_difficulty)
						playsound(get_turf(src), 'code/modules/wod13/sounds/get_bent.ogg', 100, FALSE)
						var/obj/item/shield/door/D = new(get_turf(src))
						D.icon_state = baseicon
						var/atom/throw_target = get_edge_target_turf(src, user.dir)
						D.throw_at(throw_target, rand(2, 4), 4, user)
						qdel(src)
					else
						pixel_z = pixel_z+rand(-1, 1)
						pixel_w = pixel_w+rand(-1, 1)
						playsound(get_turf(src), 'code/modules/wod13/sounds/get_bent.ogg', 50, TRUE)
						to_chat(user, "<span class='warning'>[src] is locked, and you aren't strong enough to break it down!</span>")
						spawn(2)
							pixel_z = initial(pixel_z)
							pixel_w = initial(pixel_w)
				else
					pixel_z = pixel_z+rand(-1, 1)
					pixel_w = pixel_w+rand(-1, 1)
					playsound(src, 'code/modules/wod13/sounds/knock.ogg', 75, TRUE)
					to_chat(user, "<span class='warning'>[src] is locked!</span>")
					spawn(2)
						pixel_z = initial(pixel_z)
						pixel_w = initial(pixel_w)
		return

	if(closed)
		playsound(src, open_sound, 75, TRUE)
		icon_state = "[baseicon]-0"
		set_density(FALSE)
		opacity = FALSE
		layer = OPEN_DOOR_LAYER
		to_chat(user, "<span class='notice'>You open [src].</span>")
		SEND_SIGNAL(src, COMSIG_AIRLOCK_OPEN)
		closed = FALSE
	else
		for(var/mob/living/L in src.loc)
			if(L)
				playsound(src, lock_sound, 75, TRUE)
				to_chat(user, "<span class='warning'>[L] is preventing you from closing [src].</span>")
				return
		playsound(src, close_sound, 75, TRUE)
		icon_state = "[baseicon]-1"
		set_density(TRUE)
		if(!glass)
			opacity = TRUE
		layer = ABOVE_ALL_MOB_LAYER
		to_chat(user, "<span class='notice'>You close [src].</span>")
		closed = TRUE

/obj/structure/vampdoor/attackby(obj/item/W, mob/living/user, params)
	if(istype(W, /obj/item/vamp/keys/hack))
		if(locked)
			hacking = TRUE
			playsound(src, 'code/modules/wod13/sounds/hack.ogg', 100, TRUE)
			for(var/mob/living/carbon/human/npc/police/P in oviewers(7, src))
				if(P)
					P.Aggro(user)
			var/total_lockpicking = user.get_total_lockpicking()
			if(do_mob(user, src, (lockpick_timer - total_lockpicking * 2) SECONDS))
				var/roll = rand(1, 20) + (total_lockpicking * 2 + user.get_total_dexterity()) - lockpick_difficulty
				if(roll <=1)
					to_chat(user, "<span class='warning'>Your lockpick broke!</span>")
					qdel(W)
					hacking = FALSE
				if(roll >=10)
					to_chat(user, "<span class='notice'>You pick the lock.</span>")
					locked = FALSE
					hacking = FALSE
					return

				else
					to_chat(user, "<span class='warning'>You failed to pick the lock.</span>")
					hacking = FALSE
					return
			else
				to_chat(user, "<span class='warning'>You failed to pick the lock.</span>")
				hacking = FALSE
				return
		else
			if (closed && lock_id) //yes, this is a thing you can extremely easily do in real life... FOR DOORS WITH LOCKS!
				to_chat(user, "<span class='notice'>You re-lock the door with your lockpick.</span>")
				locked = TRUE
				playsound(src, 'code/modules/wod13/sounds/hack.ogg', 100, TRUE)
				return
	else if(istype(W, /obj/item/vamp/keys))
		var/obj/item/vamp/keys/KEY = W
		if(KEY.roundstart_fix)
			lock_id = pick(KEY.accesslocks)
			KEY.roundstart_fix = FALSE
		if(KEY.accesslocks)
			for(var/i in KEY.accesslocks)
				if(i == lock_id)
					if(!locked)
						playsound(src, lock_sound, 75, TRUE)
						to_chat(user, "[src] is now locked.")
						locked = TRUE
					else
						playsound(src, lock_sound, 75, TRUE)
						to_chat(user, "[src] is now unlocked.")
						locked = FALSE

/obj/structure/vampdoor/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(!modifiers["right"])
		return ..()

	if(!ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE))
		return

	var/mob/living/carbon/human/H = usr
	var/obj/item/vamp/keys/found_key = locate(/obj/item/vamp/keys) in H.contents
	if(!found_key)
		to_chat(usr, span_warning("You need a key to lock/unlock this door!"))
		return

	if(found_key.roundstart_fix)
		found_key.roundstart_fix = FALSE
		lock_id = pick(found_key.accesslocks)

	if(!found_key.accesslocks)
		to_chat(usr, span_warning("Your key doesn't fit this lock!"))
		return

	for(var/i in found_key.accesslocks)
		if(i == lock_id)
			locked = !locked
			playsound(src, lock_sound, 75, TRUE)
			to_chat(usr, span_notice("You [locked ? "lock" : "unlock"] [src]."))
			return

	to_chat(usr, span_warning("Your key doesn't fit this lock!"))
	return ..()

/obj/structure/vampdoor/wood/apartment
	locked = TRUE
	grant_apartment_key = TRUE
	apartment_key_type = /obj/item/vamp/keys/apartment
	lock_id = null //Will be randomized
	lockpick_difficulty = 8

/obj/structure/vampdoor/wood/apartment/Initialize()
	. = ..()
	if(grant_apartment_key && !lock_id)
		lock_id = "[rand(1,9999999)]" // I know, not foolproof
