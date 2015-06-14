module Main where

import Control.Monad
import Data.Char
import Data.List
import System.Exit

import Graphics.UI.Gtk
import Graphics.UI.Gtk.Gdk.Events (Event (..))
import qualified Graphics.UI.Gtk.ModelView as ModelView
import System.Glib.UTFString

data MenuGUI = MenuGUI { win          :: Window
                       , textField    :: Entry
                       , store        :: ModelView.ListStore String
                       , view         :: TreeView
                       , originalList :: [String]
                       }

main :: IO ()
main = do
    s <- getContents
    let listLines = lines s

    _ <- initGUI
    gui <- setupGUI listLines
    let window = win gui
    widgetShowAll window
    mainGUI

setupGUI :: [String] -> IO MenuGUI
setupGUI list = do
    window <- windowNew
    set window [ windowTitle := "GtkMenu"
               , windowWindowPosition := WinPosCenter
               , windowDefaultWidth := 640
               , windowDefaultHeight := 480
               , windowTypeHint := WindowTypeHintDialog
               ]
    _ <- onDestroy window mainQuit

    vBox <- vBoxNew False 0
    containerAdd window vBox

    tf <- entryNew
    boxPackStart vBox tf PackNatural 5

    model <- ModelView.listStoreNew list
    treeView <- treeViewNewWithModel model

    col1 <- treeViewColumnNew
    renderer1 <- cellRendererTextNew
    ModelView.cellLayoutPackStart col1 renderer1 True

    ModelView.cellLayoutSetAttributes col1 renderer1 model $ \ row ->
        [ ModelView.cellText := row ]

    _ <- treeViewAppendColumn treeView col1
    treeViewSetHeadersVisible treeView False
    sel <- treeViewGetSelection treeView
    treeSelectionSetMode sel SelectionSingle

    scrolledWindow <- scrolledWindowNew Nothing Nothing
    scrolledWindowSetPolicy scrolledWindow PolicyAutomatic PolicyAutomatic
    scrolledWindowAddWithViewport scrolledWindow treeView
    boxPackEnd vBox scrolledWindow PackGrow 5

    let gui = MenuGUI window tf model treeView list

    selectHelper gui
    _ <- onKeyPress window $ windowKeyPressHandler gui
    _ <- onEditableChanged tf $ entryChangedHandler gui

    return gui

entryChangedHandler :: MenuGUI -> IO ()
entryChangedHandler gui = do
    text <- entryGetText entry
    let newList = pickMatches text $ originalList gui
    ModelView.listStoreClear model
    mapM_ (ModelView.listStoreAppend model) newList
    selectHelper gui
  where
    entry = textField gui
    model = store gui

windowKeyPressHandler :: MenuGUI -> Event -> IO Bool
windowKeyPressHandler  gui ev =
  let
    ekn = glibToString $ Graphics.UI.Gtk.Gdk.Events.eventKeyName ev
  in
    case ekn of
         "Escape" -> exitWith (ExitFailure 1)
         "Return" -> returnKeyHandler gui
         _ -> return False

returnKeyHandler :: MenuGUI -> IO Bool
returnKeyHandler gui = do
    selection <- getSelectedItem gui
    case selection of
        Nothing -> return False
        Just ti -> do
            printValueFromIter gui ti
            widgetDestroy window
            return True
  where
    window = win gui

printValueFromIter :: MenuGUI -> TreeIter -> IO ()
printValueFromIter gui iter = do
    path <- treeModelGetPath model iter
    unless (null path)
        (do
            let index = head path
            value <- ModelView.listStoreGetValue model index
            putStr value)
  where
    model = store gui

getSelectedItem :: MenuGUI -> IO (Maybe TreeIter)
getSelectedItem gui = treeViewGetSelection tv >>= treeSelectionGetSelected
  where
    tv = view gui

selectHelper :: MenuGUI -> IO ()
selectHelper gui = do
    tvs <- treeViewGetSelection treeview
    sel <- treeSelectionGetSelected tvs
    firstItem <- treeModelGetIterFirst model
    case (sel, firstItem) of
        (Nothing, Just iter) -> treeSelectionSelectIter tvs iter
        _ -> return ()
  where
    treeview = view gui
    model = store gui

pickMatches :: String -> [String] -> [String]
pickMatches subString = filter isCaseInsensitiveInfixOf
  where
    lowerWord = map toLower
    lowerSub = lowerWord subString
    isCaseInsensitiveInfixOf string = lowerSub `isInfixOf` lowerWord string
