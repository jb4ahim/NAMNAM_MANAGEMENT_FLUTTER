class CreateCategoryRequest {
  final String name;
  final int? parentId;
  final String? imageKey;

  CreateCategoryRequest({
    required this.name,
    this.parentId,
    this.imageKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (parentId != null) 'parentId': parentId,
      if (imageKey != null) 'imageKey': imageKey,
    };
  }
}

