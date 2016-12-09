module FormData exposing (..)

import Http

type FormData error response wrapped
  = Editing wrapped
  | Submitting wrapped
  | Errored error wrapped
  | Succeeded response wrapped

type alias WebFormData response wrapped
  = FormData Http.Error response wrapped

map : (wrapped -> wrapped_) -> FormData error response wrapped -> FormData error response wrapped_
map f data =
  case data of
    Editing value ->
      Editing (f value)

    Submitting value ->
      Submitting (f value)

    Errored error value ->
      Errored error (f value)

    Succeeded response value ->
      Succeeded response (f value)

unwrap : FormData error response wrapped -> wrapped
unwrap data =
  case data of
    Editing value ->
      value

    Submitting value ->
      value

    Errored error value ->
      value

    Succeeded response value ->
      value

get : (wrapped -> b) -> FormData error response wrapped -> b
get f data =
  f (unwrap data)

fromResult : FormData error response wrapped -> Result error response -> FormData error response wrapped
fromResult data result =
  case result of
    Err err ->
      Errored err (unwrap data)

    Ok ok ->
      Succeeded ok (unwrap data)

isSubmitting : FormData error response wrapped -> Bool
isSubmitting data =
  case data of
    Submitting _ -> True
    _ -> False
