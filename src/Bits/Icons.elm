module Bits.Icons exposing (calendarIcon)

-- import Message exposing (Msg(..))

import Html
import Svg
import Svg.Attributes exposing (..)


calendarIcon : Html.Html msg
calendarIcon =
    Svg.svg [ width "1em", height "1em", viewBox "0 0 20 20", fill "currentColor" ]
        [ Svg.path [ d "M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z" ] []
        ]
