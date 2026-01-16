import 'character_model.dart';

/// Response model for paginated character list
class CharacterResponseModel {
  final CharacterInfoModel info;
  final List<CharacterModel> results;

  const CharacterResponseModel({
    required this.info,
    required this.results,
  });

  /// Create from JSON
  factory CharacterResponseModel.fromJson(Map<String, dynamic> json) {
    return CharacterResponseModel(
      info: CharacterInfoModel.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List)
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Check if there's a next page
  bool get hasNextPage => info.next != null;

  /// Check if there's a previous page
  bool get hasPreviousPage => info.prev != null;

  /// Get current page number from next/prev URL
  int get currentPage {
    if (info.next != null) {
      final uri = Uri.parse(info.next!);
      final nextPage = int.tryParse(uri.queryParameters['page'] ?? '2') ?? 2;
      return nextPage - 1;
    }
    if (info.prev != null) {
      final uri = Uri.parse(info.prev!);
      final prevPage = int.tryParse(uri.queryParameters['page'] ?? '1') ?? 1;
      return prevPage + 1;
    }
    return 1;
  }
}

/// Info model for pagination metadata
class CharacterInfoModel {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const CharacterInfoModel({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  /// Create from JSON
  factory CharacterInfoModel.fromJson(Map<String, dynamic> json) {
    return CharacterInfoModel(
      count: json['count'] as int,
      pages: json['pages'] as int,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }
}
