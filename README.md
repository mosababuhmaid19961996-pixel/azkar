# أذكاري | Athkari

نسخة Flutter عربية مبسطة من تطبيق أذكاري، مع Android حديث وGitHub Actions لبناء APK.

## ما تم إصلاحه
- إصلاح أخطاء Dart في الصفحة الرئيسية.
- إزالة اختبار Flutter التجريبي الذي كان يبحث عن `MyApp` غير موجود.
- Android embedding v2.
- صلاحيات الموقع للقبلة.
- Workflow يعيد إنشاء Android نظيف ثم يحلل المشروع ويبني APK.

## البناء عبر GitHub Actions
بعد رفع المشروع إلى الفرع `main`:
1. افتح **Actions**.
2. اختر **Build Android APK**.
3. انتظر حتى تظهر علامة صح خضراء.
4. افتح التشغيل الناجح ثم قسم **Artifacts** وحمّل `athkari-release-apk`.

## البناء المحلي
```bash
flutter pub get
flutter run
flutter build apk --release
```

ملف APK سيكون في:
`build/app/outputs/flutter-apk/app-release.apk`

> لم يتم وضع مواقيت صلاة فعلية افتراضية؛ الصفحة تعرض حقولًا مؤقتة إلى أن يتم ربطها بخدمة موثوقة.


ملاحظة: GitHub Actions يحذف اختبار Flutter الافتراضي الذي ينشئه flutter create لأنه يستخدم MyApp التجريبي.
