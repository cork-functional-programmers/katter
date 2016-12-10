{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import           Control.Monad.IO.Class
import qualified Control.Monad.State    as S
import qualified Data.Aeson             as A
import           Data.IORef
import qualified Data.Map               as M
import           Data.Maybe             (fromMaybe)
import           Data.Monoid
import qualified Data.Text.Lazy         as T
import           GHC.Generics
import           Lib
import           Web.Scotty

newtype Username = Username String deriving (Ord, Eq, Show)

data KatterMessage = KatterMessage
  { username :: String,
    message  :: String,
    mentions :: [String] }
    deriving (Eq, Show, Generic)

instance A.FromJSON KatterMessage
instance A.ToJSON KatterMessage

addUserMessageMessage :: Username -> KatterMessage
                      -> M.Map Username [KatterMessage]
                      -> M.Map Username [KatterMessage]
addUserMessageMessage username km ms =
  M.insert username updatedUserMessages ms where
    updatedUserMessages = maybe [km] (km :) (M.lookup username ms)

getMentions :: String -> M.Map Username [KatterMessage] -> [KatterMessage]
getMentions mentioned = filter (elem mentioned . mentions) . concat . M.elems

handleGetByUsername :: IORef (M.Map Username [KatterMessage]) -> ActionM ()
handleGetByUsername messagesIORef = do
  username <- param "username" `rescue` const next
  mes <- liftIO $ readIORef messagesIORef
  json $ fromMaybe [] (M.lookup (Username username) mes)

handleGetMentions :: IORef (M.Map Username [KatterMessage]) -> ActionM ()
handleGetMentions messagesIORef = do
  mentioned <- param "mentioned"
  mes <- liftIO $ readIORef messagesIORef
  json $ getMentions mentioned mes

handleAddMessage :: IORef (M.Map Username [KatterMessage]) -> ActionM ()
handleAddMessage messagesIORef = do
  km <- jsonData
  liftIO $ atomicModifyIORef' messagesIORef
    (flip (,) () . addUserMessageMessage (Username (username km)) km)

main :: IO ()
main = do
  messagesIORef <- newIORef (M.fromList [] :: M.Map Username [KatterMessage])
  scotty 3000 $ do
     get "/katter/messages" $ handleGetByUsername messagesIORef
     get "/katter/messages" $ handleGetMentions messagesIORef
     post "/katter/messages" $ handleAddMessage messagesIORef
