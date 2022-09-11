class ListFilter {
  final DateTime? before;

  final DateTime? after;

  final SortRule sortRule;

  final SortOrder sortOrder;

  final int page;

  final int size;

  const ListFilter({
    required this.page,
    required this.size,
    required this.sortRule,
    required this.sortOrder,
    this.before,
    this.after,
  });

  Map<String, String> get toQueryParameters {
    return {
      'sortBy': sortRule.query,
      'sortOrder': sortOrder.query,
      'page': page.toString(),
      'size': size.toString(),
      if (before != null) 'before': before!.toIso8601String(),
      if (after != null) 'after': after!.toIso8601String(),
    };
  }
}

enum SortRule {
  name('Name'),
  date('Date');

  final String query;

  const SortRule(this.query);
}

enum SortOrder {
  asc('Asc'),
  desc('Desc');

  final String query;

  const SortOrder(this.query);
}
