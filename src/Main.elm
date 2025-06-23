module Main exposing (main)

import Browser
import Url
import Browser.Navigation as Nav
import Message exposing (Msg(..))
import Model exposing (Model, makeModel, makeTimeBlockFromForm)
import View
import Model exposing (TimeBlock)
import Bits.Form as Form
import Bits.DatePicker exposing (updateDateSelector, selectDateFromDateSelector)
import Date
import Task

init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ _ navKey =
    ( makeModel navKey
    , Date.today |> Task.perform ReceiveDate
    )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged _ ->
            ( model
            , Cmd.none
            )

        ReceiveDate date ->
            ( { model | today = date }
            , Cmd.none
            )

        FormUpdateValue key value ->
            ( { model | timeBlockForm = Form.updateFormValue model.timeBlockForm key value }
            , Cmd.none
            )

        AddTimeBlockSubmit ->
            let
                newTimeBlock : TimeBlock
                newTimeBlock =
                  makeTimeBlockFromForm model.timeBlockForm

            in
            ( { model
              | timeBlocks = newTimeBlock :: model.timeBlocks
              , timeBlockForm = Form.emptyForm
              }
            , Cmd.none)

        DateSelector selectorMsg ->
            let
              newModel =
                selectDateFromDateSelector
                  selectorMsg
                  model
                  (\newDate appModel ->
                    { appModel
                    | timeBlockForm = Form.updateFormValue appModel.timeBlockForm "date" <| Date.toIsoString newDate
                    }
                  )
              defaultDate =
                  Form.formValue model.timeBlockForm "date" ""
                  |> Date.fromIsoString
                  |> Result.withDefault model.today


            in
              ( { newModel | dateSelector = updateDateSelector selectorMsg model.dateSelector defaultDate }
              , Cmd.none
              )


view : Model -> Browser.Document Msg
view model =
    { title = View.titleForPage model
    , body = View.renderPageBody model
    }


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
