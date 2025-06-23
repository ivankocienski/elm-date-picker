module Bits.DatePicker exposing (dateSelectWidget, DateSelectorMsg, updateDateSelector, selectDateFromDateSelector)

import Html exposing (Html, text, button, table, thead, tbody, tr, th, td, div, span, h6)
import Html.Attributes exposing (type_, disabled, class, style)
import Html.Events exposing (onClick)
import Bits.Icons exposing (calendarIcon)
import Date

type DateSelectorMsg
    = Toggle
    | PrevYear
    | NextYear
    | PrevMonth
    | NextMonth
    | Reset
    | Select Date.Date

dateSelectWidget : Date.Date -> Maybe Date.Date -> (DateSelectorMsg -> msg) -> Html msg
dateSelectWidget today maybeSelectorValue msgWrapper =
  let

    calendarDay = Maybe.withDefault today maybeSelectorValue

    start = Date.floor Date.Week (Date.floor Date.Month calendarDay)

    lastDay = Date.floor Date.Month (Date.add Date.Months 1 calendarDay)

    -- from today, go to start of month, then add one month, then subtract one day
    -- add one month, round to start of month, subtract day

    renderDay : Date.Date -> Html msg
    renderDay dayDate =
      let
        dayText : String
        dayText =
          if (Date.month dayDate) == (Date.month calendarDay) then
            String.fromInt (Date.day dayDate)
          else
            ""

        monthClass : String
        monthClass =
          if (Date.month dayDate) == (Date.month calendarDay) then
            "current"
          else
            ""

        dayClass : String
        dayClass =
          if dayDate == today then
            "today"
          else
            ""
      in
        td
          [ class monthClass
          , class dayClass
          , onClick <| msgWrapper <| Select dayDate
          ]
          [ text dayText ]

    renderWeek : Date.Date -> Html msg
    renderWeek startOfWeek =
      let
        endOfWeek = Date.add Date.Weeks 1 startOfWeek

      in
        tr []
          (List.map renderDay (Date.range Date.Day 1 startOfWeek endOfWeek))

    renderDataSelector : Html msg
    renderDataSelector =
      let
        disableReset : Date.Date -> Bool
        disableReset day =
          Date.month day == Date.month today
          && Date.year day == Date.year today

      in
      case maybeSelectorValue of
          Just date ->
            div [ class "date-selector-popup" ]
              [ div [ class "controls" ]
                [ button [ onClick (msgWrapper PrevYear), class "button", type_ "button" ] [ text "<<"]
                , button [ onClick (msgWrapper PrevMonth), class "button", type_ "button" ] [ text "<"]
                , button [ onClick (msgWrapper Reset), class "button", disabled (disableReset date), type_ "button" ] [ text "today"]
                , button [ onClick (msgWrapper NextMonth), class "button", type_ "button" ] [ text ">"]
                , button [ onClick (msgWrapper NextYear), class "button", type_ "button" ] [ text ">>"]
                ]
              , h6 [] [ text <| Date.format "MMMM y" date ]
              , table [ class "table is-bordered date-selector" ]
                  [ thead []
                    [ tr []
                      [ th [] [ text "M" ]
                      , th [] [ text "T" ]
                      , th [] [ text "W" ]
                      , th [] [ text "T" ]
                      , th [] [ text "F" ]
                      , th [] [ text "S" ]
                      , th [] [ text "S" ]
                      ]
                    ]
                  , tbody [] (List.map renderWeek (Date.range Date.Day 7 start lastDay))
                  ]
              ]

          Nothing ->
            text ""
  in
  div [ style "position" "relative" ]
    [ button [ onClick (msgWrapper Toggle), class "button", type_ "button" ]
      [ calendarIcon
      , span [ style "padding-left" "0.5em" ] [ text "Select" ]
      ]
    , renderDataSelector
    ]


updateDateSelector : DateSelectorMsg -> Maybe Date.Date -> Date.Date -> Maybe Date.Date
updateDateSelector selectorMsg dateValue defaultDate =
    case selectorMsg of
        Toggle ->
            case dateValue of
                Just _ ->
                  Nothing

                Nothing ->
                  Just defaultDate

        Reset ->
            Just defaultDate

        PrevYear ->
            Maybe.map (Date.add Date.Years -1) dateValue

        NextYear ->
            Maybe.map (Date.add Date.Years 1) dateValue

        PrevMonth ->
            Maybe.map (Date.add Date.Months -1) dateValue

        NextMonth ->
            Maybe.map (Date.add Date.Months 1) dateValue

        Select _ ->
            Nothing

selectDateFromDateSelector : DateSelectorMsg -> model -> (Date.Date -> model -> model) -> model
selectDateFromDateSelector selectorMsg model updaterFunction =
    case selectorMsg of
        Select newDate ->
            updaterFunction newDate model

        _ ->
            model
