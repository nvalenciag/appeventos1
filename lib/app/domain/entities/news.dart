import 'package:equatable/equatable.dart';

class News extends Equatable{
  final int id;
  final String title;
  final String description;
  final String urlNewsContent;
  final String urlPreviewPhoto;
  final DateTime dateCreation;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.urlNewsContent,
    required this.urlPreviewPhoto,
    required this.dateCreation,
  });

  News copyWith({
  int? id,
  String? title,
  String? description,
  String? urlNewsContent,
  String? urlPreviewPhoto,
  DateTime? dateCreation,
  }) => News(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    urlNewsContent: urlNewsContent ?? this.urlNewsContent,
    urlPreviewPhoto: urlPreviewPhoto ?? this.urlPreviewPhoto,
    dateCreation: dateCreation ?? this.dateCreation
  );


    factory News.fromJson(Map<String, dynamic> json) {
      print(json);
    return News(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      urlNewsContent: json['content'],
      urlPreviewPhoto: json['previewPhoto'],
      dateCreation: DateTime.parse(json['date'])
    );
  }
 
  @override
  List<Object?> get props => [
    id,
    title,
    description,
    urlNewsContent,
    urlPreviewPhoto,
    dateCreation
  ];
}
