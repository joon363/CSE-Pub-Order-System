from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# 더미 데이터
orders = [
    {
        "id": 1,
        "time": "12:01",
        "name": "홍길동",
        "menus": {
            "menu1": {"count": 2, "checked": [False, False]},
            "menu2": {"count": 1, "checked": [False]},
            "menu3": {"count": 0, "checked": []}
        },
        "paid": False
    },
    {
        "id": 2,
        "time": "12:05",
        "name": "김철수",
        "menus": {
            "menu1": {"count": 1, "checked": [False]},
            "menu2": {"count": 0, "checked": []},
            "menu3": {"count": 2, "checked": [False, False]}
        },
        "paid": False
    }
]

@app.route("/orders", methods=["GET"])
def get_orders():
    return jsonify(orders)

@app.route("/orders/<int:order_id>/toggle", methods=["POST"])
def toggle_check(order_id):
    data = request.json
    menu_key = data.get("menu")
    index = data.get("index")

    for order in orders:
        if order["id"] == order_id and menu_key in order["menus"]:
            try:
                current = order["menus"][menu_key]["checked"][index]
                order["menus"][menu_key]["checked"][index] = not current
                return jsonify({"success": True, "new_state": not current})
            except IndexError:
                return jsonify({"success": False, "error": "Index out of range"}), 400

    return jsonify({"success": False, "error": "Order or menu not found"}), 404

@app.route("/orders/<int:order_id>/confirm", methods=["POST"])
def toggle_payment(order_id):
    for order in orders:
        if order["id"] == order_id:
            order["paid"] = not order["paid"]
            return jsonify({"success": True, "paid": order["paid"]})
    return jsonify({"success": False, "error": "Order not found"}), 404

if __name__ == "__main__":
    app.run(debug=True)
