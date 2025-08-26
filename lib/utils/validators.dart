class Validators {
  static String? requiredField(String? v, {String label = 'Campo'}) {
    if (v == null || v.trim().isEmpty) return '$label é obrigatório';
    return null;
  }

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email é obrigatório';
    final ok = RegExp(r'^.+@.+\..+$').hasMatch(v.trim());
    return ok ? null : 'Email inválido';
  }

  static String? password(String? v) {
    if (v == null || v.length < 6) return 'Mínimo de 6 caracteres';
    return null;
  }

  static String? cnpj(String? v) {
    if (v == null || v.isEmpty) return null; // opcional
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 14) return 'CNPJ inválido';
    return null;
  }
}
