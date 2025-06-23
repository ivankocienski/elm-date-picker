module Model exposing (Model, makeModel, defaultDate)

import Date
import Time

import Bits.Form as Form

type alias Model =
    { today : Date.Date
    , demoForm: Form.Form
    , startDateSelector : Maybe Date.Date
    , endDateSelector : Maybe Date.Date
    , output : String
    }

makeModel: Model
makeModel =
  Model defaultDate Form.emptyForm Nothing Nothing ""

defaultDate : Date.Date
defaultDate =
  Date.fromCalendarDate 2000 Time.Jan 1
