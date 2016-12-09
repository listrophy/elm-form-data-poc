module FetchSites exposing (..)

import Json.Decode as Json
import Http

import RemoteData

import Messages exposing (Msg(..))
import Models exposing (Site)

endpoint : String
endpoint = "http://localhost:8080/api/sites"

fetchSites : Cmd Msg
fetchSites =
  Http.get endpoint decodeSites
    |> Http.send (TriedFetchSites << RemoteData.fromResult)

decodeSites : Json.Decoder (List Site)
decodeSites =
  Json.field "sites" (Json.list decodeSite)

decodeSite : Json.Decoder Site
decodeSite =
  Json.map4 Site
    (Json.maybe <| Json.field "id" Json.int)
    (Json.field "name" Json.string)
    (Json.field "url" Json.string)
    (Json.field "enabled" Json.bool)
