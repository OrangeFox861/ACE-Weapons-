


ACE_DefineMine( "TM 62 AT Mine", {

    name           = "TM 62 AT Mine",
    model          = "models/props_phx/games/chess/black_dama.mdl",
    material       = "models/props_canal/metalwall005b",
    color          = Color(227,255,135),
    weight         = 12,

    heweight       = 75,
    fragmass       = 5,
    armdelay       = 2,

    setrange       = 1,

    -- the trigger zone.
    triggermins    = Vector( -10, -10, -10 ),
    triggermaxs    = Vector( 10, 10, 10 ),

    digdepth       = 0,
    ignoreplayers  = true,

} )

ACE_DefineMine( "PMN AP mine", {

    name           = "PMN AP mine",
    model          = "models/dav0r/buttons/button.mdl",
    material       = "models/props_canal/metalwall005b",
    color          = Color(227,255,135),
    weight         = 1,

    heweight       = 0.1,
    fragmass       = 2,
    armdelay       = 2,

    setrange       = 10,

    -- the trigger zone.
    triggermins    = Vector( -9, -9, -9 ),
    triggermaxs    = Vector( 9, 9, 9 ),

    digdepth       = 1.5 ,
    ignoreplayers  = false,

} )

ACE_DefineMine( "VS-50 AP mine", {

    name           = "VS-50 AP mine",
    model          = "models/xqm/button1.mdl",
    material       = "models/props_c17/FurnitureMetal001a",
    color          = Color(255,255,255),
    weight         = 1,

    heweight       = 0.005,
    fragmass       = 1,
    armdelay       = 2,

    setrange       = 10,

    -- the trigger zone.
    triggermins    = Vector( -3, -3, -3 ),
    triggermaxs    = Vector( 3, 3, 3 ),

    digdepth       = 0 ,
    ignoreplayers  = false,

} )