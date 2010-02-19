import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place
import XMonad.Hooks.ManageHelpers
import XMonad.Util.CustomKeys
import XMonad.Util.EZConfig
import XMonad.Layout.Magnifier
main = xmonad $ defaultConfig
		{ terminal						  = "urxvt"
		, modMask								= mod4Mask --rebind Mod to Windows Key
		, manageHook						= myManageHook 
		, layoutHook						= myLayoutHook 
		, focusedBorderColor    = "#ee9a00"
		, startupHook						= startup
		}
		`additionalKeys`
		[ ((mod4Mask, xK_p), spawn "exe=`dmenu_path | /usr/bin/yeganesh -- -i -b -sb orange -nb black -nf grey` && eval \"exec $exe\"")  
		, ((mod4Mask, xK_q),spawn "killall stalonetray xmobar" >> restart "xmonad" True)
--		, ((0, 0x1008ff13 ), spawn "amixer set Master 1+ unmute")
--		, ((0, 0x1008ff11 ), spawn "amixer set Master 1- unmute")
--		, ((0, 0x1008ff12 ), spawn "amixer set Master toggle")
		, ((0, 0x1008ff59 ), spawn "sudo pm-suspend")
		, ((0, 0x1008ff2a ), spawn "sudo halt")
		, ((mod4Mask , xK_m    ), sendMessage Toggle   )
	]
myLayoutHook = avoidStruts . smartBorders . maximizeVertical  $ layoutHook defaultConfig

myManageHook = composeAll $ 
	[ resource =? name --> doIgnore | name <- ignore ]
	++[ title =? name --> doCenterFloat | name <- floaters ]
	++[ resource =? name --> doCenterFloat | name <- floaters ]
	++[ manageDocks <+> manageHook defaultConfig
		,(isFullscreen --> doFullFloat) --full float fullscreen flash
		]
--	++[ resource =? name --> doFloat | name <- floaters ]
	where
		floaters = ["xcalc", "glut", "yakuake"]
		ignore = ["stalonetray"]
					 
startup :: X ()
startup = do
	spawn "xmobar"
	spawn "stalonetray"
