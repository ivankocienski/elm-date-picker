module Bits.Form exposing (Form, emptyForm, formValue, updateFormValue)

import Dict



{-
   A small wrapper around HTML forms so you don't have to define custom
   type aliases on your model for every form.
-}


type alias Form =
    Dict.Dict String String


emptyForm : Form
emptyForm =
    Dict.empty


formValue : Form -> String -> String -> String
formValue form key default =
    Maybe.withDefault
        default
        (Dict.get key form)


updateFormValue : Form -> String -> String -> Form
updateFormValue form key value =
    Dict.insert
        key
        value
        form
