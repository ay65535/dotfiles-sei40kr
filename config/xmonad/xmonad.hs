{-# LANGUAGE MultiWayIf #-}

module Main (main) where

import           Control.Monad
import           Data.List
import qualified Data.Map                    as M
import           Data.Monoid
import           Data.Ratio ((%))
import           System.Directory
import           System.Exit
import           System.IO
import           XMonad
import           XMonad.Actions.CopyWindow
import           XMonad.Actions.Minimize
import           XMonad.Config.Gnome
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.Minimize
import           XMonad.Hooks.SetWMName
import           XMonad.Layout.BoringWindows
import           XMonad.Layout.IM
import           XMonad.Layout.Minimize
import           XMonad.Layout.PerWorkspace
import           XMonad.Layout.Reflect
import           XMonad.Layout.Spacing
import           XMonad.Layout.Tabbed
import qualified XMonad.StackSet             as W
import           XMonad.Util.Run
import           XMonad.Util.SpawnOnce

-- xmonad.hs ---

-- author: Seong Yong-ju <sei40kr@gmail.com>

--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: String
myTerminal = "alacritty"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

-- Width of the window border in pixels.
--
myBorderWidth :: Dimension
myBorderWidth = 3

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--

internetWs = "1"
devWs = "2"
fileWs = "3"
imWs = "4"

myWorkspaces :: [String]
myWorkspaces = [internetWs, devWs, fileWs, imWs]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor :: String
myNormalBorderColor = "#ffffff"
myFocusedBorderColor :: String
myFocusedBorderColor = "#15539e"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--

isTodoist :: Query Bool
isTodoist = resource =? "crx_bgjohebimpjdhhocbknplfelpmdhifhd"

isPersistent :: Query Bool
isPersistent = className =? "Bitwarden" <||>
               className =? "GoldenDict" <||>
               className =? "Geary" <||>
               isTodoist

isTerminal :: Query Bool
isTerminal = className =? "Alacritty"

myKeys conf@XConfig {XMonad.modMask = modm} =
  M.fromList $
    -- launch a terminal
  [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- launch rofi
  , ((modm, xK_p), spawn "rofi -show combi")
    -- close focused window
  , ( (modm .|. shiftMask, xK_c)
    , withFocused
        (\win -> do
           terminal <- runQuery isTerminal win
           persistent <- runQuery isPersistent win
           homeDir <- io getHomeDirectory
           if persistent
             then minimizeWindow win
             else killWindow win
           when terminal $
             safeSpawn (homeDir ++ "/.tmux/scripts/clean-orphan-sessions.bash") []))
    -- Rotate through the available layout algorithms
  , ((modm, xK_space), sendMessage NextLayout)
    -- Reset the layouts on the current workspace to default
  , ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
  , ((modm, xK_n), refresh)
    -- Move focus to the next window
  , ((modm, xK_Tab), focusDown)
    -- Move focus to the next window
  , ((modm, xK_j), focusDown)
    -- Move focus to the previous window
  , ((modm, xK_k), focusUp)
    -- Move focus to the master window
  , ((modm, xK_m), focusMaster)
    -- Swap the focused window and the master window
  , ((modm, xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
  , ((modm .|. shiftMask, xK_j), windows W.swapDown)
    -- Swap the focused window with the previous window
  , ((modm .|. shiftMask, xK_k), windows W.swapUp)
    -- Shrink the master area
  , ((modm, xK_h), sendMessage Shrink)
    -- Expand the master area
  , ((modm, xK_l), sendMessage Expand)
    -- Push window back into tiling
  , ((modm, xK_t), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
  , ((modm, xK_comma), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
  , ((modm, xK_period), sendMessage (IncMasterN (-1)))
    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    -- Quit xmonad
  , ((modm .|. shiftMask, xK_q), spawn "gnome-session-quit --logout")
    -- Restart xmonad
  , ((modm, xK_q), spawn "xmonad --recompile; xmonad --restart")
    -- Run xmessage with a summary of the default keybindings (useful for beginners)
  , ( (modm .|. shiftMask, xK_slash)
    , spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
  , ((0, xK_Print), spawn "gnome-screenshot")
  , ((shiftMask, xK_Print), spawn "gnome-screenshot -i")
  ] ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
  [ ((m .|. modm, k), windows $ f i)
  | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
  , (f, m) <- [(W.greedyView, 0), (liftM2 (.) W.view W.shift, shiftMask)]
  ] ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
  [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
  | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..]
  , (f, m) <- [(W.view, 0), (liftM2 (.) W.shift W.view, shiftMask)]
  ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings XConfig {XMonad.modMask = modm} =
  M.fromList
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1)
      , \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ( (modm, button3)
      , \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
adwaitaTabTheme = def
    { activeColor = "#1e1e1e"
    , activeBorderColor = "#1e1e1e"
    , activeTextColor = "#cccccc"
    , inactiveColor = "#353535"
    , inactiveBorderColor = "#353535"
    , inactiveTextColor = "#cccccc"
    , urgentColor = "#353535"
    , urgentBorderColor = "#353535"
    , urgentTextColor = "#cccccc"
    , fontName = "xft:Noto Sans CJK JP:size=11"
    , decoHeight = 36
    }

myLayout =
  desktopLayoutModifiers $
  minimize . boringWindows $
  onWorkspace internetWs (tabSpacing myTabbed) $
  onWorkspace devWs (tabSpacing $ reflectHoriz $ withIM (1 % 2) vmdProps $
                     reflectHoriz myTabbed) $
  onWorkspace fileWs (tabSpacing myTabbed ||| tiledSpacing tiled) $
  tiledSpacing tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall 1 (toRational $ 2 / (1 + sqrt 5 :: Double)) (3 / 100)
    tiledSpacing =
      spacingRaw False (Border 24 24 24 24) True (Border 8 8 8 8) True
    myTabbed = tabbed shrinkText adwaitaTabTheme
    tabSpacing =
      spacingRaw False (Border 32 32 32 32) True (Border 0 0 0 0) False
    vmdProps = ClassName "Electron"

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--

isChromeExtension :: Query Bool
isChromeExtension = fmap (isPrefixOf "crx_") resource

isPocket :: Query Bool
isPocket = resource =? "crx_mjcnijlhddpbdemagnpefmlkjdagkogk"

isLINE :: Query Bool
isLINE = resource =? "crx_ophjlpahpchlmihnnnihgmmeilfjmjjc"

isKindleCloudReader :: Query Bool
isKindleCloudReader = resource =? "crx_cemlonfcgoakflacgajmjhfacialphik"

isVmd :: Query Bool;
isVmd = className =? "Electron" <&&> fmap (isSuffixOf " - vmd") title

centerRect :: W.RationalRect
centerRect = W.RationalRect 0.23 0.14 0.54 0.72

myManageHook :: ManageHook
myManageHook =
  composeAll
    [ resource =? "desktop_window" --> doIgnore
    , isDialog --> doCenterFloat
    , isFullscreen --> doFullFloat
    , stringProperty "WM_WINDOW_ROLE" =? "pop-up" <&&> fmap not isChromeExtension
      --> doCenterFloat
    , className =? "Rofi" --> doIgnore
    , className =? "Gnome-pomodoro" <||>
      className =? "Gnome-control-center" <||>
      className =? "Xfce4-notifyd-config" <||>
      className =? "Gcolor3" <||>
      className =? "Fcitx-config-gtk3" --> doCenterFloat <+> doF copyToAll
    , className =? "Bitwarden" <||>
      isTodoist <||>
      className =? "GoldenDict" --> doRectFloat centerRect <+> doF copyToAll
    , className =? "Gcr-prompter" <||>
      className =? "Gnome-contacts" --> doCenterFloat
    , className =? "Dconf-editor" --> doRectFloat centerRect
    -- Internet Apps
    , stringProperty "WM_WINDOW_ROLE" =? "browser" <||>
      className =? "Google-chrome" <||>
      className =? "Geary" <||>
      className =? "Gnome-calendar" <||>
      className =? "Gnome-contacts" <||>
      isKindleCloudReader <||>
      isPocket --> doShiftAndView internetWs
    -- Development
    , className =? "Alacritty" <||>
      className =? "Emacs" <||>
      className =? "Zeal" <||>
      isVmd <||>
      className =? "Code" <||>
      className =? "jetbrains-idea"  --> doShiftAndView devWs
    , className =? "jetbrains-idea" <&&> title =? "Welcome to IntelliJ IDEA" -->
      doCenterFloat
    -- File Browsing
    , className =? "Thunar" --> doShiftAndView fileWs
    -- Instant Messengers
    , className =? "Skype" <||>
      className =? "Slack" <||>
      className =? "zoom" <||>
      className =? "discord" <||>
      isLINE --> doShiftAndView imWs
    ]
  where
    doShiftAndView = doF . liftM2 (.) W.view W.shift

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--

myEventHook :: Event -> X All
myEventHook =
  ewmhDesktopsEventHook <+>
  docksEventHook <+>
  fullscreenEventHook <+>
  minimizeEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

myLogHook :: X ()
myLogHook = ewmhDesktopsLogHook <+> do
  wset <- gets windowset
  let wss = map W.tag $ W.workspaces wset
  let current = W.currentTag wset
  io $ appendFile "/tmp/.xmonad-workspace-log" $ format current wss
  where
    format current = (++ "\n") . intercalate "%{O3}" . map (label current) . sort
    label current ws = (if ws == current
         then wrap "%{F#ffffff}%{u#ffffff}" "%{-u}%{F-}"
         else id) $ "   " ++ ws ++ "   "

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.

myStartupHook :: X ()
myStartupHook =
  gnomeRegister <+>
  ewmhDesktopsStartup

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--

-- No need to modify this.
--
defaults =
  docks
    def
      -- simple stuff
      { terminal = myTerminal
      , focusFollowsMouse = myFocusFollowsMouse
      , clickJustFocuses = myClickJustFocuses
      , borderWidth = myBorderWidth
      , modMask = myModMask
      , workspaces = myWorkspaces
      , normalBorderColor = myNormalBorderColor
      , focusedBorderColor = myFocusedBorderColor
      -- key bindings
      , keys = myKeys
      , mouseBindings = myMouseBindings
      -- hooks, layouts
      , layoutHook = myLayout
      , manageHook = myManageHook
      , handleEventHook = myEventHook
      , logHook = myLogHook
      , startupHook = myStartupHook
      }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch alacritty",
    "mod-p            Launch rofi",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",

    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]