/**
 * Generation defines
 * Higher = weaker
 * Lower = stronger
 */

/// Limit for highest generation possible
#define HIGHEST_GENERATION_LIMIT 14
/// Limit for lowest generation possible
#define LOWEST_GENERATION_LIMIT 7
/// Limit for public generation bonus
#define MAX_GENERATION_BONUS 3
/// Limit for trusted player generation bonus
#define MAX_TRUSTED_GENERATION_BONUS 5
/// Limit for lowest public generation
#define MAX_PUBLIC_GENERATION 10
/// Limit for lowest trusted player generation
#define MAX_TRUSTED_GENERATION 8
/// The default generation everyone begins at
#define DEFAULT_GENERATION 13

/**
 * Clan defines
 */

#define CLAN_NONE "Caitiff"
#define CLAN_BRUJAH "Brujah"
#define CLAN_TOREADOR "Toreador"
#define CLAN_NOSFERATU "Nosferatu"
#define CLAN_TREMERE "Tremere"
#define CLAN_GANGREL "Gangrel"
#define CLAN_VENTRUE "Ventrue"
#define CLAN_MALKAVIAN "Malkavian"
#define CLAN_TZIMISCE "Tzimisce"
#define CLAN_TRUE_BRUJAH "True Brujah"
#define CLAN_OLD_TZIMISCE "Old Clan Tzimisce"
#define CLAN_SALUBRI "Salubri"
#define CLAN_BAALI "Baali"
#define CLAN_KIASYD "Kiasyd"
#define CLAN_LASOMBRA "Lasombra"
#define CLAN_SETITES "Ministry"
#define CLAN_BANU_HAQIM "Banu Haqim"
#define CLAN_GIOVANNI "Giovanni"
#define CLAN_GARGOYLE "Gargoyle"
#define CLAN_DAUGHTERS_OF_CACOPHONY "Daughters of Cacophony"
#define CLAN_CAPPADOCIAN "Cappadocian"

/**
 * Auspex aura defines
 */

#define AURA_MORTAL_DISARM "#2222ff"
#define AURA_MORTAL_HELP "#22ff22"
#define AURA_MORTAL_GRAB  "#ffff22"
#define AURA_MORTAL_HARM "#ff2222"
#define AURA_UNDEAD_DISARM "#BBBBff"
#define AURA_UNDEAD_HELP "#BBffBB"
#define AURA_UNDEAD_GRAB  "#ffffBB"
#define AURA_UNDEAD_HARM "#ffBBBB"
#define AURA_GAROU "aura_bright"
#define AURA_GHOUL "aura_ghoul"
#define AURA_TRUE_FAITH "#ffe12f"

/**
 * Morality defines
 */

#define MIN_PATH_SCORE 1
#define MAX_PATH_SCORE 10

// Very simplified version of virtues
#define MORALITY_HUMANITY "morality_humanity"
#define MORALITY_ENLIGHTENMENT "morality_enlightenment"

// Bearings
#define BEARING_MUNDANE (1<<0)
#define BEARING_RESOLVE (1<<1)
#define BEARING_JUSTICE (1<<2)
#define BEARING_INHUMANITY (1<<3)
#define BEARING_COMMAND (1<<4)
#define BEARING_INTELLECT (1<<5)
#define BEARING_DEVOTION (1<<6)
#define BEARING_HOLINESS (1<<7)
#define BEARING_SILENCE (1<<8)
#define BEARING_MENACE (1<<9)
#define BEARING_FAITH (1<<10)
#define BEARING_GUILT (1<<11)

// Path hits
#define PATH_SCORE_DOWN -1
#define PATH_SCORE_UP 1

// Path hit signals
#define COMSIG_PATH_HIT "path_hit"

// Path cooldowns
#define COOLDOWN_PATH_HIT "path_hit_cooldown"

/**
 * Area defines
 */

#define isMasqueradeEnforced(A) (isarea(A) && A.zone_type == "masquerade")

/**
 * Whitelist defines
 */

#define TRUSTED_PLAYER "trusted_player"




/**
 * Cooldown defines
 */

// Rituals
#define COOLDOWN_RITUAL_INVOKE "ritual_invoke"

