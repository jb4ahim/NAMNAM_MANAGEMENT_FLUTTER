class UploadPresignRequest {
  final String contentType;
  final int size;
  final String filename;

  UploadPresignRequest({
    required this.contentType,
    required this.size,
    required this.filename,
  });

  Map<String, dynamic> toJson() {
    return {
      'contentType': contentType,
      'size': size,
      'filename': filename,
    };
  }
}


