import datetime
import random
from typing import Any, Text, Dict, List

import shortuuid
from rasa_sdk import Action, Tracker
from rasa_sdk.events import SlotSet
from rasa_sdk.executor import CollectingDispatcher

from actions.util import *
import jsonpickle


#
#   Data classes
#

class MenuItem:
    def __init__(self, name: str, price: int, preparation_time: str):
        self.name = name
        self.price = price
        self.preparation_time = preparation_time

    def __str__(self) -> str:
        return f"{self.name} | {self.price}$"


class Order:
    NUMBER = "order_number"
    ITEMS = "order_items"
    ADDITIONS = "order_additions"

    def __init__(self, number: int, items: list[MenuItem], additions: list[str], ready_time: datetime.datetime):
        self.number = number
        self.items = items
        self.additions = additions
        self.ready_time = ready_time


#
#   Fields
#

def load_menu():
    items = read_json('./restaurant/menu.json')['items']
    for item in items:
        menu[item['name']] = MenuItem(
            name=item['name'],
            price=int(item['price']),
            preparation_time=item['preparation_time']
        )


menu = {}
load_menu()

orders: list[Order] = []


#
#   Actions
#

class OrderAction(Action):
    def name(self) -> Text:
        return "action_order"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        items = next(tracker.get_latest_entity_values(Order.ITEMS), None)
        try:
            items = items.split(',')
        except:
            items = None

        # if no items provided
        if items is None:
            response = "We have no meals that you provided. Check the menu first, please."
            dispatcher.utter_message(text=response)
            return []

        order_items = []
        for item in items:
            if item.lower().capitalize() in menu:
                order_items.append(menu[item.lower().capitalize()])

        # if no available items provided
        if len(order_items) == 0:
            response = "We have no meals that you provided. Check the menu first, please."
            dispatcher.utter_message(text=response)
            return []

        response = f"[Order]\n\n"
        for i, item in enumerate(order_items):
            response += f"{i + 1} | {item}\n"

        additions = next(tracker.get_latest_entity_values(Order.ADDITIONS), None)
        try:
            additions = additions.split(',')
        except:
            additions = None

        if additions is not None:
            response += f"Additions: {','.join(additions)}\n"

        response += "\nIs everything right?"

        dispatcher.utter_message(text=response)
        return [
            SlotSet(Order.ITEMS, jsonpickle.encode(order_items)),
            SlotSet(Order.ADDITIONS, additions),
        ]


class OrderConfirmAction(Action):
    def name(self) -> Text:
        return "action_order_confirm"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        number = random.randint(1, 99)
        items = jsonpickle.decode(str(tracker.get_slot(Order.ITEMS)))
        additions = tracker.get_slot(Order.ADDITIONS)
        additions = list(additions) if additions is not None else []

        max_preparation_time = float(max(items, key=lambda it: float(it.preparation_time)).preparation_time)
        ready_time = datetime.datetime.now() + datetime.timedelta(seconds=int(max_preparation_time * 60))

        order = Order(number, items, additions, ready_time)
        orders.append(order)

        response = f"Your order with number [{number}] has been placed successfully.\n\n"
        dispatcher.utter_message(text=response)
        return []


class OrderCheckAction(Action):
    def name(self) -> Text:
        return "action_order_check"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        if len(orders) == 0:
            response = "Sorry. There are no orders placed at the moment."
            dispatcher.utter_message(text=response)
            return []

        number = next(tracker.get_latest_entity_values(Order.NUMBER), None)
        if number is None:
            response = "Sorry. To check the order status you have to provide order number."
            dispatcher.utter_message(text=response)
            return []

        number = int(number)
        order = next((o for o in orders if o.number == number), None)
        if order is None:
            response = f"Sorry. There is no order with number {number}. Check the number and try again."
            dispatcher.utter_message(text=response)
            return []

        this_time = datetime.datetime.now()
        if this_time >= order.ready_time:
            response = f"Your order {number} is ready for pick-up."
            orders.remove(order)
        else:
            response = f"Your order is not ready yet. You have to wait approximately {(order.ready_time - this_time).seconds / 60} minutes."

        dispatcher.utter_message(text=response)
        return []
