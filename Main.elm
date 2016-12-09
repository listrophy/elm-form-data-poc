module Main exposing (main)

import Html exposing (Html, text)

import RemoteData exposing (RemoteData(..), WebData)

import Models exposing (..)
import Messages exposing (..)
import Sites.View
import FetchSites
import Update

main =
  Html.program
    { init = init
    , update = Update.update
    , view = view
    , subscriptions = always Sub.none
    }

-- Msg / Model

init : (Model, Cmd Msg)
init =
  initModel !
    [ FetchSites.fetchSites
    ]

-- view

view : Model -> Html Msg
view model =
  Sites.View.view model
