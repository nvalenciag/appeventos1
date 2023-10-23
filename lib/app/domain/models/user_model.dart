

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
       
        required this.name,
        required this.email,
        required this.photo,
        required this.accountCreationDate,

    });

    
    String? name;
    String? email;
    String? photo;
    String? accountCreationDate;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      
        name: json["name"],
        email: json["email"],    
        photo: json["photo"],
        accountCreationDate: json["creationDate"]
    );

    Map<String, dynamic> toJson() => {
       
        "name": name,
        "email": email,
        "photo": photo,
        "accountCreationDate": accountCreationDate,
    };
}
