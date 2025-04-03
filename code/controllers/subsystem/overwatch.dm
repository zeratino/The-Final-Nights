SUBSYSTEM_DEF(overwatch)
	name = "Overwatch"
	flags = SS_NO_INIT | SS_NO_FIRE

/datum/controller/subsystem/overwatch/proc/record_action(client/source, message)
	if(!CONFIG_GET(flag/discord_overwatch))
		return

	var/webhook = CONFIG_GET(string/discord_overwatch_webhook)

	var/list/webhook_info = list()

	var/datum/discord_embed/embed = format_embed_overwatch(source, message)
	webhook_info["embeds"] = list(embed.convert_to_list())
	if(embed.content)
		webhook_info["content"] = embed.content

	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_POST, webhook, json_encode(webhook_info), headers, "tmp/response.json")
	request.begin_async()

/datum/controller/subsystem/overwatch/proc/format_embed_overwatch(client/source, message)
	RETURN_TYPE(/datum/discord_embed)
	PRIVATE_PROC(TRUE)

	var/datum/discord_embed/embed = new()
	embed.title = "OVERWATCH"
	embed.description = "OVERWATCH"
	embed.author = key_name(source)

	if(source.holder)
		embed.description += " - Admin Action"
	else
		embed.description += " - Player Action"

	var/list/admin_counts = get_admin_counts(R_BAN)
	var/stealth_admins = jointext(admin_counts["stealth"], ", ")
	var/afk_admins = jointext(admin_counts["afk"], ", ")
	var/other_admins = jointext(admin_counts["noflags"], ", ")
	var/admin_text = ""
	var/player_count = "**Total Clients**: [length(GLOB.clients)], **Player Mobs**: [length(GLOB.player_list)]"

	if(stealth_admins)
		admin_text += "**Stealthed**: [stealth_admins]\n"
	if(afk_admins)
		admin_text += "**AFK**: [afk_admins]\n"
	if(other_admins)
		admin_text += "**Lacks +BAN**: [other_admins]\n"

	embed.fields = list(
		"CKEY" = key_name(source, include_link = FALSE),
		"PLAYERS" = player_count,
		"ROUND ID" = GLOB.round_id,
		"ROUND TIME" = ROUND_TIME(),
		"ADMINS" = admin_text,
		"MESSAGE" = message,
	)

	return embed
