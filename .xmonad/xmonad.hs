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
import XMonad.Layout.SimplestFloat
import XMonad.Util.Replace
import XMonad.StackSet hiding (focus, workspaces) --for RationalRect

main = do
		replace
		xmonad $ defaultConfig { terminal						  = "urxvt -cd `cat ~/.cwd`"
			--{ terminal						  = "cat ~/.cwd | xargs urxvt -cd"
			, modMask								= mod4Mask --rebind Mod to Windows Key
			, manageHook						= myManageHook 
			, layoutHook						= myLayoutHook 
			, focusedBorderColor    = "#ee9a00"
			, normalBorderColor			= "#000000"
			, startupHook						= startup
			} `additionalKeys`
				[ ((mod4Mask, xK_p), spawn "exe=`IFS+:; stest =flx ${PATH} | /usr/bin/yeganesh -- -i -b -sb orange -nb black -nf grey` && eval \"exec $exe\"")  
  			  , ((mod4Mask, xK_o),spawn "urxvt -e vim")
					, ((mod4Mask, xK_q),spawn "killall stalonetray xmobar" >> restart "xmonad" True)
					, ((mod4Mask, xK_b),spawn "firefox")
					, ((0, 0x1008ff13 ), spawn "amixer set Master 1+")
					, ((0, 0x1008ff11 ), spawn "amixer set Master 1-")
					, ((0, 0x1008ff12 ), spawn "amixer set Master toggle")
--					, ((0, 0x1008ff59 ), spawn "sudo pm-suspend")
					, ((0, 0x1008ff59 ), spawn "xset dpms force off")
--			  	, ((0, 0x1008ff2f ), spawn "xset dpms force off")
					, ((0, 0x1008ff2a ), spawn "sudo halt")
					, ((mod4Mask, xK_m    ), sendMessage Mag.Toggle   )
--					, ((mod4Mask, xK_f    ), fullFloatFocused)
					, ((mod4Mask, xK_g    ), Cycle.cycleThroughLayouts ["gimp layout", "default"])
					, ((mod4Mask, xK_r    ), Cycle.cycleThroughLayouts ["pdf layout", "default"])
				  , ((mod4Mask, xK_space), Cycle.cycleThroughLayouts ["full", "default"])
				  , ((mod4Mask, xK_d    ), Cycle.cycleThroughLayouts ["two pane", "default"])
				  , ((mod4Mask, xK_h    ), Cycle.cycleThroughLayouts ["float", "default"])
				  , ((mod4Mask, xK_s    ), rotSlavesUp )
				  , ((mod4Mask, xK_f    ), sendMessage ToggleStruts)
  			  , ((mod4Mask, xK_m    ), spawn "xcalib -invert -alter")
				  , ((mod4Mask,  xK_w),  sendMessage Mag.Toggle )
--					, ((mod4Mask, xK_backslash), withFocused (sendMessage . maximizeRestore))
				  , ((mod4Mask,                 xK_Right), sendMessage $ Go R)
				  , ((mod4Mask,                 xK_Left ), sendMessage $ Go L)
				  , ((mod4Mask,                 xK_Up   ), sendMessage $ Go U)
				  , ((mod4Mask,                 xK_Down ), sendMessage $ Go D)
				  , ((mod4Mask .|. controlMask,     xK_Right), spawn "xrandr -o 1 && synclient orientation=1")
				  , ((mod4Mask .|. controlMask,     xK_Left ), spawn "xrandr -o 3 && synclient orientation=3")
				  , ((mod4Mask .|. controlMask,     xK_Up   ), spawn "xrandr -o 2 && synclient orientation=2")
				  , ((mod4Mask .|. controlMask,     xK_Down ),  spawn "xrandr -o 0 && synclient orientation=0")
				  , ((mod4Mask .|. shiftMask, xK_Right), sendMessage $ Swap R)
				  , ((mod4Mask .|. shiftMask, xK_Left ), sendMessage $ Swap L)
				  , ((mod4Mask .|. shiftMask, xK_Up   ), sendMessage $ Swap U)
				  , ((mod4Mask .|. shiftMask, xK_Down ), sendMessage $ Swap D)
					, ((mod4Mask .|. shiftMask, xK_o     ), restart "/home/kaspar/bin/obtoxmd" True)
				]

myLayoutHook = windowNavigation . avoidStruts . smartBorders $ (named "default" mouseResizableTile ||| named "two pane" (TwoPane (3/100) (1/2) ) |||  named "full" Full ||| gimpLayout ||| named "float" simplestFloat)
	where
	gimpLayout = named "gimp layout" (simpleTabbed ****||* simpleTabbed)

myManageHook = composeAll $ 
	[ resource =? name --> doIgnore | name <- ignore ]
--	++[ className =? name --> (doRectFloat $ RationalRect 0.25 0.25 0.5 0.5) | name <- floaters ]
--	++[ resource =? name --> (doRectFloat $ RationalRect 0.25 0.25 0.5 0.5) | name <- floaters ]
	++[ className =? name --> (doFloatDep $ minResizeTransform (0.1,0.1) NE (0.1,0.1)) | name <- floaters ]
	++[ resource =? name --> (doFloatDep $ minResizeTransform (0.1,0.1) NE (0.1,0.1) )| name <- floaters ]
	++[ manageDocks <+> manageHook defaultConfig
	--	,(isFullscreen --> doFullFloat) --full float fullscreen flash
		]
	where
		floaters = ["xcalc", "galculator", "gcalctool", "BasicWin"]
		ignore = ["stalonetray"]
		minResizeTransform :: (Rational,Rational) -> Side -> (Rational,Rational) -> RationalRect -> RationalRect
		minResizeTransform (wmin,hmin) orientation (xratio,yratio) (RationalRect x y w h)
			| orientation `elem` [NE,NW,SE,SW]      = RationalRect cx cy cw ch
			| otherwise                             = RationalRect x y cw ch
			where   cw = max w wmin
				ch = max h hmin
				cx = xdelta orientation xratio cw
				cy = ydelta orientation yratio ch
				xdelta :: Side -> Rational -> Rational -> Rational
				xdelta orientation xratio cw
					| orientation `elem` [NE,SE]    = (1-xratio)-cw
					| otherwise        {-[NW,SW]-}  = xratio
				ydelta :: Side -> Rational -> Rational -> Rational
				ydelta orientation yratio ch
					| orientation `elem` [SE,SW]    = (1-yratio)-ch
					| otherwise        {-[NE,NW]-}  = yratio

startup :: X ()
startup = do
	spawn "xmobar"
	spawn "stalonetray"
	--spawn "dbus-launch nm-applet --sm-disable"
