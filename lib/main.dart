import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AthkariApp());
}

class Dhikr {
  final String id, title, category, text;
  final int repeat;
  const Dhikr({required this.id, required this.title, required this.category, required this.text, this.repeat = 1});
}

const adhkar = <Dhikr>[
  Dhikr(id:'morning1', title:'آية الكرسي', category:'أذكار الصباح', text:'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ.', repeat:1),
  Dhikr(id:'morning2', title:'سيد الاستغفار', category:'أذكار الصباح', text:'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي وأبوء بذنبي فاغفر لي، فإنه لا يغفر الذنوب إلا أنت.', repeat:1),
  Dhikr(id:'morning3', title:'التسبيح', category:'أذكار الصباح', text:'سبحان الله وبحمده.', repeat:100),
  Dhikr(id:'morning4', title:'التهليل', category:'أذكار الصباح', text:'لا إله إلا الله وحده لا شريك له، له الملك وله الحمد وهو على كل شيء قدير.', repeat:10),
  Dhikr(id:'evening1', title:'المعوذات', category:'أذكار المساء', text:'قل هو الله أحد، قل أعوذ برب الفلق، قل أعوذ برب الناس.', repeat:3),
  Dhikr(id:'evening2', title:'ذكر المساء', category:'أذكار المساء', text:'رضيت بالله ربًا، وبالإسلام دينًا، وبمحمد صلى الله عليه وسلم نبيًا.', repeat:3),
  Dhikr(id:'sleep1', title:'ذكر النوم', category:'أذكار النوم', text:'باسمك اللهم أموت وأحيا.', repeat:1),
  Dhikr(id:'sleep2', title:'التسبيح قبل النوم', category:'أذكار النوم', text:'سبحان الله.', repeat:33),
  Dhikr(id:'wake1', title:'ذكر الاستيقاظ', category:'أذكار الاستيقاظ', text:'الحمد لله الذي أحيانا بعدما أماتنا وإليه النشور.', repeat:1),
  Dhikr(id:'prayer1', title:'الاستغفار بعد الصلاة', category:'بعد الصلاة', text:'أستغفر الله.', repeat:3),
  Dhikr(id:'prayer2', title:'دعاء بعد الصلاة', category:'بعد الصلاة', text:'اللهم أعني على ذكرك وشكرك وحسن عبادتك.', repeat:1),
  Dhikr(id:'travel1', title:'دعاء السفر', category:'السفر', text:'سبحان الذي سخر لنا هذا وما كنا له مقرنين وإنا إلى ربنا لمنقلبون.', repeat:1),
  Dhikr(id:'food1', title:'قبل الطعام', category:'الطعام', text:'بسم الله.', repeat:1),
  Dhikr(id:'food2', title:'بعد الطعام', category:'الطعام', text:'الحمد لله الذي أطعمني هذا ورزقنيه من غير حول مني ولا قوة.', repeat:1),
  Dhikr(id:'home1', title:'دخول المنزل', category:'المنزل', text:'بسم الله ولجنا، وبسم الله خرجنا، وعلى ربنا توكلنا.', repeat:1),
  Dhikr(id:'mosque1', title:'دخول المسجد', category:'المسجد', text:'اللهم افتح لي أبواب رحمتك.', repeat:1),
  Dhikr(id:'mosque2', title:'الخروج من المسجد', category:'المسجد', text:'اللهم إني أسألك من فضلك.', repeat:1),
  Dhikr(id:'general1', title:'الصلاة على النبي', category:'أذكار عامة', text:'اللهم صل وسلم وبارك على نبينا محمد.', repeat:10),
  Dhikr(id:'general2', title:'الاستغفار', category:'أذكار عامة', text:'أستغفر الله وأتوب إليه.', repeat:100),
];

class AthkariApp extends StatefulWidget {
  const AthkariApp({super.key});
  @override State<AthkariApp> createState() => _AthkariAppState();
}

class _AthkariAppState extends State<AthkariApp> {
  bool dark = false;
  int tab = 0;
  @override void initState() { super.initState(); _loadTheme(); }
  Future<void> _loadTheme() async { final p = await SharedPreferences.getInstance(); if (mounted) setState(() => dark = p.getBool('dark') ?? false); }
  Future<void> _toggleTheme() async { final p = await SharedPreferences.getInstance(); await p.setBool('dark', !dark); if (mounted) setState(() => dark = !dark); }
  @override Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'أذكاري',
    themeMode: dark ? ThemeMode.dark : ThemeMode.light,
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF0F766E), brightness: Brightness.light),
    darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF2DD4BF), brightness: Brightness.dark),
    home: Directionality(textDirection: TextDirection.rtl, child: MainShell(tab: tab, onTab: (v) => setState(() => tab = v), dark: dark, onTheme: _toggleTheme)),
  );
}

class MainShell extends StatelessWidget {
  final int tab; final ValueChanged<int> onTab; final bool dark; final VoidCallback onTheme;
  const MainShell({super.key, required this.tab, required this.onTab, required this.dark, required this.onTheme});
  @override Widget build(BuildContext context) {
    final pages = [const HomePage(), const CategoriesPage(), const TasbeehPage(), const FavoritesPage(), SettingsPage(dark: dark, onTheme: onTheme)];
    return Scaffold(body: pages[tab], bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: onTab, destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
      NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'الأذكار'),
      NavigationDestination(icon: Icon(Icons.fingerprint), selectedIcon: Icon(Icons.fingerprint), label: 'التسبيح'),
      NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'المفضلة'),
      NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'الإعدادات'),
    ]));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context) {
    final cats = ['أذكار الصباح','أذكار المساء','أذكار النوم','بعد الصلاة','أذكار عامة'];
    return SafeArea(child: CustomScrollView(slivers: [
      SliverAppBar.large(title: const Text('أذكاري'), actions: [IconButton(icon: const Icon(Icons.search), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()))) ]),
      SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('وَاذْكُر رَّبَّكَ إِذَا نَسِيتَ', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('ابدأ يومك بالذكر والطمأنينة', style: TextStyle(fontSize: 16))])),
        const SizedBox(height: 18), const Text('الوصول السريع', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 10),
        GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: cats.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.55), itemBuilder: (_, i) => Card(child: InkWell(borderRadius: BorderRadius.circular(16), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryPage(category: cats[i]))), child: Center(child: Text(cats[i], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600))))),
        const SizedBox(height: 12),
        Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.explore)), title: const Text('القبلة'), subtitle: const Text('احسب اتجاه القبلة من موقعك'), trailing: const Icon(Icons.chevron_left), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaPage())))),
        Card(child: ListTile(leading: const CircleAvatar(child: Icon(Icons.access_time)), title: const Text('مواقيت الصلاة'), subtitle: const Text('صفحة جاهزة لإضافة مواقيت منطقتك'), trailing: const Icon(Icons.chevron_left), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerTimesPage())))),
      ])))
    ]));
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});
  @override Widget build(BuildContext context) { final categories = adhkar.map((e) => e.category).toSet().toList(); return SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [const Text('الأذكار', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), const SizedBox(height: 14), ...categories.map((c) => Card(child: ListTile(leading: const Icon(Icons.auto_awesome), title: Text(c), trailing: const Icon(Icons.chevron_left), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryPage(category: c))))))])); }
}

class CategoryPage extends StatelessWidget {
  final String category; const CategoryPage({super.key, required this.category});
  @override Widget build(BuildContext context) { final items = adhkar.where((e) => e.category == category).toList(); return Scaffold(appBar: AppBar(title: Text(category)), body: ListView.builder(padding: const EdgeInsets.all(12), itemCount: items.length, itemBuilder: (_, i) => DhikrCard(dhikr: items[i]))); }
}

class DhikrCard extends StatefulWidget { final Dhikr dhikr; const DhikrCard({super.key, required this.dhikr}); @override State<DhikrCard> createState() => _DhikrCardState(); }
class _DhikrCardState extends State<DhikrCard> {
  int count = 0; bool favorite = false;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final p = await SharedPreferences.getInstance(); if (mounted) setState(() => favorite = p.getStringList('favorites')?.contains(widget.dhikr.id) ?? false); }
  Future<void> _fav() async { final p = await SharedPreferences.getInstance(); final list = p.getStringList('favorites') ?? []; if (list.contains(widget.dhikr.id)) { list.remove(widget.dhikr.id); } else { list.add(widget.dhikr.id); } await p.setStringList('favorites', list); if (mounted) setState(() => favorite = !favorite); }
  @override Widget build(BuildContext context) { final done = count >= widget.dhikr.repeat; return Card(margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(widget.dhikr.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19))), IconButton(onPressed: _fav, icon: Icon(favorite ? Icons.favorite : Icons.favorite_border))]), const SizedBox(height: 12), Text(widget.dhikr.text, style: const TextStyle(fontSize: 20, height: 1.8)), const SizedBox(height: 16), Row(children: [Text('$count/${widget.dhikr.repeat}', style: const TextStyle(fontWeight: FontWeight.bold)), const Spacer(), FilledButton.icon(onPressed: done ? () => setState(() => count = 0) : () => setState(() => count++), icon: Icon(done ? Icons.restart_alt : Icons.touch_app), label: Text(done ? 'إعادة' : 'ذكر'))])]))); }
}

class TasbeehPage extends StatefulWidget { const TasbeehPage({super.key}); @override State<TasbeehPage> createState() => _TasbeehPageState(); }
class _TasbeehPageState extends State<TasbeehPage> {
  int count = 0, target = 33;
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final p = await SharedPreferences.getInstance(); if (mounted) setState(() { count = p.getInt('tasbeeh') ?? 0; target = p.getInt('target') ?? 33; }); }
  Future<void> _save() async { final p = await SharedPreferences.getInstance(); await p.setInt('tasbeeh', count); await p.setInt('target', target); }
  @override Widget build(BuildContext context) { final progress = target == 0 ? 0.0 : min(count / target, 1.0); return SafeArea(child: Column(children: [const Padding(padding: EdgeInsets.all(20), child: Text('عداد التسبيح', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))), const Spacer(), Stack(alignment: Alignment.center, children: [SizedBox(width: 220, height: 220, child: CircularProgressIndicator(value: progress, strokeWidth: 12)), Column(children: [Text('$count', style: const TextStyle(fontSize: 56, fontWeight: FontWeight.bold)), Text('من $target')])]), const SizedBox(height: 30), FilledButton(style: FilledButton.styleFrom(shape: const CircleBorder(), padding: const EdgeInsets.all(45)), onPressed: () { setState(() => count = count >= target ? 0 : count + 1); _save(); }, child: const Icon(Icons.fingerprint, size: 42)), const SizedBox(height: 20), Row(mainAxisAlignment: MainAxisAlignment.center, children: [OutlinedButton(onPressed: () { setState(() => count = 0); _save(); }, child: const Text('تصفير')), const SizedBox(width: 10), DropdownButton<int>(value: target, items: [10,33,100].map((n) => DropdownMenuItem(value:n, child:Text('$n مرة'))).toList(), onChanged: (v) { if(v != null) { setState(() { target=v; count=0; }); _save(); } })]), const Spacer()])); }
}

class FavoritesPage extends StatefulWidget { const FavoritesPage({super.key}); @override State<FavoritesPage> createState() => _FavoritesPageState(); }
class _FavoritesPageState extends State<FavoritesPage> {
  List<Dhikr> items = [];
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async { final p = await SharedPreferences.getInstance(); final ids = p.getStringList('favorites') ?? []; if (mounted) setState(() => items = adhkar.where((e) => ids.contains(e.id)).toList()); }
  @override Widget build(BuildContext context) => SafeArea(child: Column(children: [const Padding(padding: EdgeInsets.all(20), child: Align(alignment: Alignment.centerRight, child: Text('المفضلة', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)))), Expanded(child: items.isEmpty ? const Center(child: Text('لم تضف أذكارًا للمفضلة بعد.')) : ListView.builder(padding: const EdgeInsets.all(12), itemCount: items.length, itemBuilder: (_,i)=>DhikrCard(dhikr:items[i])))]));
}

class SearchPage extends StatefulWidget { const SearchPage({super.key}); @override State<SearchPage> createState() => _SearchPageState(); }
class _SearchPageState extends State<SearchPage> { String q = ''; @override Widget build(BuildContext context) { final result = adhkar.where((e) => '${e.title} ${e.category} ${e.text}'.contains(q)).toList(); return Scaffold(appBar: AppBar(title: TextField(autofocus: true, decoration: const InputDecoration(hintText:'ابحث في الأذكار', border: InputBorder.none), onChanged: (v) => setState(() => q=v))), body: ListView.builder(padding: const EdgeInsets.all(12), itemCount: result.length, itemBuilder: (_,i)=>DhikrCard(dhikr:result[i]))); } }

class SettingsPage extends StatelessWidget { final bool dark; final VoidCallback onTheme; const SettingsPage({super.key, required this.dark, required this.onTheme}); @override Widget build(BuildContext context) => SafeArea(child: ListView(padding: const EdgeInsets.all(16), children: [const Text('الإعدادات', style: TextStyle(fontSize:30,fontWeight:FontWeight.bold)), const SizedBox(height:12), SwitchListTile(title: const Text('الوضع الليلي'), value: dark, onChanged: (_) => onTheme()), const ListTile(leading:Icon(Icons.notifications_outlined), title:Text('التنبيهات'), subtitle:Text('يمكن إضافة جدولة التنبيهات لاحقًا')), const ListTile(leading:Icon(Icons.info_outline), title:Text('عن التطبيق'), subtitle:Text('أذكاري — تطبيق أذكار إسلامية شامل'))])); }

class PrayerTimesPage extends StatelessWidget { const PrayerTimesPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('مواقيت الصلاة')), body: ListView(padding: const EdgeInsets.all(16), children: const [Card(child:ListTile(leading:Icon(Icons.nightlight_round), title:Text('الفجر'), trailing:Text('--:--'))), Card(child:ListTile(leading:Icon(Icons.wb_sunny_outlined), title:Text('الظهر'), trailing:Text('--:--'))), Card(child:ListTile(leading:Icon(Icons.sunny), title:Text('العصر'), trailing:Text('--:--'))), Card(child:ListTile(leading:Icon(Icons.wb_twilight), title:Text('المغرب'), trailing:Text('--:--'))), Card(child:ListTile(leading:Icon(Icons.nights_stay), title:Text('العشاء'), trailing:Text('--:--'))), SizedBox(height:12), Text('مواقيت الصلاة تحتاج ربطًا بخدمة حساب موثوقة حسب الموقع وطريقة الحساب المختارة.') ])); }

class QiblaPage extends StatefulWidget { const QiblaPage({super.key}); @override State<QiblaPage> createState() => _QiblaPageState(); }
class _QiblaPageState extends State<QiblaPage> {
  String status = 'لم يتم تحديد الموقع بعد'; double? bearing;
  Future<void> locate() async { setState(() => status = 'جاري تحديد الموقع...'); try { if (!await Geolocator.isLocationServiceEnabled()) { setState(() => status='فعّل خدمة الموقع ثم حاول مرة أخرى.'); return; } var perm = await Geolocator.checkPermission(); if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission(); if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) { setState(() => status='لم يتم منح إذن الموقع.'); return; } final pos = await Geolocator.getCurrentPosition(); bearing = _qiblaBearing(pos.latitude, pos.longitude); setState(() => status='تم تحديد الموقع بنجاح'); } catch (_) { setState(() => status='تعذر تحديد الموقع.'); } }
  double _qiblaBearing(double lat, double lon) { const kaabaLat=21.422487, kaabaLon=39.826206; final p1=lat*pi/180, p2=kaabaLat*pi/180, dl=(kaabaLon-lon)*pi/180; return (atan2(sin(dl), cos(p1)*tan(p2)-sin(p1)*cos(dl))*180/pi+360)%360; }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('القبلة')), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[const Icon(Icons.explore, size:120), const SizedBox(height:20), Text(bearing == null ? 'اضغط لتحديد اتجاه القبلة' : 'اتجاه القبلة ${bearing!.toStringAsFixed(1)}°', style:const TextStyle(fontSize:24,fontWeight:FontWeight.bold), textAlign:TextAlign.center), const SizedBox(height:12), Text(status, textAlign:TextAlign.center), const SizedBox(height:24), FilledButton.icon(onPressed:locate, icon:const Icon(Icons.my_location), label:const Text('تحديد موقعي'))]))));
}
