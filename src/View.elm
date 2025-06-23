module View exposing (renderPageBody, titleForPage)

import Model exposing (Model, TimeBlock)
import Message exposing (Msg(..))

import Html exposing (Html, h1, text, hr, h2, form, fieldset, label, input, button, table, thead, tbody, tr, th, td, p, main_, div, textarea, ul, li, a, i, span, h6)
import Html.Attributes exposing (type_, value, disabled, class, placeholder, style, id)
import Html.Events exposing (onSubmit, onInput, onClick)
import Date
import Html.Attributes exposing (placeholder)
import Bits.Form as Form
import Bits.DatePicker exposing (dateSelectWidget, DateSelectorMsg(..))

isValidDateValue : String -> Bool
isValidDateValue value =
  case (Date.fromIsoString value) of
    Ok _ -> True
    Err _ -> False

timeBlockForm : Model -> Html Msg
timeBlockForm model =
  let
    durationValue = Form.formValue model.timeBlockForm "duration" ""
    dateValue = Form.formValue model.timeBlockForm "date" ""
    descriptionValue = Form.formValue model.timeBlockForm "description" ""

    submitDisableValue : Bool
    submitDisableValue =
      (String.length(descriptionValue) == 0)
      || (not (isValidDateValue dateValue))
  in
  form [ onSubmit AddTimeBlockSubmit, class "form" ]
  [ fieldset [ class "field is-horizontal" ]
    [ div [ class "field-label" ] [ label [ class "label" ] [ text "Duration" ] ]
    , div [ class "field-body" ]
      [ div [ class "control" ]
        [ input
          [ class "input"
          , type_ "text"
          , onInput (FormUpdateValue "duration")
          , value durationValue
          ]
          []
        ]
      ]
    ]
  , fieldset [ class "field is-horizontal" ]
    [ div [ class "field-label" ] [ label [ class "label" ] [ text "Date" ] ]
    , div [ class "field-body" ]
      [ div [ class "field has-addons" ]
        [ div [ class "control" ]
          [ input
            [ class "input"
            , type_ "text"
            , onInput (FormUpdateValue "date")
            , value dateValue, placeholder "YYYY-MM-DD"
            ]
            []
          ]
        , div [ class "control" ] [ dateSelectWidget model DateSelector]
        ]
      ]
    ]
  , fieldset [ class "field" ]
    [ label [ class "label" ] [ text "Description" ]
    , div [ class "control" ]
      [ textarea
        [ class "textarea"
        , onInput (FormUpdateValue "description")
        , value descriptionValue ]
        []
      ]
    ]
  , fieldset [ class "field" ]
    [ p [] [ text (if submitDisableValue then "invalid" else "very valid")]
    , div [ class "control" ]
      [ button
        [ class "button is-link"
        , type_ "submit"
        , disabled submitDisableValue
        ]
        [ text "Log!" ]
      ]
    ]
  ]

timeBlockList : Model -> Html Msg
timeBlockList model =
  let
    timeBlockItem : TimeBlock -> Html Msg
    timeBlockItem item =
      tr []
        [ td [] [ text (String.fromInt item.duration) ]
        , td [] [ text (Date.toIsoString item.date) ]
        , td [] [ text item.description ]
        ]

  in
  table [ class "table" ]
  [ thead []
    [ tr []
      [ th [] [ text "duration" ]
      , th [] [ text "date" ]
      , th [] [ text "description" ]
      ]
    ]
  , tbody []
    (List.map timeBlockItem model.timeBlocks)
  ]

--
-- exported
--


titleForPage : Model -> String
titleForPage _ =
  "Title"

timeAsHuman : Int -> String
timeAsHuman total =
  let
    minutes =
      modBy 60 total

    hours =
      total // 60

    minuteString =
      if minutes > 0 then ((String.fromInt minutes) ++ " minutes") else ""

    hourString =
      if hours > 0 then ((String.fromInt hours) ++ " hours") else ""
  in
  List.foldl (++) ""
    <| List.intersperse " and "
    <| List.filter (\v -> (String.length v) > 0)
    <| [ minuteString, hourString ]


renderPageBody: Model -> List (Html Msg)
renderPageBody model =
  let
    totalTimeSpent : String
    totalTimeSpent =
      timeAsHuman
        <| List.foldl (\item total -> total + item.duration) 0 model.timeBlocks

  in
  [ main_ [ class "container" ]
    [ h1 [ class "title" ] [ text "TimeBlocks" ]
    , h2 [ class "subtitle" ] [ text ("total time spent: " ++ totalTimeSpent)]
    -- , p [] [ text ("today=" ++ (Date.toIsoString model.today)) ]
    , timeBlockList model

    , hr [] []
    , h2 [ class "subtitle" ] [ text "Add new Timeblock" ]
    , timeBlockForm model
    ]
  ]

