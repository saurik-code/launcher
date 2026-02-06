# AutoCAD 2026 Mac Launcher

🎨 **AutoCAD 2026 Launcher with License Server Management for macOS**

Aplikasi launcher untuk AutoCAD 2026 di Mac dengan manajemen license server otomatis.

## 📁 Isi Repository

| File/Folder | Deskripsi |
|-------------|-----------|
| `AutoCAD 2026 Launcher.app` | 🚀 Aplikasi launcher utama |
| `Kill AutoCAD.app` | 💀 Aplikasi emergency kill |
| `launch_autocad_server.sh` | 🔧 Script launcher (shell) |
| `kill_autocad.sh` | 🔧 Script kill (shell) |
| `README.txt` | 📘 Manual lengkap (Bahasa Indonesia) |
| `SETUP_README.txt` | 📘 Setup & konfigurasi |
| `KILL_README.txt` | 📘 Petunjuk Kill AutoCAD |

## 🚀 Fitur

### AutoCAD 2026 Launcher
- ✅ Auto-start license server jika belum berjalan
- ✅ Cek duplikat proses & cleanup otomatis
- ✅ Smart health check (proses + port + TCP)
- ✅ Retry mechanism (3x percobaan)
- ✅ Environment variables otomatis

### Kill AutoCAD
- 💀 Force kill AutoCAD dan License Server
- 🔄 Kill berulang 3x untuk memastikan
- 📊 Tampilkan detail proses yang berjalan
- ✅ Verifikasi hasil setelah kill

## 📦 Instalasi

### 1. Copy Aplikasi ke Applications
```bash
# Copy ke folder Applications
cp -R "AutoCAD 2026 Launcher.app" /Applications/
cp -R "Kill AutoCAD.app" /Applications/
```

### 2. Setup License Server
```bash
# Pastikan folder flexnetserver ada
sudo mkdir -p /usr/local/flexnetserver

# Copy license file (jika belum ada)
sudo cp license_backup_working.dat /usr/local/flexnetserver/license.dat

# Set permission
sudo chmod 755 /usr/local/flexnetserver
sudo chmod 644 /usr/local/flexnetserver/license.dat
```

### 3. Setup Password
```bash
# Edit config file
nano "/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf"
# Ganti: PASSWORD=nafaru

# Edit config Kill AutoCAD  
nano "/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf"
# Ganti: PASSWORD=nafaru
```

## 🖥️ Cara Penggunaan

### Buka AutoCAD
1. Double-click **AutoCAD 2026 Launcher** di Applications
2. Tunggu notifikasi "License server berjalan"
3. AutoCAD akan terbuka otomatis

### Tutup AutoCAD (Emergency)
1. Double-click **Kill AutoCAD** di Applications
2. Lihat detail proses yang berjalan
3. Klik **Lanjutkan**
4. Masukkan password Mac (pertama kali)
5. Tunggu konfirmasi sukses
6. Buka lagi dengan Launcher

## 🔄 Alur Kerja

### Normal Flow
```
User → Launch AutoCAD 2026 Launcher.app
     → Check license server health
     → If not running: start server
     → Set environment variables
     → Launch AutoCAD 2026
     → Done ✅
```

### Emergency Flow
```
AutoCAD Freeze/Error
     → Launch Kill AutoCAD.app
     → Show running processes
     → User clicks "Lanjutkan"
     → Kill all processes (with sudo)
     → Verify all killed
     → Show success message
     → User relaunch with Launcher
     → Done ✅
```

## 🔧 Troubleshooting

### License Server Tidak Bisa Start
```bash
# Kill manual
sudo pkill -9 -x lmgrd
sudo pkill -9 -x adskflex

# Start manual
cd /usr/local/flexnetserver
sudo ./lmgrd -c ./license.dat
```

### Port 27080 Sudah Digunakan
```bash
# Cek apa yang pakai port
sudo lsof -i :27080

# Kill proses yang pakai port
sudo kill -9 <PID>
```

### Reset Semua
```bash
# Kill semua
sudo pkill -9 -f autocad
sudo pkill -9 -x lmgrd
sudo pkill -9 -x adskflex

# Clear port
for pid in $(sudo lsof -t -i :27080); do sudo kill -9 $pid; done

# Restart
/Applications/AutoCAD\ 2026\ Launcher.app/Contents/Resources/launch_autocad_server.sh
```

## 📋 Requirements

- macOS (tested on macOS Sonoma+)
- AutoCAD 2026 for Mac
- FlexNet License Server (`/usr/local/flexnetserver/`)
- Administrator privileges (untuk sudo)

## 🔒 Security

- Password disimpan di file `password.conf` dengan permission 600
- Hanya user yang bisa membaca password
- Script menggunakan sudo dengan validasi

## 📝 File Konfigurasi

### Launcher Config
```
/Applications/AutoCAD 2026 Launcher.app/Contents/Resources/password.conf
```

### Kill App Config
```
/Applications/Kill AutoCAD.app/Contents/Resources/kill_password.conf
```

### License File
```
/usr/local/flexnetserver/license.dat
```

## 🛠️ Technical Details

### Port yang Digunakan
- **27080**: License Server (lmgrd)

### Proses yang Dijalankan
- `lmgrd`: License Manager Daemon
- `adskflex`: Autodesk Vendor Daemon
- `AutoCAD 2026.app/Contents/MacOS/AutoCAD`: AutoCAD utama

### Environment Variables
```bash
LM_LICENSE_FILE=27080@127.0.0.1
ADSKFLEX_LICENSE_FILE=27080@127.0.0.1
```

## 📄 License

This project is for personal/educational use only.

AutoCAD is a trademark of Autodesk, Inc.
FlexNet is a trademark of Flexera Software.

## 🤝 Contributing

Feel free to fork and modify for your own use.

## 🐛 Issues

Jika ada masalah:
1. Jalankan diagnostic: `diagnose.sh`
2. Cek log: `tail -f /tmp/autocad_launcher.log`
3. Baca manual: `README.txt`

---

**Dibuat:** 6 Februari 2026  
**Bahasa:** Indonesia  
**Platform:** macOS
