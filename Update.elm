module Update exposing (update)

import Http
import Json.Encode as JE
import Json.Decode as JD

import Models exposing (Model)
import Messages exposing (Msg(..))
import FormData exposing (FormData)
import RemoteData
import Api

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case Debug.log "msg" msg of
    ChangeNewSiteName newName ->
      let
          newSite_ = FormData.map (\m->{m|name = newName}) model.newSite
      in
         {model | newSite = newSite_} ! []

    ChangeNewSiteUrl newUrl ->
      { model
      | newSite = FormData.map (\m->{m|url = newUrl }) model.newSite
      } ! []

    ToggleNewSiteEnabled newVal ->
       let
           newSite_ = FormData.map (\m->{m|enabled = newVal }) model.newSite
       in
          {model | newSite = newSite_} ! []

    SubmitNewSite ->
      model ! [Api.submitNewSite model.newSite]

    TriedSubmitNewSite (FormData.Succeeded resp wrapped) ->
      let
          siteToAdd = {wrapped | id = Just resp}
          newSites = RemoteData.map ((::) siteToAdd) model.sites
      in
         {model | newSite = Models.initSite, sites = newSites } ! []

    TriedSubmitNewSite response ->
      {model | newSite = response} ! []

    TriedFetchSites response ->
      {model | sites = response} ! []
