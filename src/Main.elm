module Main exposing (main)

import Browser
import Url
import Browser.Navigation as Nav
import Message exposing (Msg(..))
import Model exposing (Model, makeModel)
import View
import Bits.Form as Form
import Bits.DatePicker exposing (updateDateSelector, selectDateFromDateSelector)
import Date
import Task
import Platform.Cmd as Cmd
import Platform.Cmd as Cmd

init : flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ _ navKey =
    ( makeModel navKey
    , Date.today |> Task.perform ReceiveDate
    )

prettyPrintDemoForm : Form.Form -> String
prettyPrintDemoForm form =
    let
        parts =
            [ "Start : " ++ (Form.formValue form "startDate" "")
            , "End : " ++ (Form.formValue form "endDate" "")
            , "Title : " ++ (Form.formValue form "title" "")
            ]
    in
        (String.join "\n" parts) ++ "\n\n"


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
            ( { model | demoForm = Form.updateFormValue model.demoForm key value }
            , Cmd.none
            )

        AddDemoDataSubmit ->
            ( { model
              | output = (model.output ++ (prettyPrintDemoForm model.demoForm))
              , demoForm = Form.emptyForm
              }
            , Cmd.none)

        StartDateSelector selectorMsg ->
            let
              newModel =
                selectDateFromDateSelector
                  selectorMsg
                  model
                  (\newDate appModel ->
                    { appModel
                    | demoForm = Form.updateFormValue appModel.demoForm "startDate" <| Date.toIsoString newDate
                    }
                  )
              defaultDate =
                  Form.formValue model.demoForm "startDate" ""
                  |> Date.fromIsoString
                  |> Result.withDefault model.today

            in
            ( { newModel | startDateSelector = updateDateSelector selectorMsg model.startDateSelector defaultDate }
            , Cmd.none
            )

        EndDateSelector selectorMsg ->
            let
              newModel =
                selectDateFromDateSelector
                  selectorMsg
                  model
                  (\newDate appModel ->
                    { appModel
                    | demoForm = Form.updateFormValue appModel.demoForm "endDate" <| Date.toIsoString newDate
                    }
                  )
              defaultDate =
                  Form.formValue model.demoForm "endDate" ""
                  |> Date.fromIsoString
                  |> Result.withDefault model.today

            in
            ( { newModel | endDateSelector = updateDateSelector selectorMsg model.endDateSelector defaultDate }
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
