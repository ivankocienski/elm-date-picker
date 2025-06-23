module Model exposing (Model, makeModel, TimeBlock, defaultDate, makeTimeBlockFromForm)

import Browser.Navigation as Nav
import Date
import Time

import Bits.Form as Form

type alias TimeBlock =
  { description : String
  , duration : Int
  , date : Date.Date
  }

type alias Model =
    { navKey : Nav.Key
    , today : Date.Date
    , timeBlocks: List TimeBlock
    , timeBlockForm: Form.Form
    , dateSelector : Maybe Date.Date
    }

sampleTimeBlocks : List TimeBlock
sampleTimeBlocks =
  [ TimeBlock "alpha" 10 defaultDate
  , TimeBlock "beta" 15 defaultDate
  , TimeBlock "cappa" 60 defaultDate
  ]

makeModel: Nav.Key -> Model
makeModel nav =
  Model nav defaultDate sampleTimeBlocks Form.emptyForm Nothing

defaultDate : Date.Date
defaultDate =
  Date.fromCalendarDate 2000 Time.Jan 1

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
