class Env {
  // Ubah port dan host di sini agar cepat.
  // 10.0.2.2 adalah localhost untuk Android Emulator.
  // Jika menggunakan device asli atau iOS simulator, gunakan IP lokal komputer (contoh: 192.168.1.x) atau localhost.
  static const String apiHost = '10.0.2.2';
  static const String apiPort = '8080';
  
  static const String apiBaseUrl = 'http://$apiHost:$apiPort/api/v1';
}
