class ImageIds {
  String id;

  ImageIds(this.id);

  ImageIds.fromJson(Map<String, dynamic> json) : id = json['_id'];

  Map<String, dynamic> toJson() => {
        '_id': id,
      };
}
