module Update exposing (update)

import Http
import Json.Encode as JE
import Json.Decode as JD

import Models exposing (Model)
import Messages exposing (Msg(..))
import FormData exposing (FormData)
import RemoteData

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case Debug.log "msg" msg of
    ChangeNewSiteName str ->
      let
          newSite_ = FormData.map (\m->{m|name = str}) model.newSite
      in
         {model | newSite = newSite_} ! []

    ChangeNewSiteUrl str ->
       let
           newSite_ = FormData.map (\m->{m | url = str }) model.newSite
       in
          {model | newSite = newSite_} ! []

    ToggleNewSiteEnabled newVal ->
       let
           newSite_ = FormData.map (\m->{m | enabled = newVal }) model.newSite
       in
          {model | newSite = newSite_} ! []

    SubmitNewSite ->
      model ! [submitNewSite model]

    TriedFetchSites response ->
      {model | sites = response} ! []

    TriedSubmitNewSite (FormData.Succeeded resp wrapped) ->
      let
          siteToAdd = {wrapped | id = Just resp}
          newSites = RemoteData.map ((::) siteToAdd) model.sites
      in
         {model | newSite = Models.initSite, sites = newSites } ! []

    TriedSubmitNewSite response ->
      {model | newSite = response} ! []

submitNewSite : Model -> Cmd Msg
submitNewSite model =
  let
      siteBody =
        JE.object
          [ ("name", JE.string (FormData.get .name model.newSite))
          , ("url", JE.string (FormData.get .url model.newSite))
          , ("enabled", JE.bool (FormData.get .enabled model.newSite))
          ]

      body =
        Http.jsonBody <|
          JE.object
            [ ("site", siteBody) ]

      decoder =
        JD.field "site" <|
          JD.field "id" JD.int
  in
    Http.post "http://localhost:8080/api/sites" body decoder
      |> Http.send (TriedSubmitNewSite << FormData.fromResult model.newSite)
