class Post {
  Post({
    this.id,
    this.expenseTitle,
    this.amount,
    this.date,
  });

  int? id;
  String? expenseTitle;
  int? amount;
  String? date;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        expenseTitle: json["expenseTitle"],
        amount: json["amount"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "expenseTitle": expenseTitle,
        "amount": amount,
        "date": date,
      };
}
