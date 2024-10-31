// lib/memo.dart

class Memo {
  String title;
  String content;
  DateTime date;

  Memo({
    required this.title,
    required this.content,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();

  // JSON 변환 메서드
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  // JSON에서 객체 생성하는 메서드
  factory Memo.fromJson(Map<String, dynamic> json) {
    return Memo(
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }
}