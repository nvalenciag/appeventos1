import 'package:appeventos/app/domain/utils/config.dart';
import 'package:http/http.dart' as http;

class ActivityRestController {
  final String _url = Config.url;

  Future<http.Response?> getAllActivities(String tokenSession, String email) async {
    final String url = '$_url/AllActivities';
    
    final resp = await http.get(Uri.parse(url),headers: {"token_session": tokenSession, "user_email":email});

    if(resp.statusCode != 200){
      return null;
    }
    return resp;
  }

    Future<http.Response?> getAllActivitiesAfter(String tokenSession, String email, int page, int sizePage,String dateActivity,int idEvent) async {
    final String url = '$_url/AllActivitiesAfter';
    
    final resp = await http.get(Uri.parse(url),headers: {"token_session": tokenSession, "user_email":email, "page":page.toString(), "size_page":sizePage.toString(),"date_activity":dateActivity,"idEvent":idEvent.toString()});

    if(resp.statusCode != 200){
      return null;
    }
    return resp;
  }
}