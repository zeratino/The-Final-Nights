/datum/job/vamp/zadruga
	title = "Zadruga"
	department_head = list("Voivode")
	faction = "Vampire" //[Lucifernix] - Change this to vampire when I actually fix this.
	total_positions = 2
	spawn_positions = 2
	supervisors = " the Laws of Hospitality"
	selection_color = "#953d2d"

	outfit = /datum/outfit/job/zadruga

	access = list(ACCESS_HYDROPONICS, ACCESS_BAR, ACCESS_KITCHEN, ACCESS_MORGUE, ACCESS_WEAPONS, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	minimal_access = list(ACCESS_BAR, ACCESS_MINERAL_STOREROOM, ACCESS_THEATRE)
	paycheck = PAYCHECK_EASY
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_ZADRUGA
	exp_type_department = EXP_TYPE_TZIMISCE

	allowed_species = list("Ghoul")
	duty = "You were born in servitude to the Master of the Manor: your father served the Voivode, as did his father. Now, you carry their blood, and with it their responsibilities."
	experience_addition = 20
	minimal_masquerade = 2
	my_contact_is_important = FALSE
	known_contacts = list("Prince", "Baron", "Sheriff")




/datum/outfit/job/zadruga
	name = "Zadruga"
	jobtype = /datum/job/vamp/zadruga
	id = /obj/item/card/id/bogatyr
	glasses = /obj/item/clothing/glasses/vampire/yellow
	uniform = /obj/item/clothing/under/vampire/bogatyr
	suit = /obj/item/clothing/suit/vampire/jacket/punk
	shoes = /obj/item/clothing/shoes/vampire/jackboots
	l_pocket = /obj/item/vamp/phone
	r_pocket = /obj/item/cockclock
	backpack_contents = list(/obj/item/vamp/keys/tzimisce/manor=1, /obj/item/passport=1, /obj/item/flashlight=1, /obj/item/vamp/creditcard=1)

/obj/effect/landmark/start/zadruga
	name = "Zadruga"
