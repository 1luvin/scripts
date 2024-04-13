from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher

from actions.util import *


class Menu(Action):
    def name(self) -> Text:
        return "action_menu"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        menu = read_json('./restaurant/menu.json')['items']
        response = "[Menu]\n\n"
        for i, item in enumerate(menu):
            response += f'{i + 1} | {item["name"]} | {item["price"]}$\n'

        dispatcher.utter_message(text=response)
        return []
