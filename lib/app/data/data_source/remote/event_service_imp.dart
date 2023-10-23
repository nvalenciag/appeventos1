import 'dart:convert';

import 'package:appeventos/app/data/repositories_impl/user_authentication_service_impl.dart';
import 'package:http/http.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/repositories/event_service.dart';
import '../../../domain/responses/list_event.dart';
import '../../providers/event_rest_controller.dart';

class EventServiceImpl implements EventService {
  final UserAuthenticationServiceImpl userAuth;
  EventServiceImpl({required this.userAuth});

  EventRestController eventRest = EventRestController();

  @override
  Future<List<Event>?> getEventRencents(
      int page, int sizePage, String date) async {
    print("entra al impl");
    Response? response = await eventRest.getEventRecents(
        userAuth.tokenSession, userAuth.user!.email, page, sizePage, date);
    if (response == null) {
      return null;
    }

    List<dynamic> json = jsonDecode(response.body);

    return ListEvent.fromJson(json).listEvent;
  }

  @override
  Future<bool> changeAttendance(
      int idEvent, String email, bool attendance) async {
    Response? response =
        await eventRest.changeAttendance(idEvent, email, userAuth.tokenSession);

    if (response?.body == null) {
      return false;
    } else {
      return jsonDecode(response!.body);
    }
  }
}
