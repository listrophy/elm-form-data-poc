module View exposing (view)

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
    div [] <|
      List.map (\x-> div [] [ x ])
        [ label [] [ text "name" ]
        , input [ onInput ChangeNewSiteName, value unwrapped.name ] []
        , label [] [ text "url" ]
        , input [ onInput ChangeNewSiteUrl, value unwrapped.url ] []
        , label [] [ text "enabled" ]
        , input [ type_ "checkbox", onCheck ToggleNewSiteEnabled, checked unwrapped.enabled ] []
        , button [ onClick SubmitNewSite ] [ text "Create" ]
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
  tr [] <|
    List.map (\x-> td [] [ x ])
      [ text <| Maybe.withDefault "-" (Maybe.map toString site.id)
      , text site.name
      , text site.url
      , text <| if site.enabled then "on" else "off"
      ]
