import 'package:appeventos/app/domain/entities/activity.dart';
import 'package:equatable/equatable.dart';

class AllActivities extends Equatable {
  final List<Activity> activity;

  const AllActivities({required this.activity});

  AllActivities copyWith({List<Activity>? activity}) =>
      AllActivities(activity: activity ?? this.activity);

  factory AllActivities.fromJson(List<dynamic> json){
    final activity = json.map((e) => Activity.fromJson(e)).toList();
    return AllActivities(activity: activity);
  }

  @override
  List<Object?> get props => [activity];
}
