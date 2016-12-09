module Sites.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick, onCheck)

import RemoteData exposing (WebData, RemoteData(..))

import Models exposing (..)
import Messages exposing (..)
import FormData

view : Model -> Html Msg
view model =
  div []
    [ myForm model.newSite
    , myTable model.sites
    ]

myForm : FormData.WebFormData Int Site -> Html Msg
myForm model =
  let unwrapped = FormData.unwrap model
  in
    div []
      [ div [] [ label [] [ text "name" ] ]
      , div [] [ input [ onInput ChangeNewSiteName ] [ text unwrapped.name ] ]
      , div [] [ label [] [ text "url" ] ]
      , div [] [ input [ onInput ChangeNewSiteUrl ] [ text unwrapped.url ] ]
      , div [] [ label [] [ text "enabled" ] ]
      , div [] [ input [ type_ "checkbox", onCheck ToggleNewSiteEnabled, checked unwrapped.enabled ] [ ] ]
      , div [] [ button [ onClick SubmitNewSite ] [ text "Create" ] ]
      ]

myTable : WebData (List Site) -> Html Msg
myTable model =
  let
      tbl body =
        table []
          [ thead []
              [ tr []
                  [ th [] [ text "id" ]
                  , th [] [ text "name" ]
                  , th [] [ text "url" ]
                  , th [] [ text "enabled" ]
                  ]
              ]
          , tbody [] body
          ]
  in
    case model of
        NotAsked ->
          tbl
            [ tr []
                [ td [ colspan 4 ] [ text "not asked" ]
                ]
            ]

        Loading ->
          tbl
            [ tr []
                [ td [ colspan 4 ] [ text "loading" ]
                ]
            ]

        Failure e ->
          div [] [ text <| toString e ]

        Success sites ->
          sites
            |> List.sortBy (Maybe.withDefault 0 << .id)
            |> List.reverse
            |> List.map rowMapper
            |> tbl

rowMapper : Site -> Html Msg
rowMapper site =
  tr []
    [ td [] [ text <| Maybe.withDefault "-" (Maybe.map toString site.id) ]
    , td [] [ text site.name ]
    , td [] [ text site.url ]
    , td [] [ text <| if site.enabled then "on" else "off" ]
    ]
