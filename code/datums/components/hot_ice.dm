/datum/component/hot_ice
	var/gas_name
	var/gas_amount
	var/temp_amount

/datum/component/hot_ice/Initialize(gas_name, gas_amount, temp_amount)

	src.gas_name = gas_name
	src.gas_amount = gas_amount
	src.temp_amount = temp_amount

	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(attackby_react))
	RegisterSignal(parent, COMSIG_ATOM_FIRE_ACT, PROC_REF(flame_react))

/datum/component/hot_ice/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_PARENT_ATTACKBY)
	UnregisterSignal(parent, COMSIG_ATOM_FIRE_ACT)

/datum/component/hot_ice/proc/hot_ice_melt(mob/user)
	if(isturf(parent))
		var/turf/K = parent
		K.ScrapeAway(1, CHANGETURF_INHERIT_AIR)
	else
		qdel(parent)

/datum/component/hot_ice/proc/flame_react(datum/source, exposed_temperature, exposed_volume)
	SIGNAL_HANDLER

	if(exposed_temperature > T0C + 100)
		hot_ice_melt()

/datum/component/hot_ice/proc/attackby_react(datum/source, obj/item/thing, mob/user, params)
	SIGNAL_HANDLER

	if(thing.get_temperature())
		hot_ice_melt(user)
