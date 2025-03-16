/obj/item/mystic_tome
	name = "mystic tome"
	desc = "The secrets of Abyss Mysticism..."
	icon_state = "mystic"
	icon = 'code/modules/wod13/items.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/list/rituals = list()

/obj/item/mystic_tome/Initialize()
	. = ..()
	for(var/i in subtypesof(/obj/abyssrune))
		if(i)
			var/obj/abyssrune/R = new i(src)
			rituals |= R

/obj/item/mystic_tome/attack_self(mob/user)
	. = ..()
	for(var/obj/abyssrune/R in rituals)
		if(R)
			if(R.sacrifice)
				var/obj/item/I = new R.sacrifice(src)
				to_chat(user, "[R.mystlevel] [R.name] - [R.desc] Requirements: [I].")
				qdel(I)
			else
				to_chat(user, "[R.mystlevel] [R.name] - [R.desc]")

/obj/abyssrune
	name = "Lasombra Rune"
	desc = "Learn the secrets of the Abyss, neonate..."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "rune1"
	color = rgb(0,0,0)
	anchored = TRUE
	var/word = "IDI NAH"
	var/activator_bonus = 0
	var/activated = FALSE
	var/mob/living/last_activator
	var/mystlevel = 1
	var/sacrifice

/obj/abyssrune/proc/complete()
	return

/obj/abyssrune/attack_hand(mob/user)
	if(!activated)
		var/mob/living/L = user
		if(L.mysticism_knowledge)
			L.say("[word]")
			L.Immobilize(30)
			last_activator = user
			activator_bonus = L.thaum_damage_plus
			if(sacrifice)
				for(var/obj/item/I in get_turf(src))
					if(I)
						if(istype(I, sacrifice))
							qdel(I)
							complete()
			else
				complete()

/obj/abyssrune/AltClick(mob/user)
	..()
	qdel(src)

/obj/abyssrune/selfgib
	name = "Self Destruction"
	desc = "Meet the Final Death."
	icon_state = "rune2"
	word = "YNT FRM MCHGN FYNV DN THS B'FO"

/obj/abyssrune/selfgib/complete()
	last_activator.death()

/obj/abyssrune/silent_heart
	name = "Silently-Beating Heart"
	desc = "Creates a shadowy abomination to protect the Lasombra and his domain."
	icon_state = "rune1"
	word = "ANI UMRA"
	mystlevel = 3

/obj/abyssrune/silent_heart/complete()
	var/mob/living/carbon/human/H = last_activator
	if(!length(H.beastmaster))
		var/datum/action/beastmaster_stay/E1 = new()
		E1.Grant(last_activator)
		var/datum/action/beastmaster_deaggro/E2 = new()
		E2.Grant(last_activator)
	var/mob/living/simple_animal/hostile/beastmaster/shadow_guard/BG = new(loc)
	BG.beastmaster = last_activator
	H.beastmaster |= BG
	BG.my_creator = last_activator
	BG.melee_damage_lower = BG.melee_damage_lower+activator_bonus
	BG.melee_damage_upper = BG.melee_damage_upper+activator_bonus
	playsound(loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	if(length(H.beastmaster) > 3+H.mentality)
		var/mob/living/simple_animal/hostile/beastmaster/B = pick(H.beastmaster)
		B.death()
	qdel(src)

/mob/living/simple_animal/hostile/beastmaster/shadow_guard
	name = "shadow abomination"
	desc = "A shadow given life, creature of fathomless..."
	icon = 'code/modules/wod13/mobs.dmi'
	icon_state = "shadow2"
	icon_living = "shadow2"
	del_on_death = 1
	healable = 0
	mob_biotypes = MOB_SPIRIT
	speak_chance = 0
	turns_per_move = 5
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	emote_taunt = list("gnashes")
	speed = 0
	maxHealth = 200
	health = 200

	harm_intent_damage = 8
	obj_damage = 50
	melee_damage_lower = 20
	melee_damage_upper = 20
	attack_verb_continuous = "gouges"
	attack_verb_simple = "gouge"
	attack_sound = 'sound/creatures/venus_trap_hit.ogg'
	speak_emote = list("gnashes")

	atmos_requirements = list("min_oxy" = 0, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minbodytemp = 0
	maxbodytemp = 1500
	faction = list("Lasombra")
	pressure_resistance = 200
	bloodpool = 1
	maxbloodpool = 1

/obj/abyssrune/identification
	name = "Occult Items Identification"
	desc = "Identifies a single occult item"
	icon_state = "rune4"
	word = "WUS'ZAT"

/obj/abyssrune/identification/complete()
	for(var/obj/item/vtm_artifact/VA in loc)
		if(VA)
			VA.identificate()
			playsound(loc, 'sound/magic/voidblink.ogg', 50, FALSE)
			qdel(src)
			return

/obj/abyssrune/blackout //not canon wod material, seemed a cool idea.
	name = "Blackout"
	desc = "Destroys every wall light in range of the rune."
	icon_state = "rune7"
	word = "FYU'SES BLO'OUN"
	mystlevel = 2

//actual function of the rune
/obj/abyssrune/blackout/complete()
	for(var/obj/machinery/light/i in range(7, src)) //for every light in a range of 7 (called i)
		if(i != LIGHT_BROKEN) //if it aint broke
			i.break_light_tube(0) //break it
	playsound(loc, 'sound/magic/voidblink.ogg', 50, FALSE) //make the funny void sound
	qdel(src) //delete the rune

/obj/abyssrune/comforting_darkness
	name = "Comforting Darkness"
	desc = "Use the power of the abyss to mend the wounds of yourself and others."
	icon_state = "rune8"
	word = "KEYUR AGA"
	mystlevel = 2

/obj/abyssrune/comforting_darkness/complete()
	for(var/mob/living/victim in src.loc) //for every living mob in the same space as the rune
		victim.adjustBruteLoss(-30)
		victim.adjustFireLoss(-10)
		victim.adjustToxLoss(-20)
		victim.adjustCloneLoss(-5)
		victim.SetSleeping(60)
		playsound(loc, 'sound/magic/voidblink.ogg', 50, FALSE)
		qdel(src)
		return //shit uhhhhh do i need this???

	//after the loop is exited (due to failure to find) it resorts to working on the caster
	src.last_activator.adjustBruteLoss(-30) //not a lot, less than a good sword hit's worth, better to heal someone else with
	src.last_activator.adjustFireLoss(-10) //better have burn heal!
	src.last_activator.adjustToxLoss(-20) //shit, how do kindred deal with tox?
	src.last_activator.adjustCloneLoss(-5) //heals clone damage at a VERY small rate
	src.last_activator.SetSleeping(60) //sleeping is for balance to stop you from just selfspamming these. MIGHT be exploitable for offense too, but hey, creativity! its runes!
	playsound(loc, 'sound/magic/voidblink.ogg', 50, FALSE)
	qdel(src)
	//godawful, sorry, could be worse though.
