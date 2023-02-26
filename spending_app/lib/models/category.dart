class Category {
    Category({
        required this.id,
        required this.uid,
        required this.money,
        required this.category,
        required this.type,
        required this.note,
        required this.time,
        required this.image,
    });

     String id;
     String uid;
     int money;
     String category;
     String type;
     String note;
     DateTime time;
     bool image;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        uid: json["uid"],
        money: json["money"],
        category: json["category"],
        type: json["type"],
        note: json["note"],
        time: DateTime.parse(json["time"]),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "money": money,
        "category": category,
        "type": type,
        "note": note,
        "time": time.toIso8601String(),
        "image": image,
    };
}