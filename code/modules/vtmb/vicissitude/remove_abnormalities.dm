/datum/surgery/remove_abnormalities
	name = "Remove Abnormalities"
	steps = list(/datum/surgery_step/incise,
				/datum/surgery_step/clamp_bleeders,
				/datum/surgery_step/retract_skin,
				/datum/surgery_step/remove_abnormality,
				/datum/surgery_step/close)

	possible_locs = list(BODY_ZONE_CHEST)
	self_operable = TRUE

/datum/surgery/remove_abnormalities/can_start(mob/user, mob/living/carbon/target)
	if(!ishuman(target))
		return FALSE
	if(!iskindred(user))
		return FALSE
	var/mob/living/carbon/human/surgeon = user
	var/datum/species/kindred/surgeon_species = surgeon.dna.species
	var/datum/discipline/surgeon_vicissitude = surgeon_species.get_discipline(/datum/discipline/vicissitude)
	if(!surgeon_vicissitude)
		return FALSE
	if(surgeon_vicissitude.level > 1)
		return TRUE
	return FALSE

/datum/surgery_step/remove_abnormality
	name = "Sever abnormal flesh"
	implements = list(TOOL_SCALPEL = 100)
	time = 64

/datum/surgery_step/remove_abnormality/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, "<span class='notice'>You begin to remove any abnormalities present on [target]...</span>",
		"<span class='notice'>[user] begins to remove any abnormalities present on [target].</span>",
		"<span class='notice'>[user] begins to remove any abnormalities present on [target].</span>")

/datum/surgery_step/remove_abnormality/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, "<span class='notice'>You finish removing abnormalities from [target]!</span>",
		"<span class='notice'>[user] succeeds!</span>",
		"<span class='notice'>[user] finishes.</span>")
	var/mob/living/carbon/human/victim = target
	victim.remove_overlay(UNICORN_LAYER)
	return TRUE
