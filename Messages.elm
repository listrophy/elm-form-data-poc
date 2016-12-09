module Messages exposing (..)

import RemoteData exposing (WebData)

import Models exposing (Site)
import FormData exposing (WebFormData)

type Msg
  = ChangeNewSiteName String
  | ChangeNewSiteUrl String
  | ToggleNewSiteEnabled Bool
  | SubmitNewSite
  | TriedSubmitNewSite (WebFormData Int Site)
  | TriedFetchSites (WebData (List Site))
