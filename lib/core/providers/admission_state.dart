class AdmissionState {
  final bool isLoading;
  final String? message;
  final bool isSuccess;

  AdmissionState({
    required this.isLoading,
    required this.isSuccess,
    this.message,
  });

  factory AdmissionState.initial() => AdmissionState(
        isLoading: false,
        isSuccess: false,
        message: null,
      );

  AdmissionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? message,
  }) {
    return AdmissionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message ?? this.message,
    );
  }
}
