import XMonad hiding ( (|||), Tall )
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place
import XMonad.Hooks.ManageHelpers
import XMonad.Util.CustomKeys
import XMonad.Util.EZConfig
import XMonad.Layout.Magnifier as Mag
import XMonad.Layout.BoringWindows
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.SimpleFloat
import XMonad.Layout.DragPane
import XMonad.Layout.TwoPane
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Tabbed
import Data.Monoid
import XMonad.Layout.Named
import XMonad.Actions.CycleSelectedLayouts as Cycle
import XMonad.Actions.RotSlaves
import XMonad.Layout.WindowNavigation

main = xmonad $ defaultConfig
		{ terminal						  = "cat ~/.cwd | xargs urxvt -cd"
		, modMask								= mod4Mask --rebind Mod to Windows Key
		, manageHook						= myManageHook 
		, layoutHook						= myLayoutHook 
		, focusedBorderColor    = "#ee9a00"
		, normalBorderColor			= "#000000"
		, startupHook						= startup
		}
		`additionalKeys`
		[ ((mod4Mask, xK_p), spawn "exe=`dmenu_path | /usr/bin/yeganesh -- -i -b -sb orange -nb black -nf grey` && eval \"exec $exe\"")  
		, ((mod4Mask, xK_o),spawn "/usr/bin/dmenu_run -i -b -sb red -nb grey")  
		, ((mod4Mask, xK_i),spawn "exe=`dmenu_path | /usr/bin/sudo /usr/bin/yeganesh --profile=sudo -- -i -b -sb black -nb yellow` && eval \"exec $exe\"")  
		, ((mod4Mask, xK_q),spawn "killall stalonetray xmobar" >> restart "xmonad" True)
		, ((0, 0x1008ff13 ), spawn "amixer set Master 1+")
		, ((0, 0x1008ff11 ), spawn "amixer set Master 1-")
		, ((0, 0x1008ff12 ), spawn "amixer set Master toggle")
--		, ((0, 0x1008ff59 ), spawn "sudo pm-suspend")
		, ((0, 0x1008ff59 ), spawn "xset dpms force off")
--  	, ((0, 0x1008ff2f ), spawn "xset dpms force off")
		, ((0, 0x1008ff2a ), spawn "sudo halt")
		, ((mod4Mask, xK_m    ), sendMessage Mag.Toggle   )
--		, ((mod4Mask, xK_f    ), fullFloatFocused)
		, ((mod4Mask, xK_g    ), Cycle.cycleThroughLayouts ["gimp layout", "default"])
		, ((mod4Mask, xK_r    ), Cycle.cycleThroughLayouts ["pdf layout", "default"])
	  , ((mod4Mask, xK_space), Cycle.cycleThroughLayouts ["full", "default"])
	  , ((mod4Mask, xK_d    ), Cycle.cycleThroughLayouts ["two pane", "default"])
	  , ((mod4Mask, xK_s    ), rotSlavesUp )
	  , ((mod4Mask, xK_f    ), sendMessage ToggleStruts)
    , ((mod4Mask, xK_m    ), spawn "xcalib -invert -alter")
	  , ((mod4Mask,  xK_w),  sendMessage Mag.Toggle )
--		, ((mod4Mask, xK_backslash), withFocused (sendMessage . maximizeRestore))
	  , ((mod4Mask,                 xK_Right), sendMessage $ Go R)
	  , ((mod4Mask,                 xK_Left ), sendMessage $ Go L)
	  , ((mod4Mask,                 xK_Up   ), sendMessage $ Go U)
	  , ((mod4Mask,                 xK_Down ), sendMessage $ Go D)
	  , ((mod4Mask .|. shiftMask, xK_Right), sendMessage $ Swap R)
	  , ((mod4Mask .|. shiftMask, xK_Left ), sendMessage $ Swap L)
	  , ((mod4Mask .|. shiftMask, xK_Up   ), sendMessage $ Swap U)
	  , ((mod4Mask .|. shiftMask, xK_Down ), sendMessage $ Swap D)
	]

myLayoutHook = windowNavigation . avoidStruts . smartBorders $ (named "default" mouseResizableTile ||| named "two pane" (TwoPane (3/100) (1/2) ) |||  named "full" Full ||| gimpLayout ||| pdfLayout)
	where
	gimpLayout = named "gimp layout" (simpleTabbed ****||* simpleTabbed)
	pdfLayout = named "pdf layout" (simpleTabbed *||* mouseResizableTile)

myManageHook = composeAll $ 
	[ resource =? name --> doIgnore | name <- ignore ]
	++[ title =? name --> doCenterFloat | name <- floaters ]
	++[ resource =? name --> doCenterFloat | name <- floaters ]
	++[ manageDocks <+> manageHook defaultConfig
		,(isFullscreen --> doFullFloat) --full float fullscreen flash
		]
	where
		floaters = ["xmos2print","xcalc", "galculator", "gcalctool"]
		ignore = ["stalonetray"]
					 
startup :: X ()
startup = do
	spawn "xmobar"
	spawn "stalonetray"
	spawn "dbus-launch nm-applet --sm-disable"
