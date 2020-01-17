module Misc exposing (..)

import Array
import List exposing (..)
import List.Extra as LE
import String
import Time exposing (Month(..), Weekday(..), utc)
import Time.Extra exposing (Interval(..), Parts, partsToPosix, posixToParts)


months =
    [ Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec ]


weekdats =
    [ Mon, Tue, Wed, Thu, Fri, Sat, Sun ]


getDayOfMonth year month =
    Parts year month 1 0 0 0 0 |> partsToPosix utc |> Time.Extra.add Month 1 utc |> Time.Extra.add Day -1 utc |> Time.Extra.posixToParts utc |> .day


getNumOfWeekday year month day =
    Parts year month day 0 0 0 0 |> partsToPosix utc |> Time.toWeekday utc


weekdayToNum weekday =
    case weekday of
        Mon ->
            0

        Tue ->
            1

        Wed ->
            2

        Thu ->
            3

        Fri ->
            4

        Sat ->
            5

        Sun ->
            6


monthToNum month =
    case month of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            0

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


getWeeks year month =
    let
        dom =
            getDayOfMonth year month

        topWd =
            getNumOfWeekday year month 1 |> weekdayToNum

        btmWd =
            getNumOfWeekday year month dom |> weekdayToNum

        days =
            concat [ repeat topWd 0, range 1 dom, repeat (6 - btmWd) 0 ]
    in
    LE.groupsOf 7 days


getTimeParts str =
    let
        numbers =
            str |> String.split "/" |> map String.toInt |> map (Maybe.withDefault 0) |> take 3

        amonths =
            Array.fromList months

        toMonth imonth =
            Maybe.withDefault Jan (Array.get (imonth - 1) amonths)
    in
    case numbers of
        y :: m :: d :: _ ->
            Parts y (toMonth m) d 0 0 0 0

        _ ->
            Parts 1970 Jan 1 0 0 0 0
