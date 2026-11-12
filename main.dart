import 'package:flutter/material.dart';

void main() => runApp(const DaleeliNetApp());

const navy = Color(0xFF0B1F3A);
const gold = Color(0xFFD6AE55);
const pale = Color(0xFFF4F6FA);
const green = Color(0xFF16865B);

class DaleeliNetApp extends StatelessWidget {
  const DaleeliNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'دليلي نت',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pale,
        colorScheme: ColorScheme.fromSeed(seedColor: navy, primary: navy),
        fontFamily: 'Arial',
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
      ),
      home: const StoreHomePage(),
    );
  }
}

class NetworkStore {
  final String name;
  final String area;
  final String description;
  final IconData icon;
  final List<Voucher> vouchers;

  const NetworkStore({
    required this.name,
    required this.area,
    required this.description,
    required this.icon,
    required this.vouchers,
  });
}

class Voucher {
  final String title;
  final String duration;
  final String speed;
  final int price;
  const Voucher(this.title, this.duration, this.speed, this.price);
}

const stores = <NetworkStore>[
  NetworkStore(
    name: 'شبكة المهيب',
    area: 'مثال — اليمن',
    description: 'إنترنت لاسلكي',
    icon: Icons.wifi,
    vouchers: [
      Voucher('كرت اقتصادي', 'يوم واحد', 'سرعة أساسية', 200),
      Voucher('كرت متوسط', '3 أيام', 'سرعة متوسطة', 500),
      Voucher('كرت مميز', '7 أيام', 'سرعة عالية', 1000),
    ],
  ),
  NetworkStore(
    name: 'شبكة الأفق',
    area: 'مثال — اليمن',
    description: 'تغطية لاسلكية',
    icon: Icons.router,
    vouchers: [
      Voucher('كرت يومي', 'يوم واحد', 'سرعة أساسية', 250),
      Voucher('كرت أسبوعي', '7 أيام', 'سرعة متوسطة', 1200),
    ],
  ),
  NetworkStore(
    name: 'شبكة النور',
    area: 'مثال — اليمن',
    description: 'باقات إنترنت منزلية',
    icon: Icons.language,
    vouchers: [
      Voucher('باقة صغيرة', 'يوم واحد', 'سرعة أساسية', 300),
      Voucher('باقة شهرية', '30 يوماً', 'حسب الباقة', 5000),
    ],
  ),
];

class StoreHomePage extends StatefulWidget {
  const StoreHomePage({super.key});

  @override
  State<StoreHomePage> createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  int tab = 0;
  String search = '';
  final List<String> purchases = [];

  List<NetworkStore> get filtered => stores
      .where((s) => s.name.contains(search) || s.area.contains(search))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('دليلي نت', style: TextStyle(fontWeight: FontWeight.w800)),
              Text('متجرك الذكي لكروت الإنترنت',
                  style: TextStyle(fontSize: 11, color: Color(0xFFDCE5F0))),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'الإشعارات',
              onPressed: () => _message('لا توجد إشعارات جديدة حالياً'),
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: IndexedStack(
          index: tab,
          children: [
            _home(),
            _networks(),
            _myCards(),
            _account(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: tab,
          onDestinationSelected: (v) => setState(() => tab = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.wifi_find), label: 'الشبكات'),
            NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), label: 'كروتي'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
      ),
    );
  }

  Widget _home() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [navy, Color(0xFF173B63)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('كل شبكات الإنترنت… في مكان واحد',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('اختر شبكتك واشترِ كرتك بسهولة',
                  style: TextStyle(color: Color(0xFFDCE5F0))),
              SizedBox(height: 18),
              Row(
                children: [
                  Icon(Icons.bolt, color: gold),
                  SizedBox(width: 6),
                  Text('شراء سريع • خيارات متعددة',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          onChanged: (v) => setState(() => search = v.trim()),
          decoration: InputDecoration(
            hintText: 'ابحث عن شبكة أو منطقة',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 20),
        _sectionTitle('الشبكات المتاحة', onTap: () => setState(() => tab = 1)),
        const SizedBox(height: 10),
        ...filtered.map(_networkCard),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: const Row(
            children: [
              Icon(Icons.verified_user_outlined, color: green),
              SizedBox(width: 10),
              Expanded(child: Text('ملاحظة: هذه نسخة تجريبية ببيانات توضيحية، وليست متصلة بالدفع أو الشبكات الفعلية.',
                  style: TextStyle(fontSize: 12, color: Colors.black54))),
            ],
          ),
        )
      ],
    );
  }

  Widget _networks() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text('تصفح الشبكات', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: navy)),
      const SizedBox(height: 12),
      TextField(
        onChanged: (v) => setState(() => search = v.trim()),
        decoration: InputDecoration(
          hintText: 'اكتب اسم الشبكة',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        ),
      ),
      const SizedBox(height: 12),
      ...filtered.map(_networkCard),
    ],
  );

  Widget _networkCard(NetworkStore store) => Card(
    elevation: 0,
    color: Colors.white,
    margin: const EdgeInsets.only(bottom: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEAF0F7),
        child: Icon(store.icon, color: navy),
      ),
      title: Text(store.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('${store.area} • ${store.description}'),
      trailing: const Icon(Icons.chevron_left),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NetworkDetailPage(
          store: store,
          onBuy: (voucher) => _buy(store, voucher),
        )),
      ),
    ),
  );

  Widget _sectionTitle(String title, {VoidCallback? onTap}) => Row(
    children: [
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: navy)),
      const Spacer(),
      TextButton(onPressed: onTap, child: const Text('عرض الكل')),
    ],
  );

  Widget _myCards() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const Text('كروتي ومشترياتي', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: navy)),
      const SizedBox(height: 12),
      if (purchases.isEmpty)
        const _EmptyState(icon: Icons.confirmation_number_outlined, title: 'لا توجد كروت بعد', subtitle: 'ستظهر مشترياتك هنا بعد إتمام عملية الشراء.')
      else
        ...purchases.map((p) => Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.confirmation_number, color: green),
            title: Text(p),
            subtitle: const Text('طلب تجريبي — لم يصدر كود حقيقي'),
          ),
        )),
    ],
  );

  Widget _account() => ListView(
    padding: const EdgeInsets.all(16),
    children: const [
      Text('حسابي', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: navy)),
      SizedBox(height: 14),
      _AccountTile(icon: Icons.login, title: 'تسجيل الدخول', subtitle: 'سيتم تفعيل الحسابات في مرحلة الخادم'),
      _AccountTile(icon: Icons.account_balance_wallet_outlined, title: 'المحفظة', subtitle: 'الرصيد وعمليات الدفع'),
      _AccountTile(icon: Icons.support_agent, title: 'الدعم والمساعدة', subtitle: 'مركز مساعدة العملاء'),
      _AccountTile(icon: Icons.storefront_outlined, title: 'انضم كبائع', subtitle: 'تسجيل الشبكات وأصحابها'),
    ],
  );

  void _buy(NetworkStore store, Voucher voucher) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد طلب تجريبي'),
        content: Text('الشبكة: ${store.name}\nالباقة: ${voucher.title}\nالسعر: ${voucher.price} ريال\n\nلن يتم خصم أي مبلغ أو إصدار كرت حقيقي في هذه النسخة.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: navy),
            onPressed: () {
              setState(() => purchases.insert(0, '${store.name} — ${voucher.title}'));
              Navigator.pop(ctx);
              Navigator.pop(context);
              _message('تم تسجيل طلب تجريبي بنجاح');
            },
            child: const Text('تسجيل طلب تجريبي'),
          ),
        ],
      ),
    );
  }

  void _message(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }
}

class NetworkDetailPage extends StatelessWidget {
  final NetworkStore store;
  final ValueChanged<Voucher> onBuy;
  const NetworkDetailPage({super.key, required this.store, required this.onBuy});

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: Text(store.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(18)),
            child: Row(
              children: [
                const Icon(Icons.wifi, color: gold, size: 38),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.name, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                    Text('${store.area} • ${store.description}', style: const TextStyle(color: Colors.white70)),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('اختر الكرت المناسب', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: navy)),
          const SizedBox(height: 10),
          ...store.vouchers.map((v) => Card(
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text('${v.duration} • ${v.speed}', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('${v.price} ريال', style: const TextStyle(color: green, fontWeight: FontWeight.bold, fontSize: 17)),
                      const Spacer(),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: navy),
                        onPressed: () => onBuy(v),
                        child: const Text('شراء'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _EmptyState({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
    child: Column(children: [
      Icon(icon, size: 42, color: Colors.black38),
      const SizedBox(height: 10),
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
    ]),
  );
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _AccountTile({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    elevation: 0,
    child: ListTile(
      leading: Icon(icon, color: navy),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_left),
    ),
  );
}
