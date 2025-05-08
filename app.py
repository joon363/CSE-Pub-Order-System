from flask import Flask, jsonify, request, make_response
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import json
import os

app = Flask(__name__)
CORS(app)


# SQLite DB 설정
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///orders.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Order 모델 정의
class Order(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    income = db.Column(db.Integer, nullable=False)
    time = db.Column(db.String(10), nullable=False)
    name = db.Column(db.String(50), nullable=False)
    menus = db.Column(db.Text, nullable=False)  # JSON 문자열로 저장
    paid = db.Column(db.Boolean, default=False)
    table_id = db.Column(db.Integer, nullable=False)

    def to_dict(self):
        return {
            "id": self.id,
            "income": self.income,
            "time": self.time,
            "name": self.name,
            "menus": json.loads(self.menus),
            "paid": self.paid,
            "tableID": self.table_id
        }

# 최초 한 번만 실행: DB 생성 (파일 없을 때만)
with app.app_context():
    if not os.path.exists("orders.db"):
        db.create_all()


# ✅ GET: 모든 주문 조회
@app.route("/orders", methods=["GET"])
def get_orders():
    all_orders = Order.query.all()
    return jsonify([o.to_dict() for o in all_orders])

# ✅ PUT: 특정 주문 수정
@app.route("/orders/<int:order_id>", methods=["PUT"])
def update_order(order_id):
    data = request.json
    order = Order.query.get(order_id)

    if not order:
        return jsonify({"success": False, "error": "Order not found"}), 404

    order.income = data["income"]
    order.time = data["time"]
    order.name = data["name"]
    order.menus = json.dumps(data["menus"])
    order.paid = data["paid"]
    order.table_id = data["tableID"]
    db.session.commit()

    return jsonify({"success": True, "updated": order.to_dict()})

# ✅ POST: 주문 추가
@app.route("/orders/new", methods=["POST"])
def create_order():
    data = request.json
    new_order = Order(
        income=data["income"],
        time=data.get("time", datetime.now().strftime("%H:%M")),
        name=data["name"],
        menus=json.dumps(data["menus"]),
        paid=data.get("paid", False),
        table_id=data["tableID"]  # ✅ 추가
    )
    db.session.add(new_order)
    db.session.commit()
    return jsonify({"success": True, "created": new_order.to_dict()}), 201


# ✅ 비밀번호 확인
CORRECT_PASSWORD = "csepub"

@app.route("/checkPassword", methods=["POST"])
def check_password():
    data = request.get_json()
    password = data.get("password")
    if password == CORRECT_PASSWORD:
        return jsonify(success=True)
    else:
        return jsonify(success=False), 401

if __name__ == "__main__":
    app.run(host="0.0.0.0")
