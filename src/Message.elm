module Message exposing (Msg(..))

import Bits.DatePicker exposing (DateSelectorMsg(..))
import Date


type Msg
    = ReceiveDate Date.Date
    | FormUpdateValue String String
    | AddDemoDataSubmit
    | StartDateSelector DateSelectorMsg
    | EndDateSelector DateSelectorMsg
