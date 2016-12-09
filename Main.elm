module Main exposing (main)

import Html exposing (Html, text)

import RemoteData exposing (RemoteData(..), WebData)

import Models exposing (..)
import Messages exposing (Msg)
import View
import Api
import Update

main =
  Html.program
    { init = init
    , update = Update.update
    , view = View.view
    , subscriptions = always Sub.none
    }

-- Msg / Model

init : (Model, Cmd Msg)
init =
  initModel !
    [ Api.fetchSites
    ]
