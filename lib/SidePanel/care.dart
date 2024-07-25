import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarePage extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const CarePage({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Ingrijire plante',
          style: TextStyle(fontSize: 30),
          minFontSize: 15,
          maxFontSize: 40,
          maxLines: 1,
          overflow: TextOverflow.visible,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          width: screenWidth,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/drop.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Udarea Plantelor",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Frecvența și Cantitatea",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Plantele de apartament au nevoie, în general, de udare o dată pe săptămână, dar acest lucru variază în funcție de tipul plantei și de condițiile de mediu. De exemplu, un cactus poate necesita udare doar o dată la două săptămâni, în timp ce o plantă tropicală ar putea avea nevoie de udare de două ori pe săptămână în perioadele calde.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Semne ale Udării Necorespunzătoare",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Dacă planta nu primește suficientă apă, frunzele devin ofilite și uscate. În caz de udare excesivă, frunzele pot deveni galbene sau căzute.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/plant.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Răsădirea Plantelor",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Când să Răsădești",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   O plantă ar trebui răsădită atunci când rădăcinile nu mai au loc să crească. De exemplu, dacă observi rădăcini ieșind din găurile de drenaj ale ghiveciului, este un semn că planta are nevoie de un spațiu mai mare.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Cum să Răsădești",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Alege un ghiveci cu 5-10 cm mai mare în diametru decât cel actual. Mută planta în noul ghiveci, adaugă pământ proaspăt și udă ușor după răsădire.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/plant-wilt-solid.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Propagarea Plantelor",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Metode de Propagare",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Tăieturi: \n      Taie o ramură sănătoasă de aproximativ 10-15 cm și plasează-o în apă sau pământ umed pentru a încuraja rădăcinirea.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "   Divizarea: \n     Scoate planta din ghiveci și împarte rădăcinile în două sau mai multe părți, plantând fiecare parte într-un ghiveci separat.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/leaf-solid.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Curățarea Frunzelor",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Importanța Curățării",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Frunzele plantei pot acumula praf și alte particule, ceea ce poate împiedica procesul de fotosinteză. O frunză curată poate absorbi mai eficient lumina și poate respira mai bine.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Cum să Cureți Frunzele",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Alege un ghiveci cu 5-10 cm mai mare în diametru decât cel actual. Mută planta în noul ghiveci, adaugă pământ proaspăt și udă ușor după răsădire.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/fertilizer.svg',
                                width: screenHeight * 0.025,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Fertilizarea Plantelor",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Tipuri de Îngrășăminte",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Îngrășăminte organice, cum ar fi compostul, sunt excelente pentru îmbunătățirea sănătății solului. Îngrășăminte chimice, cum ar fi cele echilibrate NPK (azot, fosfor, potasiu), pot fi folosite pentru a asigura nutrienți specifici.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Frecvența Fertilizării",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Fertilizează plantele o dată pe lună în perioada de creștere activă (primăvară-vară).",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/bug-solid.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Combaterea Dăunătorilor",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Identificarea Dăunătorilor",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Verifică regular frunzele și tulpinile pentru semne ale prezenței dăunătorilor, cum ar fi pete mici, găuri în frunze sau prezența insectelor.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Tratament",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Folosește soluții naturale, cum ar fi uleiul de neem sau săpunul insecticid, pentru a combate infestarea.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/scissors-solid.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Tunderea Plantelor",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Când și Cum să Tunzi",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Tunde planta pentru a îndepărta ramurile uscate sau deteriorate și pentru a stimula creșterea. De exemplu, tunderea vârfurilor la plantele de apartament poate ajuta la creșterea mai densă.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/leaf-solid.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Tratarea Frunzelor Ofilite",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Cauze și Soluții",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Frunzele ofilite pot fi cauzate de lipsa apei, lumina insuficientă sau dăunători. Ajustează udarea, asigură lumină adecvată și tratează orice infestație.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/square-virus-solid.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Identificarea Bolilor",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Simptome și Soluții",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Bolile pot fi recunoscute prin pete pe frunze sau mucegai. Îmbunătățește circulația aerului și reduce umiditatea pentru a preveni răspândirea bolilor.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/wind-solid.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Purificarea Aerului",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Plante Benefice",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Anumite plante, cum ar fi Spathiphyllum (Lacrima Maicii Domnului) și Aloe Vera, sunt cunoscute pentru capacitatea lor de a purifica aerul prin eliminarea toxinelor.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 20, right: 20),
                child: Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/poison.svg',
                                width: screenHeight * 0.02,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              const AutoSizeText(
                                "Plante Otrăvitoare",
                                style: TextStyle(fontSize: 25),
                                minFontSize: 10,
                                maxFontSize: 40,
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          const AutoSizeText(
                            "• Precauții și Exemple",
                            style: TextStyle(fontSize: 18),
                            minFontSize: 15,
                            maxFontSize: 30,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          const AutoSizeText(
                            "   Unele plante, cum ar fi Oleander și Liliacul de Val, sunt toxice atât pentru oameni, cât și pentru animale. Păstrează aceste plante în locuri inaccesibile și informează-te despre potențialele riscuri.",
                            style: TextStyle(fontSize: 15),
                            minFontSize: 10,
                            maxFontSize: 28,
                            overflow: TextOverflow.visible,
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
