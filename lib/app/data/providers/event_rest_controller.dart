import '../../domain/utils/config.dart';
import 'package:http/http.dart' as http;

class EventRestController {
  final String _url = Config.url;

  Future<http.Response?> getEventRecents(String tokenSession, String email,
      int page, int sizePage, String date) async {
    final String url = '$_url/EventRecents';
    final resp = await http.get(Uri.parse(url), headers: {
      "token_session": tokenSession,
      "user_email": email,
      "page": page.toString(),
      "size_page": sizePage.toString(),
      "date": date
    });
    print("pppppppppppppppppppppppppppppppppppp");
    print(resp.statusCode);
    if(resp.statusCode==401 ){

        throw "No autorizado para traer los eventos";

    }
    if (resp.statusCode != 200) {
      return null;
    }

    return resp;
  }

  Future<http.Response?> changeAttendance(
      int idEvent, String email, String tokenSession) async {
    final String url = '$_url/Attendance';

    final resp = await http.post(Uri.parse(url), headers: {
      "user_email": email,
      "id_event": idEvent.toString(),
      "token_session": tokenSession
    });
    if (resp.statusCode != 200) {
      return null;
    }

    return resp;
  }
}
