import 'package:get/get.dart';

abstract class BaseViewModel extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  void setLoading(bool value) => isLoading.value = value;
  void setError(String value) => error.value = value;

  void handleError(dynamic error) {
    setError(error.toString());
    setLoading(false);
  }

  void clearError() => setError('');
} 