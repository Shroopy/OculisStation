#define SUBTLE_RANGE 1

/datum/emote/living/subtle
	key = "subtle"
	key_third_person = "subtle"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)

/datum/emote/living/subtle/run_emote(mob/user, params, type_override, intentional)
	if(!can_run_emote(user))
		to_chat(user, span_warning("You can't emote at this time."))
		return FALSE
	var/subtle_message
	var/subtle_emote = params
	if(SSdbcore.IsConnected() && is_banned_from(user, "emote"))
		to_chat(user, "You cannot send subtle emotes (banned).")
		return FALSE
	else if(user.client?.prefs.muted & MUTE_IC)
		to_chat(user, "You cannot send IC messages (muted).")
		return FALSE
	else if(!params)
		subtle_emote = tgui_input_text(user, "Choose an emote to display.", "Subtle", null, max_length = MAX_MESSAGE_LEN, multiline = TRUE)
		if(!subtle_emote)
			return FALSE
		subtle_message = subtle_emote
	else
		subtle_message = params

	var/running_emote_type = type_override || emote_type

	if(!can_run_emote(user))
		to_chat(user, span_warning("You can't emote at this time."))
		return FALSE

	user.log_message(subtle_message, LOG_SUBTLE)

	var/space = should_have_space_before_emote(html_decode(subtle_emote)[1]) ? " " : ""

	subtle_message = span_subtle("<b>[user]</b>[space]<i>[user.apply_message_emphasis(subtle_message)]</i>")

	var/list/viewers = get_hearers_in_view(SUBTLE_RANGE, user)

	var/obj/effect/overlay/holo_pad_hologram/hologram = GLOB.hologram_impersonators[user]
	if(hologram)
		viewers |= get_hearers_in_view(SUBTLE_RANGE, hologram)
	for(var/obj/item/dullahan_relay/dullahan in viewers)
		viewers -= dullahan
		viewers += dullahan.owner

	for(var/obj/effect/overlay/holo_pad_hologram/iterating_hologram in viewers)
		if(iterating_hologram?.Impersonation?.client)
			viewers |= iterating_hologram.Impersonation

	for(var/mob/ghost as anything in GLOB.dead_mob_list)
		if((ghost.client?.prefs.chat_toggles & CHAT_GHOSTSIGHT) && !(ghost in viewers))
			to_chat(ghost, "[FOLLOW_LINK(ghost, user)] [subtle_message]")

	for(var/mob/receiver in viewers)
		receiver.show_message(subtle_message, alt_msg = subtle_message)

	return TRUE

/*
*	VERB CODE
*/

/mob/living/proc/subtle_keybind()
	var/message = input(src, "", "subtle") as text|null
	if(!length(message))
		return
	return subtle(message)

/mob/living/verb/subtle()
	set name = "Subtle"
	set category = "IC"
	if(GLOB.say_disabled)	// This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return
	usr.emote("subtle")

#undef SUBTLE_RANGE
