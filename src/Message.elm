module Message exposing (Msg(..))

import Url
import Browser
import Date
import Bits.DatePicker exposing (DateSelectorMsg(..))

type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | ReceiveDate Date.Date
    | FormUpdateValue String String
    | AddDemoDataSubmit
    | StartDateSelector DateSelectorMsg
    | EndDateSelector DateSelectorMsg
