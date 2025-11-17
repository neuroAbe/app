class Validators {
  Validators._();

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }
    if (!RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.length < min) {
      return '${fieldName ?? 'This field'} must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value != null && value.length > max) {
      return '${fieldName ?? 'This field'} must be at most $max characters';
    }
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }
    if (!(Uri.tryParse(value)?.hasAbsolutePath ?? false)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a number';
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Please enter a positive number';
    }
    return null;
  }

  static String? socialHandle(String? value, {String? platform}) {
    if (value == null || value.isEmpty) {
      return null; // Social handles are optional
    }
    // Remove @ if present
    final handle = value.startsWith('@') ? value.substring(1) : value;
    if (!RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(handle)) {
      return 'Invalid ${platform ?? 'social'} handle';
    }
    return null;
  }
}
