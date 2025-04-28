from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# 더미 데이터
orders = [
    {
        "id": 1,
        "income": 10000,
        "time": "12:01",
        "name": "홍길동",
        "menus": {
            "menu1": {"count": 2, "checked": False},
            "menu2": {"count": 1, "checked": False},
            "menu3": {"count": 0, "checked": False}
        },
        "paid": False
    },
    {
        "id": 2,
        "income": 20000,
        "time": "12:05",
        "name": "김철수",
        "menus": {
            "menu1": {"count": 1, "checked": False},
            "menu2": {"count": 0, "checked": False},
            "menu3": {"count": 2, "checked": False}
        },
        "paid": False
    }
]

@app.route("/orders", methods=["GET"])
def get_orders():
    return jsonify(orders)

@app.route("/orders/<int:order_id>", methods=["PUT"])
def update_order(order_id):
    data = request.json

    for i, order in enumerate(orders):
        if order["id"] == order_id:
            orders[i] = data
            return jsonify({"success": True, "updated": data})

    return jsonify({"success": False, "error": "Order not found"}), 404


@app.route("/orders/new", methods=["POST"])
def create_order():
    data = request.json

    # 새로운 ID 부여: 가장 마지막 ID보다 1 큰 값
    new_id = max(order["id"] for order in orders) + 1 if orders else 1
    data["id"] = new_id

    orders.append(data)
    return jsonify({"success": True, "created": data}), 201

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
