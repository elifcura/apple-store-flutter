import 'package:flutter/material.dart';

// 1. Veri Modelimiz
class Product {
  final String name;
  final String price;
  final double priceValue; // Hesaplama yapabilmek için sayısal değer
  final String description;
  final String imagePath;

  Product({
    required this.name,
    required this.price,
    required this.priceValue,
    required this.description,
    required this.imagePath,
  });
}

// Global Sepet Listesi (Basitlik olması açısından burada tutuyoruz)
List<Product> sepetim = [];

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: KatalogSayfasi(),
  ));
}

// 2. Ana Sayfa (Katalog)
class KatalogSayfasi extends StatefulWidget {
  const KatalogSayfasi({super.key});

  @override
  State<KatalogSayfasi> createState() => _KatalogSayfasiState();
}

class _KatalogSayfasiState extends State<KatalogSayfasi> {
  final List<Product> urunler = [
    Product(
      name: "MacBook Pro M3",
      price: "54.000 TL",
      priceValue: 54000,
      description: "Apple M3 çip ile en zorlu projelerin üstesinden gelin.",
      imagePath: "assets/Macbook-pro3.webp",
    ),
    Product(
      name: "iPhone 15 Pro",
      price: "45.000 TL",
      priceValue: 45000,
      description: "Titanyum tasarım ve A17 Pro çip ile en güçlü iPhone.",
      imagePath: "assets/iphone-15-pro.webp",
    ),
    Product(
      name: "iPad Air M2",
      price: "28.000 TL",
      priceValue: 28000,
      description: "M2 çipli yeni iPad Air. İnanılmaz hız ve ekran.",
      imagePath: "assets/iPad-AirM2.jpg",
    ),
    Product(
      name: "AirPods Max",
      price: "19.500 TL",
      priceValue: 19500,
      description: "Yüksek sadakatli ses kalitesi ve gürültü engelleme.",
      imagePath: "assets/Airpods-max.jpg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text("Apple Store", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SepetSayfasi()),
                  ).then((value) => setState(() {})); // Sepetten dönünce sayıyı güncelle
                },
              ),
              if (sepetim.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${sepetim.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: urunler.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(urunler[index].imagePath, width: 60, height: 60, fit: BoxFit.contain),
              ),
              title: Text(urunler[index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(urunler[index].price, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetaySayfasi(product: urunler[index])),
                ).then((value) => setState(() {}));
              },
            ),
          );
        },
      ),
    );
  }
}

// 3. Detay Sayfası
class DetaySayfasi extends StatelessWidget {
  final Product product;
  const DetaySayfasi({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(product.imagePath, fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(product.price, style: const TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                        const Divider(height: 40),
                        const Text("Ürün Hakkında", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text(product.description, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
                sepetim.add(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${product.name} sepete eklendi!"), duration: const Duration(seconds: 1)),
                );
              },
              child: const Text("SEPETE EKLE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. Sepet Sayfası
class SepetSayfasi extends StatefulWidget {
  const SepetSayfasi({super.key});

  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}

class _SepetSayfasiState extends State<SepetSayfasi> {
  double toplamTutar() {
    return sepetim.fold(0, (sum, item) => sum + item.priceValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text("Sepetim", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: sepetim.isEmpty
          ? const Center(child: Text("Sepetiniz boş."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: sepetim.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: ListTile(
                          leading: Image.asset(sepetim[index].imagePath, width: 40),
                          title: Text(sepetim[index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(sepetim[index].price),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                sepetim.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Toplam:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${toplamTutar().toStringAsFixed(0)} TL",
                              style: const TextStyle(fontSize: 22, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () {
                          // Satın alma işlemi simülasyonu
                        },
                        child: const Text("ALIŞVERİŞİ TAMAMLA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}