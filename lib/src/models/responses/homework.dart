class HomeworkResponse {
  final int classId;
  final bool hasChanges;
  final String name;

  HomeworkResponse.fromJson(Map<String, dynamic> json)
      : classId = json['class_id'],
        hasChanges = json['has_changes'],
        name = json['name'];
}

class HomeworksResponse {
  final List<HomeworkResponse> items;

  HomeworksResponse.fromJson(Map<String, dynamic> json)
      : items = (json['items'] as List)
            .map((e) => HomeworkResponse.fromJson(e))
            .toList();
}
