# 📱 AUDIX Store Tech - Android Mobile Application

Official Mobile Application for **[audixstoretech.online](https://audixstoretech.online/)**.

---

## ✨ Features (App Me Kya Kya Shamil Hai)

1. **Exact Same Mobile Responsive Design & Features**:
   - Aapki website ka tamam mobile layout, colors, dark luxury theme, product catalog, checkout, buttons sab 100% waise hi khulega.
   - **Auto-Sync**: Jab bhi aap website par naye products ya prices change karenge, woh bina kisi app update ke foran app me reflect honge.
2. **Branded Luxury Splash Screen**:
   - Metallic Monogram Logo aur glowing cyan audio waves ke sath smooth startup animation.
3. **Hardware Back Button Handling**:
   - Mobile ka back button dabane par website ke pichle page par jayega (app achanak band nahi hogi).
4. **Pull to Refresh**:
   - Screen ko neeche kheench kar page refresh karne ka feature.
5. **Smart URL Interceptor**:
   - WhatsApp links (`wa.me`), phone calls (`tel:`), Instagram, TikTok direct external apps me khulenge bina crash huye.
6. **Offline Detection & Retry Screen**:
   - Agar user ka internet disconnected ho toh modern "No Internet - Retry" screen show hogi.
7. **Custom Content Filter (Karan Aujla Video Filter)**:
   - App ke andar sirf **Karan Aujla** wali video banner (`#mobAudixChampionBanner` / `x9RC77Oc-0Q`) auto-remove ho jayegi, jabke baqi tamaam product videos, images, aur features 100% active rahenge.

---

## 💰 Play Store Par Live Karne Ke Kharchay (Paisa Lagega Ya Nahi?)

- **Application Banana (Code & Setup):** Bilkul **100% FREE** (Humne mukammal ready kar diya hai).
- **Google Play Store Policy:**
  - Google har developer se ek dafa **$25 (taqreeban 7,000 PKR)** one-time lifetime fee leta hai apna Play Console Account banane ke liye.
  - Yeh fee Google ki official policy hai (har developer ke liye).
- **Free Alternatives (Bina $25 diye app chalane ke tareeqe):**
  1. **Direct Website Download (100% Free):** Aap apni website par *"Download Android App"* ka button laga kar users ko direct `.apk` file provide kar sakte hain. Customers bina Play Store ke bhi 1 click me install kar sakte hain.
  2. **Kisi Dost Ka Play Console Account:** Agar aapke kisi dost ya developer ke paas pehle se account ho toh aap unke account se free me upload karwa sakte hain.

---

## 🚀 APK aur Play Store Bundle (.AAB) Hasil Karne Ke 2 Aasan Tareeqe:

### Tareeqa 1: GitHub Actions (Sab Se Aasan - Cloud Me Build)
Aapke computer par kisi heavy software ya Flutter ki zaroorat nahi:
1. Is project folder ko apne free **GitHub** account par upload / push karein.
2. `.github/workflows/build-apk.yml` file khud-b-khud GitHub cloud servers par app build karegi.
3. GitHub repository ke **Actions** tab me jayein, wahan se direct **`AUDIX-Release-APK`** aur **`AUDIX-PlayStore-AAB`** download karein!

### Tareeqa 2: Local Computer Par Build Karna
1. Agar aapke paas Flutter installed ho:
```bash
flutter pub get
flutter build apk --release
flutter build appbundle --release
```
2. Files yahan milengi:
   - APK: `build/app/outputs/flutter-apk/app-release.apk`
   - AAB: `build/app/outputs/bundle/release/app-release.aab`
