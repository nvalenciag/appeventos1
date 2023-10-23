import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final int id;
  final String title;
  final String description;
  final String eventType;
  final String photo;
  final String eventState;
  final String place;
   bool attendance;
   final DateTime date;

  Event(
      {required this.id,
      required this.title,
      required this.description,
      required this.eventType,
      required this.photo,
      required this.eventState,
      required this.place,
      required this.attendance,
      required this.date});

  Event copyWith({
    int? id,
    String? title,
    String? description,
    String? eventType,
    String? photo,
    String? eventState,
    String? place,
    bool? attendance,
    DateTime? date
  }) =>
      Event(
          id: id ?? this.id,
          title: title ?? this.title,
          description: description ?? this.description,
          eventType: eventType ?? this.eventType,
          photo: photo ?? this.photo,
          eventState: eventState ?? this.eventState,
          place: place ?? this.place,
          attendance: attendance ?? this.attendance,
          date: date ?? this.date       );

  factory Event.fromJson(Map<String, dynamic> json) {
    print(json);
    return Event(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        eventType: json['eventType'],
        photo: json['photo'],
        eventState: json['eventState'],
        place: json['place'],
        attendance: json['attendance'],
        date: DateTime.parse(json['date'])
        );
  }

  @override
  List<Object?> get props =>
      [id, title, description, eventType, photo, eventState, place, attendance,date];
}
