import 'package:appeventos/app/domain/entities/event.dart';
import 'package:equatable/equatable.dart';

import '../entities/event.dart';

class ListEvent extends Equatable{

  final List<Event> listEvent;

  const ListEvent({required this.listEvent});

  ListEvent copyWith({List<Event>? event}) =>
      ListEvent(listEvent: event ?? listEvent);

    factory ListEvent.fromJson(List<dynamic> json){
    final listEvent = json.map((e) => Event.fromJson(e)).toList();
    return ListEvent(listEvent: listEvent);
  }
  
  @override
  List<Object?> get props => [listEvent];

}