module Model exposing (Model, makeModel, defaultDate)

import Browser.Navigation as Nav
import Date
import Time

import Bits.Form as Form

type alias Model =
    { navKey : Nav.Key
    , today : Date.Date
    , demoForm: Form.Form
    , startDateSelector : Maybe Date.Date
    , endDateSelector : Maybe Date.Date
    , output : String
    }

makeModel: Nav.Key -> Model
makeModel nav =
  Model nav defaultDate Form.emptyForm Nothing Nothing""

defaultDate : Date.Date
defaultDate =
  Date.fromCalendarDate 2000 Time.Jan 1

{-
makeTimeBlockFromForm : Form.Form -> TimeBlock
makeTimeBlockFromForm form =
  let
    descriptionValue = Form.formValue form "description" ""
    dateValue = Form.formValue form "date" ""
    durationValue = Form.formValue form "duration" ""

  in
  TimeBlock
    (String.trim descriptionValue)
    (Maybe.withDefault 0 <| String.toInt durationValue)
    (Result.withDefault defaultDate <| Date.fromIsoString dateValue)
-}
