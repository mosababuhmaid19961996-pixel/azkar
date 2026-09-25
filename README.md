# أذكاري | Athkari

مشروع Flutter عربي لأذكار المسلم، مُعاد بناؤه مع Android embedding v2 وGitHub Actions لبناء APK.

## المزايا
- الأذكار والتصنيفات.
- البحث.
- المفضلة مع الحفظ المحلي.
- عداد التسبيح مع هدف.
- الوضع الليلي.
- اتجاه القبلة باستخدام الموقع.
- صفحة أوقات الصلاة كواجهة جاهزة للإكمال.

## البناء على GitHub
Workflow موجود في `.github/workflows/main.yml` ويقوم بـ:
1. تثبيت Flutter stable.
2. تثبيت الاعتمادات.
3. إعادة إنشاء Android host حديث بواسطة `flutter create --platforms=android .` لتجنب Android v1 embedding.
4. إضافة صلاحيات الموقع.
5. حذف ملف Flutter التجريبي `test/widget_test.dart` حتى لا يظهر خطأ `MyApp isn't a class`.
6. بناء APK release.
7. رفع APK كـ Artifact باسم `athkari-release-apk`.

## البناء محلياً
```bash
flutter pub get
flutter run
flutter build apk --release
```

ملف APK بعد البناء:
`build/app/outputs/flutter-apk/app-release.apk`

> لم يتم تضمين `test/widget_test.dart` في هذه النسخة.
