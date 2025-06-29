module View exposing (renderPageBody, titleForPage)

import Bits.DatePicker exposing (DateSelectorMsg(..), dateSelectWidget)
import Bits.Form as Form
import Date
import Html exposing (Html, button, div, fieldset, form, h1, h2, hr, input, label, main_, pre, span, text)
import Html.Attributes exposing (class, disabled, placeholder, style, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Message exposing (Msg(..))
import Model exposing (Model)


isValidDateValue : String -> Bool
isValidDateValue value =
    case Date.fromIsoString value of
        Ok _ ->
            True

        Err _ ->
            False


demoFormWidget : Model -> Html Msg
demoFormWidget model =
    let
        startDateValue =
            Form.formValue model.demoForm "startDate" ""

        endDateValue =
            Form.formValue model.demoForm "endDate" ""

        titleValue =
            Form.formValue model.demoForm "title" ""

        submitDisableValue : Bool
        submitDisableValue =
            (String.length titleValue == 0)
                || not (isValidDateValue startDateValue)
                || not (isValidDateValue endDateValue)
    in
    form [ onSubmit AddDemoDataSubmit, class "form" ]
        [ fieldset [ class "field is-horizontal" ]
            -- start date
            [ div [ class "field-label" ] [ label [ class "label" ] [ text "Start Date" ] ]
            , div [ class "field-body" ]
                [ div [ class "field has-addons" ]
                    [ div [ class "control" ]
                        [ input
                            [ class "input"
                            , type_ "text"
                            , onInput (FormUpdateValue "date")
                            , value startDateValue
                            , placeholder "YYYY-MM-DD"
                            ]
                            []
                        ]
                    , div [ class "control" ] [ dateSelectWidget model.today model.startDateSelector StartDateSelector ]
                    ]
                ]
            ]
        , fieldset [ class "field is-horizontal" ]
            -- end date
            [ div [ class "field-label" ] [ label [ class "label" ] [ text "End Date" ] ]
            , div [ class "field-body" ]
                [ div [ class "field has-addons" ]
                    [ div [ class "control" ]
                        [ input
                            [ class "input"
                            , type_ "text"
                            , onInput (FormUpdateValue "date")
                            , value endDateValue
                            , placeholder "YYYY-MM-DD"
                            ]
                            []
                        ]
                    , div [ class "control" ] [ dateSelectWidget model.today model.endDateSelector EndDateSelector ]
                    ]
                ]
            ]
        , fieldset [ class "field" ]
            -- title
            [ label [ class "label" ] [ text "Title" ]
            , div [ class "control" ]
                [ input
                    [ class "input"
                    , type_ "text"
                    , onInput (FormUpdateValue "title")
                    , value titleValue
                    , placeholder "Title value"
                    ]
                    []
                ]
            ]
        , fieldset [ class "field" ]
            [ div [ class "control", style "display" "flex", style "align-items" "center", style "gap" "1rem" ]
                [ button
                    [ class "button is-link"
                    , type_ "submit"
                    , disabled submitDisableValue
                    ]
                    [ text "Submit!" ]
                , span []
                    [ text
                        (if submitDisableValue then
                            "invalid"

                         else
                            "very valid"
                        )
                    ]
                ]
            ]
        ]



--
-- exported
--


titleForPage : Model -> String
titleForPage _ =
    "DatePicker Demo"


renderPageBody : Model -> List (Html Msg)
renderPageBody model =
    [ main_ [ class "container" ]
        [ h1 [ class "title" ] [ text "DatePicker Demo Form" ]
        , demoFormWidget model
        , hr [] []
        , h2 [ class "title" ] [ text "Output" ]
        , pre [] [ text model.output ]
        ]
    ]
