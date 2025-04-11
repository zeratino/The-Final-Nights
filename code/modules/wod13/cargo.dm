/datum/supply_pack/vampire/weed_supplies
	desc = "Contains a bailer and some seeds. No trays."
	cost = 100
	contains = list(
		/obj/item/bailer,
		/obj/item/weedseed = 5,
	)
	crate_name = "hydro crate"

/datum/supply_pack/vampire/weed_tray
	name = "Weed Tray"
	desc = "Contains a tray of weed."
	cost = 300
	contains = list(/obj/structure/weedshit/buyable)
	crate_name = "weed crate"

/datum/supply_pack/vampire/methlab
	name = "Lab Equipment"
	desc = "Contains lab equipment."
	cost = 10000
	contains = list(/obj/structure/methlab/movable)

/datum/supply_pack/vampire/fixing
	name = "Fixing kit (wirecutters, lamps)"
	desc = "Contains wirecutters, lamps and other stuff to restore light in the area."
	cost = 50
	contains = list(
		/obj/item/wire_cutters,
		/obj/item/storage/box/lights/mixed,
	)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponstake
	name = "Weapon (stake)"
	desc = "Contains 3 usable wooden stakes."
	cost = 100
	contains = list(/obj/item/vampire_stake = 3)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponknife
	name = "Weapon (knife)"
	desc = "Contains a knife."
	cost = 100
	contains = list(/obj/item/melee/vampirearms/knife)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weapontire
	name = "Weapon (tire iron)"
	desc = "Contains a tire iron."
	cost = 100
	contains = list(/obj/item/melee/vampirearms/tire)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/paperwork
	name = "Paperwork Kit"
	desc = "Contains all your writing needs."
	cost = 100
	contains = list(
		/obj/item/paper_bin,
		/obj/item/pen = 5,)
	crate_name = "paperwork crate"

/datum/supply_pack/vampire/cuffs
	name = "Box of Handcuffs"
	desc = "Contains a box of handcuffs."
	cost = 150
	contains = list(/obj/item/storage/box/handcuffs)
	crate_name = "handcuff crate"

/datum/supply_pack/vampire/camera
	name = "Camera Kit"
	desc = "Contains a single camera and a spare roll of film."
	cost = 200
	contains = list(
		/obj/item/camera,
		/obj/item/camera_film,
	)

/datum/supply_pack/vampire/binoculars
	name = "Binoculars"
	desc = "Contains a single pair of binoculars."
	cost = 300
	contains = list(/obj/item/binoculars)

/datum/supply_pack/vampire/weaponshovel
	name = "Weapon (shovel)"
	desc = "Contains a shovel."
	cost = 300
	contains = list(/obj/item/melee/vampirearms/shovel)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponbaseball
	name = "Weapon (baseball bat)"
	desc = "Contains a baseball bat."
	cost = 400
	contains = list(/obj/item/melee/vampirearms/baseball)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/potassiodide
	name = "Potassium Iodide"
	desc = "Contains bottle of potassium iodide."
	cost = 400
	contains = list(/obj/item/storage/pill_bottle/potassiodide)

/datum/supply_pack/vampire/ephedrine
	name = "Ephedrine"
	desc = "Contains bottle of ephedrine."
	cost = 400
	contains = list(/obj/item/storage/pill_bottle/ephedrine)

/datum/supply_pack/vampire/gas_can
	name = "Gas Can"
	desc = "Contains a gas can."
	cost = 400
	contains = list(/obj/item/gas_can/full)

/datum/supply_pack/vampire/medicalsupplies
	name = "Medical Supplies"
	desc = "Contains some first aid supplies."
	cost = 500
	contains = list(
		/obj/item/stack/medical/gauze,
		/obj/item/stack/medical/bruise_pack,
		/obj/item/stack/medical/suture,
		/obj/item/stack/medical/ointment,
	)

/datum/supply_pack/vampire/weaponfireaxe
	name = "Weapon (fire axe)"
	desc = "Contains a fire axe."
	cost = 600
	contains = list(/obj/item/melee/vampirearms/fireaxe)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponrapier
	name = "Weapon (rapier)"
	desc = "Contains a rapier and sheathe."
	cost = 800
	contains = list(/obj/item/storage/belt/vampire/sheathe/rapier)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponmachete
	name = "Weapon (machete)"
	desc = "Contains machete."
	cost = 500
	contains = list(/obj/item/melee/vampirearms/machete)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponkatana
	name = "Weapon (katana)"
	desc = "Contains a katana."
	cost = 1000
	contains = list(/obj/item/melee/vampirearms/katana)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponsabre
	name = "Weapon (sabre)"
	desc = "Contains a sabre and sheathe."
	cost = 1200
	contains = list(/obj/item/storage/belt/vampire/sheathe/sabre)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponlongsword
	name = "Weapon (longsword)"
	desc = "Contains a longsword and sheathe."
	cost = 1500
	contains = list(/obj/item/storage/belt/vampire/sheathe/longsword)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponchainsaw
	name = "Weapon (chainsaw)"
	desc = "Contains a chainsaw."
	cost = 2000
	contains = list(/obj/item/melee/vampirearms/chainsaw)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponrevolver
	name = "Weapon (revolver)"
	desc = "Contains a revolver."
	cost = 200
	contains = list(/obj/item/gun/ballistic/vampire/revolver)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weapondeagle
	name = "Weapon (desert eagle)"
	desc = "Contains a desert eagle."
	cost = 400
	contains = list(
		/obj/item/gun/ballistic/automatic/vampire/deagle,
		/obj/item/ammo_box/magazine/m44,
	)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/glock
	name = "Weapon (Brokk19)"
	desc = "Contains a Brokk19 handgun."
	cost = 600
	contains = list(/obj/item/gun/ballistic/automatic/vampire/glock19)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/beretta
	name = "Weapon (Dual Elite 92G)"
	desc = "Contains a pair of Elite 92G handguns."
	cost = 900
	contains = list(/obj/item/gun/ballistic/automatic/vampire/beretta = 2)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponuzi
	name = "Weapon (mini uzi)"
	desc = "Contains a mini uzi."
	cost = 1000
	contains = list(
		/obj/item/gun/ballistic/automatic/vampire/uzi,
		/obj/item/ammo_box/magazine/vamp9mm,
	)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponshotgun
	name = "Weapon (pomp shotgun)"
	desc = "Contains a pomp shotgun."
	cost = 800
	contains = list(/obj/item/gun/ballistic/shotgun/vampire)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/thompson
	name = "Weapon (Thompson)"
	desc = "Contains a Thompson SMG."
	cost = 2000
	contains = list(/obj/item/gun/ballistic/automatic/vampire/thompson)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/mp5
	name = "Weapon (MP5)"
	desc = "Contains an MP5."
	cost = 2000
	contains = list(/obj/item/gun/ballistic/automatic/vampire/mp5)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/ak74
	name = "Weapon (AK-74)"
	desc = "Contains an AK-74."
	cost = 2200
	contains = list(/obj/item/gun/ballistic/automatic/vampire/ak74)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponrifle
	name = "Weapon (assault rifle)"
	desc = "Contains an assault rifle."
	cost = 3000
	contains = list(
		/obj/item/gun/ballistic/automatic/vampire/ar15,
		/obj/item/ammo_box/magazine/vamp556,
	)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponcarbine
	name = "Weapon (assault carbine)"
	desc = "Contains an assault carbine."
	cost = 4000
	contains = list(
		/obj/item/gun/ballistic/automatic/vampire/aug,
		/obj/item/ammo_box/magazine/vampaug,)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponcrossbow
	name = "Weapon (crossbow)"
	desc = "Contains a crossbow."
	cost = 1000
	contains = list(/obj/item/gun/ballistic/shotgun/toy/crossbow/vampire)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/weaponsniper
	name = "Weapon (sniper rifle)"
	desc = "Contains a sniper rifle."
	cost = 2000
	contains = list(/obj/item/gun/ballistic/automatic/vampire/sniper)
	crate_name = "weapon crate"

/datum/supply_pack/vampire/ammo9
	name = "Ammo (9mm)"
	desc = "Contains a box of 9mm ammunition."
	cost = 200
	contains = list(/obj/item/ammo_box/vampire/c9mm = 2)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo12g
	name = "Ammo (12g, slug)"
	desc = "Contains a box of 12 gauge shotgun slugs."
	cost = 400
	contains = list(/obj/item/ammo_box/vampire/c12g = 2)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo12gbuck
	name = "Ammo (12g, buckshot)"
	desc = "Contains a box of 12g 00 buckshot shells."
	cost = 400
	contains = list(/obj/item/ammo_box/vampire/c12g/buck = 2)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo545
	name = "Ammo (5.45)"
	desc = "Contains a box of 5.45 ammunition."
	cost = 500
	contains = list(/obj/item/ammo_box/vampire/c545 = 2)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo44
	name = "Ammo (.44)"
	desc = "Contains a box of .44 ammunition."
	cost = 600
	contains = list(/obj/item/ammo_box/vampire/c44 = 2)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo556
	name = "Ammo (5.56)"
	desc = "Contains a box of 5.56 ammunition."
	cost = 1500
	contains = list(/obj/item/ammo_box/vampire/c556 = 2)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo9/silver
	name = "Ammo (9mm, silver)"
	desc = "Contains a box of silver 9mm ammunition."
	cost = 2000
	contains = list(/obj/item/ammo_box/vampire/c9mm/silver)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo44/silver
	name = "Ammo (.44, silver)"
	desc = "Contains a box of silver .44 ammunition."
	cost = 2000
	contains = list(/obj/item/ammo_box/vampire/c44/silver)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo45/silver
	name = "Ammo (.45, silver)"
	desc = "Contains a box of silver .45 ammunition."
	cost = 2000
	contains = list(/obj/item/ammo_box/vampire/c45acp/silver)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo556/silver
	name = "Ammo (5.56, silver)"
	desc = "Contains a box of silver 5.56 ammunition."
	cost = 3000
	contains = list(/obj/item/ammo_box/vampire/c556/silver)

/datum/supply_pack/vampire/ammo50
	name = "Ammo (.50)"
	desc = "Contains a box of .50 ammunition."
	cost = 2500
	contains = list(/obj/item/ammo_box/vampire/c50)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo556
	name = "Ammo (5.56)"
	desc = "Contains a box of 5.56 ammunition."
	cost = 1500
	contains = list(/obj/item/ammo_box/vampire/c556)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammo556/incendiart
	name = "Ammo (5.56 incendiary)"
	desc = "Contains a box of incendiary 5.56 ammunition."
	cost = 4500
	contains = list(/obj/item/ammo_box/vampire/c556/incendiary)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/ammobolt
	name = "Ammo (bolts)"
	desc = "Contains three boxes of crossbow ammunition."
	cost = 600
	contains = list(/obj/item/ammo_box/vampire/arrows = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_colt1911
	name = "Ammo (3x Colt M1911 magazine)"
	desc = "Contains three Colt M1911 magazines."
	cost = 50
	contains = list(/obj/item/ammo_box/magazine/vamp45acp = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_glock19
	name = "Ammo (3x Brokk19 magazine)"
	desc = "Contains three Brokk19 magazines."
	cost = 100
	contains = list(/obj/item/ammo_box/magazine/glock9mm = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_beretta
	name = "Ammo (4x Elite 92G magazines)"
	desc = "Contains four Elite 92G magazines."
	cost = 130
	contains = list(/obj/item/ammo_box/magazine/semi9mm = 4)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_ak74
	name = "Ammo (3x AK74 magazines)"
	desc = "Contains three AK74 magazines."
	cost = 100
	contains = list(/obj/item/ammo_box/magazine/vamp545 = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_deagle
	name = "Ammo (3x desert eagle magazines)"
	desc = "Contains three desert eagle magazine."
	cost = 100
	contains = list(/obj/item/ammo_box/magazine/m44 = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_mp5
	name = "Ammo (3x HK MP5 magazines)"
	desc = "Contains three HK MP5 magazines."
	cost = 150
	contains = list(/obj/item/ammo_box/magazine/vamp9mp5 = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_uzi
	name = "Ammo (3x mini uzi magazines)"
	desc = "Contains three mini uzi magazines."
	cost = 200
	contains = list(/obj/item/ammo_box/magazine/vamp9mm = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_ar15
	name = "Ammo (3x AR-15 rifle magazine)"
	desc = "Contains three AR-15 rifle magazines."
	cost = 200
	contains = list(/obj/item/ammo_box/magazine/vamp556 = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_aug
	name = "Ammo (3x AUG carbine magazine)"
	desc = "Contains three AUG carbine magazines."
	cost = 300
	contains = list(/obj/item/ammo_box/magazine/vampaug = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/magazine_thompson
	name = "Ammo (3x Thompson magazine)"
	desc = "Contains three Thompson magazines."
	cost = 300
	contains = list(/obj/item/ammo_box/magazine/vampthompson = 3)
	crate_name = "ammo crate"

/datum/supply_pack/vampire/holster
	name = "Armor (holster)"
	desc = "Contans one pistol holster."
	cost = 300
	contains = list(/obj/item/storage/belt/holster/detective/vampire)
	crate_name = "armor crate"

/datum/supply_pack/vampire/armorlight
	name = "Armor (3 civilian)"
	desc = "Contains 3 types of body clothing and 3 types of light head protection."
	cost = 1000
	contains = list(/obj/item/clothing/suit/vampire/trench,
					/obj/item/clothing/suit/vampire/trench/alt,
					/obj/item/clothing/suit/vampire/trench/archive,
					/obj/item/clothing/head/vampire/police,
					/obj/item/clothing/head/vampire/cowboy,
					/obj/item/clothing/head/vampire/british,
				)
	crate_name = "armor crate"

/datum/supply_pack/vampire/armorpolice
	name = "Armor (police)"
	desc = "Contains a single set of full police protection."
	cost = 1000
	contains = list(
		/obj/item/clothing/suit/vampire/vest,
		/obj/item/clothing/head/vampire/helmet,
	)
	crate_name = "armor crate"

/datum/supply_pack/vampire/armorarmy
	name = "Armor (army)"
	desc = "Contains a single set of full army protection."
	cost = 1500
	contains = list(
		/obj/item/clothing/suit/vampire/vest/army,
		/obj/item/clothing/head/vampire/army,
	)
	crate_name = "armor crate"

/datum/supply_pack/vampire/armoreod
	name = "Armor (EOD)"
	desc = "Contains a single set of full EOD protection."
	cost = 2000
	contains = list(
		/obj/item/clothing/suit/vampire/eod,
		/obj/item/clothing/head/vampire/eod,
	)
	crate_name = "armor crate"

/datum/supply_pack/vampire/thermal_drill
	name = "Thermal Drill"
	desc = "Contains a thermal drill."
	cost = 4000
	contains = list(/obj/structure/drill)
	crate_name = "drill crate"

/obj/item/stack/dollar
	name = "dollars"
	desc = "Wow! With enough of these, you could buy a lot! ...Pssh, yeah right."
	singular_name = "dollar"
	icon_state = "money1"
	icon = 'code/modules/wod13/items.dmi'
	lefthand_file = null
	righthand_file = null
	onflooricon = 'code/modules/wod13/onfloor.dmi'
	w_class = WEIGHT_CLASS_TINY
	max_amount = 1000
	merge_type = /obj/item/stack/dollar

/obj/item/stack/dollar/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	update_icon()

/obj/item/stack/dollar/update_icon_state()
	var/amount = get_amount()
	switch(amount)
		if(100 to INFINITY)
			icon_state = "money3"
		if(50 to 100)
			icon_state = "money2"
		if(1 to 50)
			icon_state = "money1"
		else
			icon_state = "money"

/obj/item/stack/dollar/five
	amount = 5

/obj/item/stack/dollar/ten
	amount = 10

/obj/item/stack/dollar/fifty
	amount = 50

/obj/item/stack/dollar/hundred
	amount = 100

/obj/item/stack/dollar/rand
	amount = 1.3

/obj/item/stack/dollar/rand/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	if(amount == 1.3)
		amount = rand(5, 30)
		update_icon()

/obj/item/cargo_box
	name = "cargo box"
	desc = "Special deliever."
	icon_state = "box"
	icon = 'code/modules/wod13/items.dmi'
	lefthand_file = 'code/modules/wod13/righthand.dmi'
	righthand_file = 'code/modules/wod13/lefthand.dmi'
	w_class = WEIGHT_CLASS_HUGE

/obj/structure/cargo_take
	name = "cargo"
	desc = "Take and place boxes."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "box_take"
	plane = GAME_PLANE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	var/last_take = 0

/obj/structure/cargo_take/attack_hand(mob/user)
	if(last_take+30 < world.time)
		last_take = world.time
		playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE, extrarange = -3)
		to_chat(user, span_notice("You take the box from [src]."))
		new /obj/item/cargo_box(get_turf(user))
		return
	..()

/obj/structure/cargo_put
	name = "cargo"
	desc = "Take and place boxes."
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "box_put"
	plane = GAME_PLANE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/structure/cargo_put/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/cargo_box))
		qdel(I)
		playsound(src, 'sound/machines/machine_vend.ogg', 50, TRUE, extrarange = -3)
		to_chat(user, span_notice("You place the box at [src]."))
		new /obj/item/stack/dollar/five(get_turf(user))
		return
	..()
