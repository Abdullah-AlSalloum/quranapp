class BookmarkModel {
  int? number;
  String? audio;
  String? text;
  String? textEn;

  BookmarkModel({this.number, this.audio, this.text, this.textEn});
  Map<String, dynamic> toJson() => {
        'audio': audio,
        'number': number,
        'text': text,
        'textEn': textEn,
      };

  static BookmarkModel fromJson(Map<String, dynamic> json) => BookmarkModel(
      audio: json['audio'],
      number: json['number'],
      text: json['text'],
      textEn: json['textEn']);
}
