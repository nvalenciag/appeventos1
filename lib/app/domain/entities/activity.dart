import 'package:equatable/equatable.dart';

class Activity extends Equatable {
  final int id;
  final String title;
  final DateTime date;
  final int duration;
  final String room;
  final String authors;

  Activity(
      {required this.id,
      required this.title,
      required this.date,
      required this.duration,
      required this.room,
      required this.authors});

  Activity copyWith({
    int? id,
    String? title,
    DateTime? date,
    int? duration,
    String? room,
    String? authors,
  }) =>
      Activity(
        id: id ?? this.id,
        title: title ?? this.title,
        date: date ?? this.date,
        duration: duration ?? this.duration,
        room: room ?? this.room,
        authors: authors ?? this.authors
      );

  factory Activity.fromJson(Map<String, dynamic> json) {
  
    return Activity(
        id: json['id'],
        title: json['title'],
        date: DateTime.parse(json['date']),
        duration: json['duration'],
        room: json['room'],
        authors: json['authors']);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        date,
        duration,
        room,
        authors,
      ];
}
