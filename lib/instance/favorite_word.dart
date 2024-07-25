class FavoriteWord {
  late String first;
  late String second;
  late String uuid;
  late String createAt = '';

  FavoriteWord({required this.first, required this.second, required this.uuid});

  FavoriteWord.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    second = json['second'];
    uuid = json['uuid'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['first'] = first;
    map['second'] = second;
    map['uuid'] = uuid;

    return map;
  }
}
