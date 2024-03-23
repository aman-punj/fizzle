class Message {
  final String userId;
  final String text;
  final DateTime time;

  Message({
    required this.userId,
    required this.text,
    required this.time,
  });

  factory Message.fromMap(Map<dynamic, dynamic> map) {
    return Message(
      userId: map['userId'],
      text: map['text'],
      time: DateTime.parse(map['time']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'time': time.toIso8601String(),
    };
  }
}
