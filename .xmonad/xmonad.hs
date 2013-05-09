import XMonad hiding ( (|||), Tall )
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place
import XMonad.Hooks.ManageHelpers
import XMonad.Util.CustomKeys
import XMonad.Util.EZConfig
--import XMonad.Layout.Magnifier as Mag
import Data.Monoid
import XMonad.Actions.CycleSelectedLayouts as Cycle
import XMonad.Actions.RotSlaves
import XMonad.Util.Replace
import XMonad.StackSet as W hiding (focus, workspaces) --for W.RationalRect
import XMonad.Hooks.SetWMName
--layouts
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.SimpleFloat
import XMonad.Layout.DragPane
import XMonad.Layout.TwoPane
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Named
import XMonad.Layout.HintedGrid
import XMonad.Layout.ComboP
import XMonad.Layout.Square


main = do
		replace
		xmonad $ defaultConfig { terminal						  = "urxvtc -cd `cat ~/.cwd`"
			--{ terminal						  = "cat ~/.cwd | xargs urxvt -cd"
			, modMask								= mod4Mask --rebind Mod to Windows Key
			, manageHook						= myManageHook 
			, layoutHook						= myLayoutHook 
			, focusedBorderColor    = "#ee9a00"
			, normalBorderColor			= "#000000"
			, startupHook						= startup
			} `additionalKeys`
				[ ((mod4Mask, xK_p), spawn "exe=`IFS+:; stest=flx ${PATH} | /usr/bin/yeganesh -- -i -b -sb orange -nb black -nf grey` && eval \"exec $exe\"")  
  			    , ((mod4Mask, xK_o),spawn "urxvt -cd `cat ~/.cwd` -e vim")
  			    , ((mod4Mask, xK_i),spawn "urxvt -cd `cat ~/.cwd` -e ipython2")
				, ((mod4Mask, xK_q),spawn "killall stalonetray xmobar redshift" >> restart "xmonad" True)
				, ((mod4Mask, xK_b),spawn "firefox")
				, ((0, 0x1008ff13 ), spawn "amixer set Master 1+")
				, ((0, 0x1008ff11 ), spawn "amixer set Master 1-")
				, ((0, 0x1008ff12 ), spawn "amixer set Master toggle")
--				, ((0, 0x1008ff59 ), spawn "sudo pm-suspend")
				, ((0, 0x1008ff59 ), spawn "xset dpms force off")
--			  	, ((0, 0x1008ff2f ), spawn "xset dpms force off")
				, ((0, 0x1008ff2a ), spawn "sudo poweroff")
				, ((mod4Mask, xK_d    ), Cycle.cycleThroughLayouts ["test", "default"])
				, ((mod4Mask, xK_t    ), withFocused $ windows . W.sink)
				, ((mod4Mask, xK_g    ), Cycle.cycleThroughLayouts ["grid", "default"])
			    , ((mod4Mask, xK_space), Cycle.cycleThroughLayouts ["full", "default"])
			    , ((mod4Mask, xK_h    ), Cycle.cycleThroughLayouts ["float", "default"])
			    , ((mod4Mask .|. shiftMask, xK_s    ), sendMessage $ SwapWindow )
			    , ((mod4Mask, xK_f    ), sendMessage ToggleStruts)
  			    , ((mod4Mask, xK_m    ), spawn "xcalib -invert -alter")
--				  , ((mod4Mask,  xK_w),  sendMessage Mag.Toggle )
--			  	  , ((mod4Mask, xK_backslash), withFocused (sendMessage . maximizeRestore))
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

myLayoutHook = windowNavigation . avoidStruts . smartBorders $ 
	(   named "default" mouseResizableTile 
	-- ||| named "two pane" (TwoPane (3/100) (1/2) ) 
	||| named "full" Full 
	||| named "float" simplestFloat 
	||| named "grid" (Grid False)
	||| named "test" (combineTwoP (TwoPane 0.03 0.5) simpleTabbed simpleTabbed ((ClassName "Evince") `Or` (ClassName "Firefox")))
	)
	--where
	--gimpLayout = named "gimp layout" (simpleTabbed ****||* simpleTabbed)

myManageHook = composeAll $ 
	[ resource =? name --> doIgnore | name <- ignore ]
	++[ className =? name --> (doFloatDep $ minResizeTransform (0.1,0.1) NE (0.1,0.1)) | name <- floaters ]
	++[ resource =? name --> (doFloatDep $ minResizeTransform (0.1,0.1) NE (0.1,0.1) )| name <- floaters ]
	-- ++[ gimp "toolbox" --> (ask >>= doF . W.sink)]
	-- ++[  className =? "Gimp" --> (ask >>= doF . W.sink)]
	++[ manageDocks <+> manageHook defaultConfig
	--	,(isFullscreen --> doFullFloat) --full float fullscreen flash
		]
	where
		--gimp = (className =? “Gimp” (fmap (win `isSuffixOf`) role))
		role = stringProperty "WM_WINDOW_ROLE"
		floaters = ["xcalc", "galculator", "gcalctool", "BasicWin", "not found."]
		ignore = ["stalonetray", "xfce4-notifyd"]
		minResizeTransform :: (Rational,Rational) -> Side -> (Rational,Rational) -> W.RationalRect -> W.RationalRect
		minResizeTransform (wmin,hmin) orientation (xratio,yratio) (W.RationalRect x y w h)
			| orientation `elem` [NE,NW,SE,SW]      = W.RationalRect cx cy cw ch
			| otherwise                             = W.RationalRect x y cw ch
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
	setWMName "LG3D"
	spawn "redshift -l 51:-2.5"
    --spawn "xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'"
	spawn "xmobar"
	spawn "urxvtd"
	spawn "stalonetray"
