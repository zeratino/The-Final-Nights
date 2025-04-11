/datum/preferences
	var/last_torpor = 0

/mob/living/carbon/human/death()
	. = ..()

	if(iskindred(src))
		SSmasquerade.dead_level = min(1000, SSmasquerade.dead_level+50)
	else
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.zone_type == "masquerade")
				SSmasquerade.dead_level = max(0, SSmasquerade.dead_level-25)

	if(bloodhunted)
		SSbloodhunt.hunted -= src
		bloodhunted = FALSE
		SSbloodhunt.update_shit()
	var/witness_count
	for(var/mob/living/carbon/human/npc/NEPIC in viewers(7, usr))
		if(NEPIC && NEPIC.stat != DEAD)
			witness_count++
		if(witness_count > 1)
			for(var/obj/item/police_radio/radio in GLOB.police_radios)
				radio.announce_crime("murder", get_turf(src))
			for(var/obj/machinery/p25transceiver/police/radio in GLOB.p25_tranceivers)
				if(radio.p25_network == "police")
					radio.announce_crime("murder", get_turf(src))
					break
	GLOB.masquerade_breakers_list -= src
	GLOB.sabbatites -= src

	//So upon death the corpse is filled with yin chi
	yin_chi = min(max_yin_chi, yin_chi+yang_chi)
	yang_chi = 0

	if(iskindred(src) || iscathayan(src))
		can_be_embraced = FALSE
		var/obj/item/organ/brain/brain = getorganslot(ORGAN_SLOT_BRAIN) //NO REVIVAL EVER
		if (brain)
			brain.organ_flags |= ORGAN_FAILING

		if(in_frenzy)
			exit_frenzymod()
		SEND_SOUND(src, sound('code/modules/wod13/sounds/final_death.ogg', 0, 0, 50))

		//annoying code that depends on clan doesn't work for Kuei-jin
		if (iscathayan(src))
			return

		var/years_undead = chronological_age - age
		switch (years_undead)
			if (-INFINITY to 10) //normal corpse
				return
			if (10 to 50)
				clane.rot_body(1) //skin takes on a weird colouration
				visible_message("<span class='notice'>[src]'s skin loses some of its colour.</span>")
				update_body()
				update_body() //this seems to be necessary due to stuff being set on update_body() and then only refreshing with a new call
			if (50 to 100)
				clane.rot_body(2) //looks slightly decayed
				visible_message("<span class='notice'>[src]'s skin rapidly decays.</span>")
				update_body()
				update_body()
			if (100 to 150)
				clane.rot_body(3) //looks very decayed
				visible_message("<span class='warning'>[src]'s body rapidly decomposes!</span>")
				update_body()
				update_body()
			if (150 to 200)
				clane.rot_body(4) //mummified skeletonised corpse
				visible_message("<span class='warning'>[src]'s body rapidly skeletonises!</span>")
				update_body()
				update_body()
			if (200 to INFINITY)
				if (iskindred(src))
					playsound(src, 'code/modules/wod13/sounds/burning_death.ogg', 80, TRUE)
				else if (iscathayan(src))
					playsound(src, 'code/modules/wod13/sounds/vicissitude.ogg', 80, TRUE)
				lying_fix()
				dir = SOUTH
				spawn(1 SECONDS)
					dust(TRUE, TRUE) //turn to ash

/mob/living/carbon/human/toggle_move_intent(mob/living/user)
	if(blocking && m_intent == MOVE_INTENT_WALK)
		return
	..()

/mob/living/carbon/human/proc/SwitchBlocking()
	if(!blocking)
		visible_message("<span class='warning'>[src] prepares to block.</span>", "<span class='warning'>You prepare to block.</span>")
		blocking = TRUE
		if(hud_used)
			hud_used.block_icon.icon_state = "act_block_on"
		clear_parrying()
		remove_overlay(FIGHT_LAYER)
		var/mutable_appearance/block_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "block", -FIGHT_LAYER)
		overlays_standing[FIGHT_LAYER] = block_overlay
		apply_overlay(FIGHT_LAYER)
		last_m_intent = m_intent
		if(m_intent == MOVE_INTENT_RUN)
			toggle_move_intent(src)
	else
		to_chat(src, "<span class='warning'>You lower your defense.</span>")
		remove_overlay(FIGHT_LAYER)
		blocking = FALSE
		if(m_intent != last_m_intent)
			toggle_move_intent(src)
		if(hud_used)
			hud_used.block_icon.icon_state = "act_block_off"

/mob/living/carbon/human/attackby(obj/item/W, mob/living/user, params)
	if(user.blocking)
		return
	if(getStaminaLoss() >= 50 && blocking)
		SwitchBlocking()
	if(CheckFrenzyMove() && blocking)
		SwitchBlocking()
	if(user.a_intent == INTENT_GRAB && ishuman(user))
		var/mob/living/carbon/human/ZIG = user
		if(ZIG.getStaminaLoss() < 50 && !ZIG.CheckFrenzyMove())
			ZIG.parry_class = W.w_class
			ZIG.Parry(src)
			return
	if(user == parrying && user != src)
		if(W.w_class == parry_class)
			user.apply_damage(60, STAMINA)
		if(W.w_class == parry_class-1 || W.w_class == parry_class+1)
			user.apply_damage(30, STAMINA)
		else
			user.apply_damage(10, STAMINA)
		user.do_attack_animation(src)
		visible_message("<span class='danger'>[src] parries the attack!</span>", "<span class='danger'>You parry the attack!</span>")
		playsound(src, 'code/modules/wod13/sounds/parried.ogg', 70, TRUE)
		clear_parrying()
		return
	if(HAS_TRAIT(src, TRAIT_ENHANCED_MELEE_DODGE))
		apply_damage(3, STAMINA)
		user.do_attack_animation(src)
		playsound(src, 'sound/weapons/tap.ogg', 70, TRUE)
		emote("flip")
		visible_message("<span class='danger'>[src] dodges the attack!</span>", "<span class='danger'>You dodge the attack!</span>")
		return
	if(blocking)
		if(istype(W, /obj/item/melee))
			var/obj/item/melee/WEP = W
			var/obj/item/bodypart/assexing = get_bodypart("[(active_hand_index % 2 == 0) ? "r" : "l" ]_arm")
			if(istype(get_active_held_item(), /obj/item))
				var/obj/item/IT = get_active_held_item()
				if(IT.w_class >= W.w_class)
					apply_damage(10, STAMINA)
					user.do_attack_animation(src)
					playsound(src, 'sound/weapons/tap.ogg', 70, TRUE)
					visible_message("<span class='danger'>[src] blocks the attack!</span>", "<span class='danger'>You block the attack!</span>")
					if(incapacitated(TRUE, TRUE) && blocking)
						SwitchBlocking()
					return
				else
					var/hand_damage = max(WEP.force - IT.force/2, 1)
					playsound(src, WEP.hitsound, 70, TRUE)
					apply_damage(hand_damage, WEP.damtype, assexing)
					apply_damage(30, STAMINA)
					user.do_attack_animation(src)
					visible_message("<span class='warning'>[src] weakly blocks the attack!</span>", "<span class='warning'>You weakly block the attack!</span>")
					if(incapacitated(TRUE, TRUE) && blocking)
						SwitchBlocking()
					return
			else
				playsound(src, WEP.hitsound, 70, TRUE)
				apply_damage(round(WEP.force/2), WEP.damtype, assexing)
				apply_damage(30, STAMINA)
				user.do_attack_animation(src)
				visible_message("<span class='warning'>[src] blocks the attack with [gender == MALE ? "his" : "her"] bare hands!</span>", "<span class='warning'>You block the attack with your bare hands!</span>")
				if(incapacitated(TRUE, TRUE) && blocking)
					SwitchBlocking()
				return
	..()

/mob/living/carbon/human/attack_hand(mob/user)
	if(getStaminaLoss() >= 50 && blocking)
		SwitchBlocking()
	if(CheckFrenzyMove() && blocking)
		SwitchBlocking()
	if(user.a_intent == INTENT_HARM && HAS_TRAIT(src, TRAIT_ENHANCED_MELEE_DODGE))
		playsound(src, 'sound/weapons/tap.ogg', 70, TRUE)
		apply_damage(3, STAMINA)
		user.do_attack_animation(src)
		emote("flip")
		visible_message("<span class='danger'>[src] dodges the punch!</span>", "<span class='danger'>You dodge the punch!</span>")
		return
	if(user.a_intent == INTENT_HARM && blocking)
		playsound(src, 'sound/weapons/tap.ogg', 70, TRUE)
		apply_damage(10, STAMINA)
		user.do_attack_animation(src)
		visible_message("<span class='danger'>[src] blocks the punch!</span>", "<span class='danger'>You block the punch!</span>")
		if(incapacitated(TRUE, TRUE) && blocking)
			SwitchBlocking()
		return
	..()

/mob/living/carbon/human/proc/Parry(var/mob/M)
	if(!pulledby && !parrying && world.time-parry_cd >= 30 && M != src)
		parrying = M
		if(blocking)
			SwitchBlocking()
		visible_message("<span class='warning'>[src] prepares to parry [M]'s next attack.</span>", "<span class='warning'>You prepare to parry [M]'s next attack.</span>")
		playsound(src, 'code/modules/wod13/sounds/parry.ogg', 70, TRUE)
		remove_overlay(FIGHT_LAYER)
		var/mutable_appearance/parry_overlay = mutable_appearance('code/modules/wod13/icons.dmi', "parry", -FIGHT_LAYER)
		overlays_standing[FIGHT_LAYER] = parry_overlay
		apply_overlay(FIGHT_LAYER)
		parry_cd = world.time
		spawn(10)
			clear_parrying()
	return

/mob/living/carbon/human/proc/clear_parrying()
	if(parrying)
		parrying = null
		remove_overlay(FIGHT_LAYER)
		to_chat(src, "<span class='warning'>You lower your defense.</span>")

/atom/movable/screen/jump
	name = "jump"
	icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	icon_state = "act_jump_off"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/jump/Click()
	var/mob/living/L = usr
	if(!L.prepared_to_jump)
		L.prepared_to_jump = TRUE
		icon_state = "act_jump_on"
		to_chat(usr, "<span class='notice'>You prepare to jump.</span>")
	else
		L.prepared_to_jump = FALSE
		icon_state = "act_jump_off"
		to_chat(usr, "<span class='notice'>You are not prepared to jump anymore.</span>")
	..()

/atom/Click()
	. = ..()
	if(isliving(usr) && usr != src)
		var/mob/living/L = usr
		if(L.prepared_to_jump)
			L.jump(src)

/atom/movable/screen/block
	name = "block"
	icon = 'code/modules/wod13/UI/buttons_wide.dmi'
	icon_state = "act_block_off"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/block/Click()
	if(ishuman(usr))
		var/mob/living/carbon/human/BL = usr
		BL.SwitchBlocking()
	..()

/atom/movable/screen/vtm_zone
	name = "zone"
	icon = 'code/modules/wod13/48x48.dmi'
	icon_state = "masquerade"
	layer = HUD_LAYER
	plane = HUD_PLANE
	alpha = 64

/atom/movable/screen/blood
	name = "bloodpool"
	icon = 'code/modules/wod13/UI/bloodpool.dmi'
	icon_state = "blood0"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/addinv
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/blood/Click()
	if(iscarbon(usr))
		var/mob/living/carbon/human/BD = usr
		BD.update_blood_hud()
		if(BD.bloodpool > 0)
			to_chat(BD, "<span class='notice'>You've got [BD.bloodpool]/[BD.maxbloodpool] blood points.</span>")
		else
			to_chat(BD, "<span class='warning'>You've got [BD.bloodpool]/[BD.maxbloodpool] blood points.</span>")
	..()

/atom/movable/screen/drinkblood
	name = "Drink Blood"
	icon = 'code/modules/wod13/disciplines.dmi'
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/drinkblood/Click()
	bite()
	. = ..()

/atom/movable/screen/drinkblood/proc/bite()
	if(ishuman(usr))
		var/mob/living/carbon/human/BD = usr
		BD.update_blood_hud()
		if(world.time < BD.last_drinkblood_use+30)
			return
		if(world.time < BD.last_drinkblood_click+10)
			return
		BD.last_drinkblood_click = world.time
		if(BD.grab_state > GRAB_PASSIVE)
			if(ishuman(BD.pulling))
				var/mob/living/carbon/human/PB = BD.pulling
				if(isghoul(BD))
					if(!iskindred(PB))
						SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
						to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
						return
				if(!isghoul(BD) && !iskindred(BD) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				if(PB.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				if(PB.bloodpool <= 0 && (!iskindred(BD.pulling) || !iskindred(BD)))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(BD.clane)
					var/special_clan = FALSE
					if(BD.clane.name == "Salubri")
						if(!PB.IsSleeping())
							to_chat(BD, "<span class='warning'>You can't drink from aware targets!</span>")
							return
						special_clan = TRUE
						PB.emote("moan")
					if(BD.clane.name == "Giovanni")
						PB.emote("scream")
						special_clan = TRUE
					if(!special_clan)
						PB.emote("groan")
				PB.add_bite_animation()
			if(isliving(BD.pulling))
				if(!iskindred(BD) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				var/mob/living/LV = BD.pulling
				if(LV.bloodpool <= 0 && (!iskindred(BD.pulling) || !iskindred(BD)))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(LV.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				var/skipface = (BD.wear_mask && (BD.wear_mask.flags_inv & HIDEFACE)) || (BD.head && (BD.head.flags_inv & HIDEFACE))
				if(!skipface)
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						playsound(BD, 'code/modules/wod13/sounds/drinkblood1.ogg', 50, TRUE)
						LV.visible_message("<span class='warning'><b>[BD] bites [LV]'s neck!</b></span>", "<span class='warning'><b>[BD] bites your neck!</b></span>")
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						if(BD.CheckEyewitness(LV, BD, 7, FALSE))
							BD.AdjustMasquerade(-1)
					else
						playsound(BD, 'code/modules/wod13/sounds/kiss.ogg', 50, TRUE)
						LV.visible_message("<span class='italics'><b>[BD] kisses [LV]!</b></span>", "<span class='userlove'><b>[BD] kisses you!</b></span>")
					if(iskindred(LV))
						var/mob/living/carbon/human/HV = BD.pulling
						if(HV.stakeimmune)
							to_chat(BD, "<span class='warning'>There is no <b>HEART</b> in this creature.</span>")
							return
					BD.drinksomeblood(LV)

/atom/movable/screen/bloodpower
	name = "Bloodpower"
	icon = 'code/modules/wod13/disciplines.dmi'
	icon_state = "bloodpower"
	layer = HUD_LAYER
	plane = HUD_PLANE

/atom/movable/screen/bloodpower/Click()
	SEND_SOUND(usr, sound('code/modules/wod13/sounds/highlight.ogg', 0, 0, 50))
	if(ishuman(usr))
		var/mob/living/carbon/human/BD = usr
		if(world.time < BD.last_bloodpower_use+110)
			return
		if(world.time < BD.last_bloodpower_click+10)
			return
		BD.last_bloodpower_click = world.time
		var/plus = 0
		if(HAS_TRAIT(BD, TRAIT_HUNGRY))
			plus = 1
		if(BD.bloodpool >= 3+plus)
			playsound(usr, 'code/modules/wod13/sounds/bloodhealing.ogg', 50, FALSE)
			BD.last_bloodpower_use = world.time
			BD.bloodpool = max(0, BD.bloodpool-(3+plus))
			icon_state = "[initial(icon_state)]-on"
			to_chat(BD, "<span class='notice'>You use blood to become more powerful.</span>")
			BD.dna.species.punchdamagehigh = BD.dna.species.punchdamagehigh+5
			BD.physiology.armor.melee = BD.physiology.armor.melee+15
			BD.physiology.armor.bullet = BD.physiology.armor.bullet+15
			if(!HAS_TRAIT(BD, TRAIT_IGNORESLOWDOWN))
				ADD_TRAIT(BD, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
			BD.update_blood_hud()
			addtimer(CALLBACK(src, PROC_REF(end_bloodpower)), 100+BD.discipline_time_plus+BD.bloodpower_time_plus)
		else
			SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
			to_chat(BD, "<span class='warning'>You don't have enough <b>BLOOD</b> to become more powerful.</span>")

/atom/movable/screen/bloodpower/proc/end_bloodpower()
	if(ishuman(usr))
		var/mob/living/carbon/human/BD = usr
		to_chat(BD, "<span class='warning'>You feel like your <b>BLOOD</b>-powers slowly decrease.</span>")
		if(BD.dna.species)
			BD.dna.species.punchdamagehigh = BD.dna.species.punchdamagehigh-5
			BD.physiology.armor.melee = BD.physiology.armor.melee-15
			BD.physiology.armor.bullet = BD.physiology.armor.bullet-15
			if(HAS_TRAIT(BD, TRAIT_IGNORESLOWDOWN))
				REMOVE_TRAIT(BD, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
	icon_state = initial(icon_state)

/atom/movable/screen/disciplines
	layer = HUD_LAYER
	plane = HUD_PLANE
	var/datum/discipline/dscpln
	var/last_discipline_click = 0
	var/last_discipline_use = 0
	var/main_state = ""
	var/active = FALSE
	var/obj/effect/overlay/level2
	var/obj/effect/overlay/level3
	var/obj/effect/overlay/level4
	var/obj/effect/overlay/level5

/atom/movable/screen/disciplines/Initialize()
	. = ..()
	level2 = new(src)
	level2.icon = 'code/modules/wod13/disciplines.dmi'
	level2.icon_state = "2"
	level2.layer = ABOVE_HUD_LAYER+5
	level2.plane = HUD_PLANE
	level3 = new(src)
	level3.icon = 'code/modules/wod13/disciplines.dmi'
	level3.icon_state = "3"
	level3.layer = ABOVE_HUD_LAYER+5
	level3.plane = HUD_PLANE
	level4 = new(src)
	level4.icon = 'code/modules/wod13/disciplines.dmi'
	level4.icon_state = "4"
	level4.layer = ABOVE_HUD_LAYER+5
	level4.plane = HUD_PLANE
	level5 = new(src)
	level5.icon = 'code/modules/wod13/disciplines.dmi'
	level5.icon_state = "5"
	level5.layer = ABOVE_HUD_LAYER+5
	level5.plane = HUD_PLANE

/atom/MouseEntered(location,control,params)
	if(isturf(src) || ismob(src) || isobj(src))
		if(loc && iscarbon(usr))
			var/mob/living/carbon/H = usr
			if(H.a_intent == INTENT_HARM)
				if(!H.IsSleeping() && !H.IsUnconscious() && !H.IsParalyzed() && !H.IsKnockdown() && !H.IsStun() && !HAS_TRAIT(H, TRAIT_RESTRAINED))
					H.face_atom(src)
					H.harm_focus = H.dir

/mob/living/carbon/Move(atom/newloc, direct, glide_size_override)
	. = ..()
	if(a_intent == INTENT_HARM && client)
		setDir(harm_focus)
	else
		harm_focus = dir

/mob/living/carbon/werewolf/Life()
	. = ..()
	update_blood_hud()
	update_rage_hud()
	update_auspex_hud()

/mob/living/carbon/human/Life()
	if(!iskindred(src) && !iscathayan(src))
		if(prob(5))
			adjustCloneLoss(-5, TRUE)
	update_blood_hud()
	update_zone_hud()
	update_rage_hud()
	update_shadow()
	handle_vampire_music()
	update_auspex_hud()
	..()

/mob/living/Initialize()
	. = ..()
	gnosis = new(src)
	gnosis.icon = 'code/modules/wod13/48x48.dmi'
	gnosis.plane = ABOVE_HUD_PLANE
	gnosis.layer = ABOVE_HUD_LAYER

/mob/living/proc/update_rage_hud()
	if(!client || !hud_used)
		return
	if(isgarou(src) || iswerewolf(src))
		if(hud_used.rage_icon)
			hud_used.rage_icon.overlays -= gnosis
			var/mob/living/carbon/C = src
			hud_used.rage_icon.icon_state = "rage[C.auspice.rage]"
			gnosis.icon_state = "gnosis[C.auspice.gnosis]"
			hud_used.rage_icon.overlays |= gnosis
		if(hud_used.auspice_icon)
			var/mob/living/carbon/C = src
			if(C.last_moon_look != 0)
				hud_used.auspice_icon.icon_state = "[GLOB.moon_state]"

/mob/living/proc/update_blood_hud()
	if(!client || !hud_used)
		return
	maxbloodpool = 10+((13-generation)*3)
	if(hud_used.blood_icon)
		var/emm = round((bloodpool/maxbloodpool)*10)
		if(emm > 10)
			hud_used.blood_icon.icon_state = "blood10"
		if(emm < 0)
			hud_used.blood_icon.icon_state = "blood0"
		else
			hud_used.blood_icon.icon_state = "blood[emm]"

/mob/living/proc/update_zone_hud()
	if(!client || !hud_used)
		return
	if(hud_used.zone_icon)
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			hud_used.zone_icon.icon_state = "[V.zone_type]"
			if(V.zone_type == "elysium")
				if(!HAS_TRAIT(src, TRAIT_ELYSIUM))
					ADD_TRAIT(src, TRAIT_ELYSIUM, "elysium")
			else
				elysium_checks = 0
				if(HAS_TRAIT(src, TRAIT_ELYSIUM))
					REMOVE_TRAIT(src, TRAIT_ELYSIUM, "elysium")
