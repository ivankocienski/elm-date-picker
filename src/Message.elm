module Message exposing (Msg(..))

import Url
import Browser
import Date
import Bits.DatePicker exposing (DateSelectorMsg(..))

type Msg
    = LinkClicked Browser.UrlRequest
    | ReceiveDate Date.Date
    | UrlChanged Url.Url
    | FormUpdateValue String String
    | AddTimeBlockSubmit
    | DateSelector DateSelectorMsg
