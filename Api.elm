module Api exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import Http

import RemoteData
import FormData exposing (WebFormData)

import Messages exposing (Msg(..))
import Models exposing (Model, Site)

endpoint : String
endpoint = "http://localhost:8080/api/sites"

{--
  GET /api/sites
--}

fetchSites : Cmd Msg
fetchSites =
  Http.get endpoint decodeSites
    |> Http.send (TriedFetchSites << RemoteData.fromResult)

decodeSites : JD.Decoder (List Site)
decodeSites =
  JD.field "sites" (JD.list decodeSite)

decodeSite : JD.Decoder Site
decodeSite =
  JD.map4 Site
    (JD.maybe <| JD.field "id" JD.int)
    (JD.field "name" JD.string)
    (JD.field "url" JD.string)
    (JD.field "enabled" JD.bool)

{--
  POST /api/sites
--}

submitNewSite : WebFormData Int Site -> Cmd Msg
submitNewSite newSite =
  let
      siteBody = encodeNewSite <| FormData.unwrap newSite

      body =
        Http.jsonBody <|
          JE.object
            [ ("site", siteBody) ]

      decoder =
        JD.field "id" JD.int
          |> JD.field "site"
  in
    Http.post "http://localhost:8080/api/sites" body decoder
      |> Http.send (TriedSubmitNewSite << FormData.fromResult newSite)

encodeNewSite : Site -> JE.Value
encodeNewSite site =
  JE.object
    [ ("name", JE.string site.name)
    , ("url", JE.string site.url)
    , ("enabled", JE.bool site.enabled)
    ]
