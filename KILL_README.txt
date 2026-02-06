═══════════════════════════════════════════════════════════════
  ⚠️  KILL AUTOCAD - TOMBOL DARURAT
═══════════════════════════════════════════════════════════════

📍 LOKASI: /Applications/Kill AutoCAD.app

⚠️  Ikon: Tanda SERU / DANGER (Merah)

═══════════════════════════════════════════════════════════════

🎯 FUNGSI:

Aplikasi ini adalah TOMBOL DARURAT untuk mematikan paksa:
  ✓ AutoCAD (semua jendela)
  ✓ License Server (lmgrd)
  ✓ Vendor Daemon (adskflex)
  ✓ Launcher scripts
  ✓ Semua proses di port 27080
  ✓ LaunchDaemon service

═══════════════════════════════════════════════════════════════

🚨 KAPAN MENGGUNAKAN:

• AutoCAD freeze (tidak merespons)
• Error lisensi [-15.xxx] atau [-96.xxx]
• License server stuck / tidak bisa start
• Perlu mulai fresh setelah error
• Masalah setelah Mac sleep/wake
• AutoCAD tidak bisa dibuka

═══════════════════════════════════════════════════════════════

⚡ CARA MENGGUNAKAN:

1. SIMPAN PEKERJAAN ANDA (jika bisa)
2. Klik dua kali: "Kill AutoCAD" (ikon danger merah)
3. Tunggu konfirmasi "SUKSES"
4. Tunggu 5 detik
5. Jalankan "AutoCAD 2026 Launcher" untuk memulai lagi

═══════════════════════════════════════════════════════════════

🔄 ALUR KERJA NORMAL:

┌─────────────────────────────────────────────────┐
│  START: "AutoCAD 2026 Launcher" (ikon AutoCAD)  │
│        ↓                                        │
│  KERJA: Gunakan AutoCAD normal                  │
│        ↓                                        │
│  ERROR: Freeze / License error                  │
│        ↓                                        │
│  DARURAT: "Kill AutoCAD" (ikon danger)          │
│        ↓                                        │
│  RESTART: "AutoCAD 2026 Launcher" lagi          │
└─────────────────────────────────────────────────┘

═══════════════════════════════════════════════════════════════

⚠️  PERINGATAN PENTING:

• INI ADALAH FORCE KILL - data yang belum disimpan akan HILANG!
• Selalu simpan pekerjaan Anda (Save/Save As) secara teratur
• Coba quit normal (Cmd+Q) terlebih dahulu
• Gunakan Kill AutoCAD hanya jika metode normal gagal
• Setelah Kill, tunggu 5 detik sebelum membuka AutoCAD lagi

═══════════════════════════════════════════════════════════════

🔧 YANG DIKERJAKAN OLEH KILL AUTOCAD:

1. pkill -9 AutoCAD (force quit)
2. pkill -9 lmgrd (license server)
3. pkill -9 adskflex (vendor daemon)
4. launchctl unload LaunchDaemon
5. kill port 27080
6. Bersihkan semua sisa proses

═══════════════════════════════════════════════════════════════
