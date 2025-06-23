module Message exposing (Msg(..))

import Date
import Bits.DatePicker exposing (DateSelectorMsg(..))

type Msg
    = ReceiveDate Date.Date
    | FormUpdateValue String String
    | AddDemoDataSubmit
    | StartDateSelector DateSelectorMsg
    | EndDateSelector DateSelectorMsg
