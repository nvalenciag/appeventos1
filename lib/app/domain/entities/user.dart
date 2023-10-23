import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String name;
  final String email;
  final String photo;
  final DateTime accountCreationDate;

  const User(
      {required this.name,
      required this.email,
      required this.photo,
      required this.accountCreationDate});

  User copyWith({
    String? name,
    String? email,
    String? photo,
    DateTime? accountCreationDate,
  }) =>
      User(
        name: name ?? this.name,
        email: email ?? this.email,
        photo: photo ?? this.photo,
        accountCreationDate: accountCreationDate ?? this.accountCreationDate,
      );

  @override
  List<Object?> get props => [
        name,
        email,
        photo,
        accountCreationDate,
      ];
}
