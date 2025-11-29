import '../models/api_response.dart';

/// Base repository interface for data sources
abstract class BaseRepository<T> {
  /// Get all items
  Future<ApiResponse<List<T>>> getAll();
  
  /// Get item by ID
  Future<ApiResponse<T>> getById(String id);
  
  /// Create new item
  Future<ApiResponse<T>> create(T item);
  
  /// Update existing item
  Future<ApiResponse<T>> update(String id, T item);
  
  /// Delete item by ID
  Future<ApiResponse<bool>> delete(String id);
  
  /// Search items with query
  Future<ApiResponse<List<T>>> search(String query);
  
  /// Get paginated items
  Future<ApiResponse<List<T>>> getPaginated({
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder,
  });
}
