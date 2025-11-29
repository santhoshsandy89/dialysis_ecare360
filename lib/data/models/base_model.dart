/// Base model class for all data models
abstract class BaseModel {
  /// Convert model to JSON
  Map<String, dynamic> toJson();
  
  /// Create model from JSON
  static BaseModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson must be implemented by subclasses');
  }
  
  /// Create a copy of the model with updated fields
  BaseModel copyWith();
  
  /// Compare two models for equality
  @override
  bool operator ==(Object other);
  
  /// Generate hash code for the model
  @override
  int get hashCode;
  
  /// String representation of the model
  @override
  String toString();
}
