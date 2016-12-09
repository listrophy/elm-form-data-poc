module Models exposing (..)

import RemoteData exposing (WebData, RemoteData(NotAsked))
import FormData exposing (WebFormData, FormData(Editing))

type alias Model =
  { sites : WebData (List Site)
  , newSite : WebFormData Int Site
  }


type alias Site =
  { id : Maybe Int
  , name : String
  , url : String
  , enabled : Bool
  }

initModel : Model
initModel =
  { sites = NotAsked
  , newSite = initSite
  }

initSite : WebFormData Int Site
initSite =
  Editing (Site Nothing "" "" True)
