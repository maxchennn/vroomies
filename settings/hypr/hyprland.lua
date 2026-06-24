-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
local colors = require("colors")


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "qs -p ~/.config/quickshell/components/Launcher/Luna.qml"
local browser     = "firefox"
local wall        = "bash ~/.config/quickshell/compnents/wall/wall.sh"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function ()
   hl.exec_cmd("kdeconnect-cli")
   hl.exec_cmd("nm-applet")
   hl.exec_cmd("awww-daemon ; sleep 0.5 ; awww img ~/.config/hypr/current_wallpaper")
   hl.exec_cmd("waybar")
   hl.exec_cmd("mako")
   hl.exec_cmd("quickshell")
   hl.exec_cmd("blueman-applet")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")


-----------------------
----- PERMISSIONS -----
-----------------------

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,

        border_size = 2,

        col = {
           active_border   = colors.primary,
           inactive_border = colors.secondary,
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})


-- ── Bezier Curves ──
hl.curve("md3_decel",   { type = "bezier", points = { {0.05, 0.7}, {0.1, 1}    } })
hl.curve("md3_accel",   { type = "bezier", points = { {0.3, 0},   {0.8, 0.15} } })
hl.curve("menu_decel",  { type = "bezier", points = { {0.1, 1},   {0, 1}      } })
hl.curve("menu_accel",  { type = "bezier", points = { {0.38, 0.04}, {1, 0.07} } })
hl.curve("almostLinear",{ type = "bezier", points = { {0.5, 0.5}, {0.75, 1}   } })
hl.curve("linear",      { type = "bezier", points = { {0, 0},     {1, 1}      } })
hl.curve("harmony",     { type = "bezier", points = { {0.2, 0.9}, {0.2, 1.0}  } })

-- ── Animations ──
-- Windows: md3_decel + popin (end.conf'tan, en akıcı)
hl.animation({ leaf = "windows",    enabled = true, speed = 3,   bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 3,   bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2,   bezier = "md3_accel", style = "popin 60%" })

-- Border
hl.animation({ leaf = "border",     enabled = true, speed = 10,  bezier = "default" })

-- Fade: harmony'den, sade
hl.animation({ leaf = "fadeIn",         enabled = true, speed = 2,   bezier = "harmony" })
hl.animation({ leaf = "fadeOut",        enabled = true, speed = 2,   bezier = "harmony" })
hl.animation({ leaf = "fade",           enabled = true, speed = 2,   bezier = "harmony" })

-- Layers: end.conf panel açılışı
hl.animation({ leaf = "layersIn",       enabled = true, speed = 3,   bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "layersOut",      enabled = true, speed = 1.6, bezier = "menu_accel" })
hl.animation({ leaf = "fadeLayersIn",   enabled = true, speed = 2,   bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut",  enabled = true, speed = 4.5, bezier = "menu_accel" })

-- Workspaces: end.conf slide
hl.animation({ leaf = "workspaces",     enabled = true, speed = 7,   bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "workspacesIn",   enabled = true, speed = 7,   bezier = "menu_decel", style = "slide" })
hl.animation({ leaf = "workspacesOut",  enabled = true, speed = 7,   bezier = "menu_decel", style = "slide" })

-- Special workspace: slidevert
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "md3_decel", style = "slidevert" })


hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "tr",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace"
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return",       hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q",    hl.dsp.window.close())
hl.bind(mainMod .. " + W",            hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + E",    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F",            hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + Print",              hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mainMod .. " + D",            hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + A",    hl.dsp.exec_cmd("bash ~/.config/quickshell/components/wall/wall.sh"))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
