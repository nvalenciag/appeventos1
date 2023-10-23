import '../entities/event.dart';

abstract class EventService{
  
  Future<List<Event>?> getEventRencents(int page, int sizePage,String date);
  Future<bool> changeAttendance(int idEvent, String email,bool attendance);

  
}