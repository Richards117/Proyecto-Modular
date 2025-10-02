import 'package:flutter/material.dart';

// Modelo simple para preguntas y respuestas
class FAQ {
  final String question;
  final String answer;

  FAQ(this.question, this.answer);
}

class QuestionsScreen extends StatelessWidget {
  QuestionsScreen({super.key});

  final List<FAQ> faqs = [
    FAQ('¿Cómo puedo votar?',
        'Debes seleccionar las opciones correspondientes y luego confirmar tu voto.'),
    FAQ('¿Puedo cambiar mi voto?',
        'No, una vez registrado tu voto no podrás cambiarlo.'),
    FAQ('¿Es seguro votar en esta app?',
        'Sí, utilizamos protocolos de seguridad para proteger tu información.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: const Text('Preguntas Frecuentes'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade100,
              Colors.blueAccent.shade100,
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (BuildContext context, int index) {
            final faq = faqs[index];
            return FAQItem(question: faq.question, answer: faq.answer);
          },
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  FAQItemState createState() => FAQItemState();
}

class FAQItemState extends State<FAQItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.question,
                style: const TextStyle(
                  color: Color.fromRGBO(26, 150, 156, 1),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              trailing: RotationTransition(
                turns: Tween(begin: 0.0, end: 0.5).animate(_expandAnimation),
                child: const Icon(Icons.expand_more, color: Colors.black87),
              ),
              onTap: _toggleExpanded,
            ),
            SizeTransition(
              sizeFactor: _expandAnimation,
              axisAlignment: 1.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  widget.answer,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
