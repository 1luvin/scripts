from __future__ import print_function

from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher

from actions.util import *


class WorkingHours(Action):
    def name(self) -> Text:
        return "action_working_hours"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        working_hours = read_json('./restaurant/working_hours.json')['items']

        day = next(tracker.get_latest_entity_values('day'), None)
        # if no day provided, showing all days
        if day is None:
            response = "[Working hours]\n\n"
            for key, value in working_hours.items():
                response += f"{key} | "
                if value['open'] == value['close']:
                    response += "CLOSED"
                else:
                    response += f"{value['open']}:00 – {value['close']}:00\n"

            dispatcher.utter_message(text=response)
            return []

        days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
        day = find_similar_string(day, days)
        hours_in_day = working_hours[day]

        # if open time = close time, the restaurant is closed
        open_time = hours_in_day['open']
        close_time = hours_in_day['close']
        if open_time == close_time:
            response = f"We do not work on {day}s."
            dispatcher.utter_message(text=response)
            return []

        time = next(tracker.get_latest_entity_values('time'), None)
        try:
            time = int(time)
        except:
            time = None

        # if no time provided, showing whole day worktime
        if time is None or not (0 <= time <= 24):
            response = f'On {day} we work from {open_time} to {close_time}.'
            dispatcher.utter_message(text=response)
            return []

        if open_time <= time <= close_time:
            response = f"We are OPEN on {day} at {time}."
        else:
            response = f"We are CLOSED on {day} at {time}."

        dispatcher.utter_message(text=response)
        return []
