/proc/create_unique_phone_number(var/exchange = 513)
	if(length(GLOB.subscribers_numbers_list) < 1)
		create_subscribers_numbers()
	var/subscriber_code = pick(GLOB.subscribers_numbers_list)
	GLOB.subscribers_numbers_list -= subscriber_code
	return "[exchange][subscriber_code]"

/proc/create_subscribers_numbers()
	for(var/i in 1 to 9999)
		var/ii = "0000"
		switch(i)
			if(1 to 9)
				ii = "000[i]"
			if(10 to 99)
				ii = "00[i]"
			if(100 to 999)
				ii = "0[i]"
			if(1000 to 9999)
				ii = "[i]"
		GLOB.subscribers_numbers_list += ii

/obj/item/vamp/phone
	name = "\improper phone"
	desc = "A portable device to call anyone you want."
	icon = 'code/modules/wod13/items.dmi'
	icon_state = "phone0"
	inhand_icon_state = "phone0"
	lefthand_file = 'code/modules/wod13/lefthand.dmi'
	righthand_file = 'code/modules/wod13/righthand.dmi'
	item_flags = NOBLUDGEON
	flags_1 = HEAR_1
	w_class = WEIGHT_CLASS_SMALL
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = FIRE_PROOF | ACID_PROOF
	onflooricon = 'code/modules/wod13/onfloor.dmi'

	var/exchange_num = 513
	var/list/contacts = list()
	var/blocked = FALSE
	var/list/blocked_contacts = list()
	var/closed = TRUE
	var/owner = ""
	var/number
	var/obj/item/vamp/phone/online
	var/talking = FALSE
	var/choosed_number = ""
	var/last_call = 0
	var/call_sound = 'code/modules/wod13/sounds/call.ogg'
	var/can_fold = 1
	var/interface = "Telephone"
	var/silence = FALSE
	var/toggle_published_contacts = FALSE
	var/list/published_numbers_contacts = list()
	var/list/phone_history_list = list()

	/// Phone icon states
	var/open_state = "phone2"
	var/closed_state = "phone1"
	var/folded_state = "phone0"

/obj/item/vamp/phone/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_HEAR, PROC_REF(handle_hearing))
	if(!number || number == "")
		if(ishuman(loc))
			var/mob/living/carbon/human/H_O = loc
			owner = H_O.real_name
		number = create_unique_phone_number(exchange_num)
		GLOB.phone_numbers_list += number
		GLOB.phones_list += src
		if(ishuman(loc))
			var/mob/living/carbon/human/H = loc
			if(H.Myself)
				H.Myself.phone_number = number

/obj/item/vamp/phone/Destroy()
	GLOB.phone_numbers_list -= number
	GLOB.phones_list -= src
	UnregisterSignal(src, COMSIG_MOVABLE_HEAR)
	..()

/obj/item/vamp/phone/attack_hand(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/vamp/phone/interact(mob/user)
	. = ..()
	ui_interact(user)

/obj/item/vamp/phone/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	if(closed)
		closed = FALSE
		icon_state = open_state
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface, interface)
		ui.open()

/obj/item/vamp/phone/AltClick(mob/user)
	if(can_fold && !closed)
		closed = TRUE
		icon_state = folded_state
		talking = FALSE
		if(online)
			online.online = null
			online.talking = FALSE
			online = null

/obj/item/vamp/phone/ui_data(mob/user)
	var/list/data = list()
	data["calling"] = FALSE
	if(last_call+100 > world.time && !talking)
		data["calling"] = TRUE

	data["online"] = online
	data["talking"] = talking
	data["my_number"] = choosed_number
	data["choosed_number"] = choosed_number
	if(online)
		data["calling_user"] = "(+1 707) [online.number]"
		for(var/datum/phonecontact/P in contacts)
			if(P.number == online.number)
				data["calling_user"] = P.name

	return data

/obj/item/vamp/phone/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("hang")
			last_call = 0
			if(talking)
				talking = FALSE
				if(online)
					online.talking = FALSE
			if(online)
				if(!silence)
					playsound(online, 'code/modules/wod13/sounds/phonestop.ogg', 25, FALSE)
				online.online = null
				online = null
			.= TRUE
		if("accept")
			if(online)
				talking = TRUE
				online.online = src
				online.talking = TRUE

				var/datum/phonehistory/NEWH_caller = new()
				var/datum/phonehistory/NEWH_being_called = new()

				//Being called History
				NEWH_being_called.name = "Unknown"
				for(var/datum/phonecontact/Contact in contacts)
					if(Contact.number == online.number)
						//Verify if they have a contact with the number if so, save their name
						NEWH_being_called.name = Contact.name
						break
				NEWH_being_called.number = online.number
				NEWH_being_called.time = "[SScity_time.timeofnight]"
				NEWH_being_called.call_type = "I accepted the call"
				phone_history_list += NEWH_being_called

				//Caller History
				NEWH_caller.name = "Unknown"
				for(var/datum/phonecontact/Contact in online.contacts)
					if(Contact.number == number)
						//Verify if they have a contact with the number if so, save their name
						NEWH_caller.name = Contact.name
						break
				NEWH_caller.number = number
				NEWH_caller.time = "[SScity_time.timeofnight]"
				NEWH_caller.call_type = "They accepted the call"
				online.phone_history_list += NEWH_caller
			.= TRUE
		if("decline")
			talking = FALSE
			if(online)

				if(!silence)
					playsound(online, 'code/modules/wod13/sounds/phonestop.ogg', 25, FALSE)
				online.talking = FALSE


				var/datum/phonehistory/NEWH_caller = new()
				var/datum/phonehistory/NEWH_being_called = new()

				//Being called History
				NEWH_being_called.name = "Unknown"
				for(var/datum/phonecontact/Contact in contacts)
					if(Contact.number == online.number)
						//Verify if they have a contact with the number if so, save their name
						NEWH_being_called.name = Contact.name
						break
				NEWH_being_called.number = online.number
				NEWH_being_called.time = "[SScity_time.timeofnight]"
				NEWH_being_called.call_type = "I declined the call"
				phone_history_list += NEWH_being_called

				//Caller History
				NEWH_caller.name = "Unknown"
				for(var/datum/phonecontact/Contact in online.contacts)
					if(Contact.number == number)
						//Verify if they have a contact with the number if so, save their name
						NEWH_caller.name = Contact.name
						break
				NEWH_caller.number = number
				NEWH_caller.time = "[SScity_time.timeofnight]"
				NEWH_caller.call_type = "They declined the call"
				online.phone_history_list += NEWH_caller

				online.online = null
				online = null

			.= TRUE
		if("call")
			choosed_number = replacetext(choosed_number, " ", "")
			for(var/obj/item/vamp/phone/PHN in GLOB.phones_list)
			//Loop through the Phone Global List
				if(PHN.number == choosed_number)
				// Verify if number wrote actually meets another PHN(Phone number) in the list
					blocked = FALSE // Not blocked YET.
					for(var/datum/phonecontact/BlockC in PHN.blocked_contacts)
					// Loop through the blocked numbers in the PHN Blocked LIST
						if(BlockC.number == number)
							// Verify if the caller has their number blocked by the PHN
							blocked = TRUE
							// If he is, Blocked is TRUE.
							to_chat(usr, "<span class='notice'>You have been blocked by this number.</span>")
							break
							// Stop loops once it is found
					if(!blocked)
					// If the Caller is not blocked and the PHN is flipped and they are not talking, then the call goes through.
						if(!PHN.online && !PHN.talking)
							last_call = world.time
							online = PHN
							PHN.online = src
							Recall(online, usr)
							var/datum/phonehistory/NEWH_caller = new()
							var/datum/phonehistory/NEWH_being_called = new()
							if(PHN.number == number)
								//Verify if you are calling yourself
								NEWH_caller.name = owner
								NEWH_caller.call_type = "I called myself"
								NEWH_caller.time = "[SScity_time.timeofnight]"
								NEWH_caller.number = number
								phone_history_list += NEWH_caller
							else
								//Caller History
								NEWH_caller.name = "Unknown"
								for(var/datum/phonecontact/Contact in contacts)
									if(Contact.number == PHN.number)
										//Verify if they have a contact with the number if so, save their name
										NEWH_caller.name = Contact.name
										break
								NEWH_caller.number = PHN.number
								NEWH_caller.time = "[SScity_time.timeofnight]"
								NEWH_caller.call_type = "I called"
								phone_history_list += NEWH_caller

								//Being Called History
								NEWH_being_called.name = "Unknown"
								for(var/datum/phonecontact/Contact in PHN.contacts)
									if(Contact.number == number)
										//Verify if they have a contact with the number if so, save their name
										NEWH_being_called.name = Contact.name
										break
								NEWH_being_called.number = number
								NEWH_being_called.time = "[SScity_time.timeofnight]"
								NEWH_being_called.call_type = "They called me"
								PHN.phone_history_list += NEWH_being_called
						else
							to_chat(usr, "<span class='notice'>Abonent is busy.</span>")
			if(!online && !blocked)
			// If the phone is not flipped or the phone user has left the city and they are not blocked.
				if(choosed_number == "#111")
					call_sound = 'code/modules/wod13/sounds/call.ogg'
					to_chat(usr, "<span class='notice'>Settings are now reset to default.</span>")
				else if(choosed_number == "#228")
					call_sound = 'code/modules/wod13/sounds/nokia.ogg'
					to_chat(usr, "<span class='notice'>Code activated.</span>")
				else if(choosed_number == "#666")
					call_sound = 'sound/mobs/humanoids/human/scream/malescream_6.ogg'
					to_chat(usr, "<span class='notice'>Code activated.</span>")
				else if(choosed_number == "#34")
					if(ishuman(usr))
						var/mob/living/carbon/human/H = usr
						H.emote("moan")
					to_chat(usr, "<span class='notice'>Code activated.</span>")
				else
					to_chat(usr, "<span class='notice'>Invalid number.</span>")
			.= TRUE
		if("contacts")
			var/list/options = list("Add","Remove","Choose","Block", "Unblock", "My Number", "Publish Number", "Published Numbers", "Call History", "Delete Call History")
			var/option =  tgui_input_list(usr, "Select an option", "Contacts Option", options)
			var/result
			switch(option)
				if("Publish Number")
					if (!islist(GLOB.published_numbers))
						GLOB.published_numbers = list()
					if (!islist(GLOB.published_number_names))
						GLOB.published_number_names = list()

					var/name = tgui_input_text(usr, "Input name", "Publish Number")
					if(name && src.number)
						name = trim(copytext_char(sanitize(name), 1, MAX_MESSAGE_LEN))
						if(src.number in GLOB.published_numbers)
							to_chat(usr, "<span class ='notice'>This number is already published.</span>")
						else
							GLOB.published_numbers += src.number
							GLOB.published_number_names += name
							to_chat(usr, "<span class='notice'>Your number is now published.</span>")
							for(var/obj/item/vamp/phone/PHN in GLOB.phones_list)
							//Gather all the Phones in the game to check if they got the toggle for published contacts
								if(PHN.toggle_published_contacts == TRUE)
							//If they got it, their published number will be added to those phones
									var/datum/phonecontact/NEWC = new()
									var/p_number = src.number
									NEWC.number = "[p_number]"
									NEWC.name = "[name]"
									if(NEWC.number != PHN.number)
										//Check if it is not your own number that you are adding to contacts
										var/GOT_CONTACT = FALSE
										for(var/datum/phonecontact/Contact in PHN.contacts)
											if(Contact.number == NEWC.number)
												//Check if the number is not already in your contact list
												GOT_CONTACT = TRUE
												break
										if(!GOT_CONTACT)
											PHN.contacts += NEWC
					else
						to_chat(usr, "<span class='notice'>You must input a name to publish your number.</span>")

				if ("Published Numbers")
					var/list_length = min(length(GLOB.published_numbers), length(GLOB.published_number_names))
					for(var/i = 1 to list_length)
						var/number = GLOB.published_numbers[i]
						var/display_number_first = copytext(number, 1, 4)
						var/display_number_second = copytext(number, 4, 8)
						var/split_number = display_number_first + " " + display_number_second
						var/name = GLOB.published_number_names[i]
						to_chat(usr, "- [name]: [split_number]")
				if("Add")
					var/new_contact = tgui_input_text(usr, "Input phone number", "Add Contact", null, 15)
					if(new_contact)
						var/datum/phonecontact/NEWC = new()
						new_contact = replacetext(new_contact, " ", "") //Removes spaces
						NEWC.number = "[new_contact]"
						contacts += NEWC
						var/new_contact_name = tgui_input_text(usr, "Input name", "Add Contact")
						if(new_contact_name)
							NEWC.name = "[new_contact_name]"
						else
							var/numbrr = length(contacts)+1
							NEWC.name = "Contact [numbrr]"
				if("Remove")
					var/list/removing = list()
					for(var/datum/phonecontact/CNT_REMOVE in contacts)
						if(CNT_REMOVE)
							removing += CNT_REMOVE.name
					if(length(removing) >= 1)
						result = tgui_input_list(usr, "Select a contact", "Contact Selection", sortList(removing))
						if(result)
							for(var/datum/phonecontact/CNT_REMOVE in contacts)
								if(CNT_REMOVE.name == result)
									contacts -= CNT_REMOVE
				if("Choose")
					var/list/personal_contacts = list()
					for(var/datum/phonecontact/CNTCT in contacts)
						if(CNTCT)
							personal_contacts += CNTCT.name
					if(length(personal_contacts) >= 1)
						result = tgui_input_list(usr, "Select a contact", "Contact Selection", sortList(personal_contacts))
						if(result)
							for(var/datum/phonecontact/CNTCT in contacts)
								if(CNTCT.name == result)
									if(CNTCT.number == "")
										CNTCT.check_global_contacts()
										if(CNTCT.number == "")
											to_chat(usr, "<span class='notice'>Sorry, [CNTCT.name] does not have a number.</span>")
									choosed_number = CNTCT.number
				if("Block")
					var/block_number = tgui_input_text(usr, "Input phone number", "Block Number")
					if(block_number)
						var/datum/phonecontact/BlockC = new()
						block_number = replacetext(block_number, " ", "") //Removes spaces
						BlockC.number = "[block_number]"
						blocked_contacts += BlockC
						var/block_contact_name = tgui_input_text(usr, "Input name", "Add name of the Blocked number")
						if(block_contact_name)
							BlockC.name = "[block_contact_name]"
						else
							var/number = length(blocked_contacts)+1
							BlockC.name = "Blocked [number]"
				if("Unblock")
					var/list/unblocking = list()
					for(var/datum/phonecontact/CNT_UNBLOCK in blocked_contacts)
						if(CNT_UNBLOCK)
							unblocking += CNT_UNBLOCK.name
					if(length(unblocking) >= 1)
						result = tgui_input_list(usr, "Select a blocked number", "Blocked Selection", sortList(unblocking))
						if(result)
							for(var/datum/phonecontact/CNT_UNBLOCK in blocked_contacts)
								if(CNT_UNBLOCK.name == result)
									blocked_contacts -= CNT_UNBLOCK
				if("Call History")
					if(phone_history_list.len > 0)
						for(var/datum/phonehistory/PH in phone_history_list)
							//loop through the phone_history_list searching for a phonehistory datums and display them.
							var/display_number_first = copytext(PH.number, 1, 4)
							var/display_number_second = copytext(PH.number, 4, 8)
							var/split_number = display_number_first + " " + display_number_second
							to_chat(usr, "# [PH.call_type]: [PH.name] , [split_number] at [PH.time]")
					else
						to_chat(usr, "You have no call history.") //PSEUDO_M return to fix all this
				if("Delete Call History")
					if(phone_history_list.len > 0)
						to_chat(usr, "Your total amount of history saved is: [phone_history_list.len]")
						var/number_of_deletions = tgui_input_number(usr, "Input the amount that you want to delete", "Deletion Amount", max_value = length(phone_history_list))
						//Delete the call history depending on the amount inputed by the User
						if(number_of_deletions > phone_history_list.len)
						// Verify if the requested amount in bigger than the history list.
							to_chat(usr, "You cannot delete more items than the history contains.")
						else
							for(var/i = 1 to number_of_deletions)
								//It will always delete the first item of the list, so the last logs are deleted first
								var/item_to_remove = phone_history_list[1]
								phone_history_list -= item_to_remove
						to_chat(usr, "[number_of_deletions] call history entries were deleted. Remaining: [phone_history_list.len]")

					else
						to_chat(usr, "You have no call history to delete it.")
				if("My Number")
					var/number_first_part = copytext(number, 1, 4)
					var/number_second_part = copytext(number, 4, 8)
					to_chat(usr, number_first_part + " " + number_second_part)
			.= TRUE
		if("settings")
			//Wrench Icon, more focused on toggles or later more complex options.
			var/list/options = list("Notifications and Sounds Toggle", "Published Numbers as Contacts Toggle")
			var/option =  tgui_input_list(usr, "Select a setting", "Settings Selection", options)
			switch(option)
				if("Notifications and Sounds Toggle")
					if(!silence)
						//If it is true, it will check all the other sounds for phone and disable them
						silence = TRUE
						to_chat(usr, "<span class='notice'>Notifications and Sounds toggled off.</span>")
					else
						silence = FALSE
						to_chat(usr, "<span class='notice'>Notifications and Sounds toggled on.</span>")
				if ("Published Numbers as Contacts Toggle")
					if(!toggle_published_contacts)
						var/contacts_added_lenght = published_numbers_contacts.len
						var/list_length = min(length(GLOB.published_numbers), length(GLOB.published_number_names))
						log_admin(contacts_added_lenght)
						log_admin(list_length)
						if(contacts_added_lenght < list_length)
						// checks the size difference between the GLOB published list and the phone published list
							var/ADDED_CONTACTS = 0
							to_chat(usr, "<span class='notice'>New contacts are being added to your contact list.</span>")
							for(var/i = 1 to list_length)
								var/number_v = GLOB.published_numbers[i]
								var/name_v = GLOB.published_number_names[i]
								var/datum/phonecontact/NEWC = new()
								NEWC.number = "[number_v]"
								NEWC.name = "[name_v]"
								if(NEWC.number != number)
									//Check if it is not your own number that you are adding to contacts
									var/GOT_CONTACT = FALSE
									for(var/datum/phonecontact/Contact in contacts)
									//Check if the number is not already in your contact list
										if(Contact.number == NEWC.number)
											GOT_CONTACT = TRUE
											break
									if(!GOT_CONTACT)
										contacts += NEWC
										published_numbers_contacts += NEWC
										ADDED_CONTACTS +=1
							if(ADDED_CONTACTS > 1)
								to_chat(usr, "<span class='notice'>New contacts are added to your contact list.</span>")
						else if(contacts_added_lenght == list_length)
							to_chat(usr, "<span class='notice'>You have all the contacts in the published list already.</span>")
						toggle_published_contacts = TRUE
						to_chat(usr, "<span class='notice'>The toggle of the published numbers in contacts is active.</span>")
					else
						toggle_published_contacts = FALSE
						to_chat(usr, "<span class='notice'>The toggle of the published numbers in contacts is disabled.</span>")
			.= TRUE
		if("keypad")
			if(!silence)
				playsound(loc, 'sound/machines/terminal_select.ogg', 15, TRUE)
			switch(params["value"])
				if("C")
					choosed_number = ""
					.= TRUE
					return
				if("_")
					choosed_number += " "
					.= TRUE
					return

			choosed_number += params["value"]
			.= TRUE

	return FALSE


/obj/item/vamp/phone/proc/add_important_contacts()
	var/mob/living/L
	if(isliving(loc))
		L = loc
	for(var/datum/phonecontact/PHNCNTCT in contacts)
		if(PHNCNTCT)
			if(PHNCNTCT.check_global_contacts())
				if(L)
					to_chat(L, "<span class='notice'>Some important contacts in your phone work again.</span>")

/obj/item/vamp/phone/proc/Recall(var/obj/item/vamp/phone/abonent, var/mob/usar)
	if(last_call+100 <= world.time && !talking)
		last_call = 0
		if(online)
			if(online.silence == FALSE)
				playsound(src, 'code/modules/wod13/sounds/phonestop.ogg', 25, FALSE)
			online.online = null
			online = null
	if(!talking && online)
		if(online.silence == FALSE)
			playsound(src, 'code/modules/wod13/sounds/phone.ogg', 10, FALSE)
			playsound(online, online.call_sound, 25, FALSE)
		addtimer(CALLBACK(src, PROC_REF(Recall), online, usar), 20)

/obj/item/vamp/phone/proc/handle_hearing(datum/source, list/hearing_args)
	var/message = hearing_args[HEARING_RAW_MESSAGE]
	if(online && talking)
		if(hearing_args[HEARING_SPEAKER])
			if(isliving(hearing_args[HEARING_SPEAKER]))
				var/voice_saying = "unknown voice"
				var/spchspn = SPAN_ROBOT
				switch(get_dist(src, hearing_args[HEARING_SPEAKER]))
					if(3 to INFINITY)
						return
					if(1 to 2)
						spchspn = "small"
					else
						spchspn = SPAN_ROBOT
				if(ishuman(hearing_args[HEARING_SPEAKER]))
					var/mob/living/carbon/human/SPK = hearing_args[HEARING_SPEAKER]
					voice_saying = "[age2agedescription(SPK.age)] [SPK.gender] voice ([SPK.phonevoicetag])"

					if(SPK.clane?.name == "Lasombra")
						message = scramble_lasombra_message(message,SPK)
						playsound(src, 'code/modules/wod13/sounds/lasombra_whisper.ogg', 5, FALSE, ignore_walls = FALSE)
					else
						playsound(online, 'code/modules/wod13/sounds/phonetalk.ogg', 50, FALSE)
				var/obj/phonevoice/VOIC = new(online)
				VOIC.name = voice_saying
				VOIC.speech_span = spchspn
				VOIC.say("[message]")
				qdel(VOIC)

/obj/item/vamp/phone/street
	desc = "An ordinary street payphone"
	icon = 'code/modules/wod13/props.dmi'
	onflooricon = 'code/modules/wod13/props.dmi'
	icon_state = "payphone"
	anchored = TRUE
	number = "1447"
	can_fold = 0

	/// Phone icon states
	open_state = "payphone"
	closed_state = "payphone"
	folded_state = "payphone"

/obj/item/vamp/phone/clean
	desc = "The usual phone of a cleaning company used to communicate with employees"
	icon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "redphone"
	anchored = TRUE
	number = "700 4424"
	can_fold = 0

	open_state = "redphone"
	closed_state = "redphone"
	folded_state = "redphone"

/obj/item/vamp/phone/emergency
	desc = "The 911 dispatch phone"
	icon = 'code/modules/wod13/onfloor.dmi'
	icon_state = "redphone"
	anchored = TRUE
	number = "911"
	can_fold = 0
	open_state = "redphone"
	closed_state = "redphone"
	folded_state = "redphone"
	var/obj/machinery/p25transceiver/clinic_transciever
	var/obj/machinery/p25transceiver/police_transciever

/obj/item/vamp/phone/emergency/Initialize()
	. = ..()
	GLOB.phone_numbers_list += number
	GLOB.phones_list += src

/obj/item/vamp/phone/clean/Initialize()
	. = ..()
	GLOB.phone_numbers_list += number
	GLOB.phones_list += src

/// Phone Types

/obj/item/vamp/phone/prince
	exchange_num = 267

/obj/item/vamp/phone/prince/Initialize()
	..()
	GLOB.princenumber = number
	GLOB.princename = owner
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/dealer/DEALER = new()
	contacts += DEALER
	var/datum/phonecontact/harpy/H = new()
	contacts += H
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/voivode/Z = new()
	contacts += Z

/obj/item/vamp/phone/sheriff
	exchange_num = 267

/obj/item/vamp/phone/sheriff/Initialize()
	..()
	GLOB.sheriffnumber = number
	GLOB.sheriffname = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/dealer/DEALER = new()
	contacts += DEALER
	var/datum/phonecontact/harpy/H = new()
	contacts += H
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/voivode/Z = new()
	contacts += Z

/obj/item/vamp/phone/clerk
	exchange_num = 267

/obj/item/vamp/phone/clerk/Initialize()
	..()
	GLOB.clerknumber = number
	GLOB.clerkname = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/dealer/DEALER = new()
	contacts += DEALER
	var/datum/phonecontact/harpy/H = new()
	contacts += H
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/voivode/Z = new()
	contacts += Z

/obj/item/vamp/phone/barkeeper
	exchange_num = 485

/obj/item/vamp/phone/barkeeper/Initialize()
	..()
	GLOB.barkeepernumber = number
	GLOB.barkeepername = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/dealer/DEALER = new()
	contacts += DEALER
	var/datum/phonecontact/voivode/Z = new()
	contacts += Z

/obj/item/vamp/phone/dealer
	exchange_num = 485

/obj/item/vamp/phone/dealer/Initialize()
	..()
	GLOB.dealernumber = number
	GLOB.dealername = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER

/obj/item/vamp/phone/supply_tech/Initialize()
	..()
	var/datum/phonecontact/dealer/DEALER = new()
	contacts += DEALER

/obj/item/vamp/phone/camarilla
	exchange_num = 267

/obj/item/vamp/phone/camarilla/Initialize()
	..()
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/harpy/H = new()
	contacts += H

/obj/item/vamp/phone/anarch
	exchange_num = 485

/obj/item/vamp/phone/anarch/Initialize()
	..()
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER

/obj/item/vamp/phone/malkavian/Initialize()
	..()
	GLOB.malkaviannumber = number
	GLOB.malkavianname = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/harpy/H = new()
	contacts += H

/obj/item/vamp/phone/nosferatu/Initialize()
	..()
	GLOB.nosferatunumber = number
	GLOB.nosferatuname = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/harpy/H = new()
	contacts += H

/obj/item/vamp/phone/toreador/Initialize()
	..()
	GLOB.toreadornumber = number
	GLOB.toreadorname = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/harpy/H = new()
	contacts += H

/obj/item/vamp/phone/ventrue/Initialize()
	..()
	GLOB.ventruenumber = number
	GLOB.ventruename = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/harpy/H = new()
	contacts += H

/obj/item/vamp/phone/tremere/Initialize()
	..()
	GLOB.tremerenumber = number
	GLOB.tremerename = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/harpy/H = new()
	contacts += H

/obj/item/vamp/phone/archivist/Initialize()
	..()
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT

/obj/item/vamp/phone/lasombra/Initialize()
	..()
	GLOB.lasombranumber = number
	GLOB.lasombraname = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/harpy/H = new()
	contacts += H

/obj/item/vamp/phone/banu/Initialize()
	..()
	GLOB.banunumber = number
	GLOB.banuname = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
	var/datum/phonecontact/harpy/H = new()
	contacts += H


/obj/item/vamp/phone/voivode/Initialize()
	..()
	GLOB.voivodenumber = number
	GLOB.voivodename = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/sheriff/SHERIFF = new()
	contacts += SHERIFF
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER
	var/datum/phonecontact/harpy/H = new()
	contacts += H

/obj/item/vamp/phone/harpy/Initialize()
	..()
	GLOB.harpynumber = number
	GLOB.harpyname = owner
	var/datum/phonecontact/prince/PRINCE = new()
	contacts += PRINCE
	var/datum/phonecontact/clerk/CLERK = new()
	contacts += CLERK
	var/datum/phonecontact/dealer/DEALER = new()
	contacts += DEALER
	var/datum/phonecontact/tremere/REGENT = new()
	contacts += REGENT
	var/datum/phonecontact/barkeeper/BARKEEPER = new()
	contacts += BARKEEPER
	var/datum/phonecontact/malkavian/M = new()
	contacts += M
	var/datum/phonecontact/nosferatu/N = new()
	contacts += N
	var/datum/phonecontact/toreador/T = new()
	contacts += T
	var/datum/phonecontact/lasombra/L = new()
	contacts += L
	var/datum/phonecontact/banu/B = new()
	contacts += B
	var/datum/phonecontact/voivode/Z = new()
	contacts += Z
	var/datum/phonecontact/ventrue/V = new()
	contacts += V
