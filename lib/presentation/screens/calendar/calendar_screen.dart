import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

/// Pantalla que muestra un calendario interactivo con eventos
/// Utiliza `table_calendar` para la visualización del calendario.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  /// Formato actual del calendario
  CalendarFormat _calendarFormat = CalendarFormat.month;

  /// Dia actualmente enfocado en el calendario.
  DateTime _focusedDay = DateTime.now();

  /// Dia actualmente seleccionado por el usuario
  DateTime? _selectedDay;

  final Map<DateTime, List<String>> _eventos = {
    DateTime.utc(2025, 10, 10): ['Reunión con equipo'],
    DateTime.utc(2025, 10, 15): ['Elecciones federales'],
    DateTime.utc(2025, 10, 20): ['Conferencias oficiales'],
  };

  /// Inicializa el estado del widget.
  /// Establece el día seleccionado como el día enfocado al inicio.
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  /// Obtiene la lista de eventos para un día específico.
  ///
  /// [dia] Día para el cual se consultan los eventos.
  /// Retorna una lista de strings con los eventos correspondientes.
  List<String> _obtenerEventos(DateTime dia) {
    final key = DateTime.utc(dia.year, dia.month, dia.day);
    return _eventos[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    // Lista de eventos del día actualmente seleccionado.
    final eventosHoy =
        _selectedDay != null ? _obtenerEventos(_selectedDay!) : [];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        centerTitle: true,
        title: const Text(
          'Calendario',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700,
            shadows: [Shadow(blurRadius: 5, color: Colors.black87)],
          ),
        ),
        backgroundColor: Colors.indigo.shade200,
        elevation: 6,
        shadowColor: Colors.indigoAccent,
      ),
      body: Column(
        children: [
          /// Calendario principal con personalización visual
          TableCalendar(
            locale: 'es',
            firstDay: DateTime.now().subtract(const Duration(days: 1000)),
            lastDay: DateTime.now().add(const Duration(days: 1000)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _obtenerEventos,
            calendarStyle: CalendarStyle(
              markerDecoration: const BoxDecoration(
                color: Colors.deepOrangeAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.indigo.shade600,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.indigoAccent.withOpacity(0.6),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              todayDecoration: BoxDecoration(
                color: Colors.amber.shade600,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.8),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              todayTextStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              selectedTextStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              defaultTextStyle: const TextStyle(color: Colors.black87),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(
                  color: Colors.red.shade700, fontWeight: FontWeight.bold),
              weekdayStyle: TextStyle(
                  color: Colors.indigo.shade700, fontWeight: FontWeight.w600),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              formatButtonShowsNext: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: Colors.blueAccent.shade700,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              formatButtonDecoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              formatButtonTextStyle: TextStyle(color: Colors.indigo.shade900),
            ),
          ),
          const SizedBox(height: 20),

          /// Muestra los eventos del día seleccionado o un mensaje si no hay eventos.
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: eventosHoy.isEmpty
                  ? Center(
                      key: const ValueKey('no_events'),
                      child: Text(
                        'No hay actividades para el día\n${DateFormat('d MMMM y', 'es').format(_selectedDay!)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : ListView.builder(
                      key: ValueKey(_selectedDay),
                      itemCount: eventosHoy.length,
                      itemBuilder: (context, index) {
                        final evento = eventosHoy[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 4,
                          shadowColor: Colors.indigo.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade600,
                              child:
                                  const Icon(Icons.event, color: Colors.white),
                            ),
                            title: Text(
                              evento,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          )
        ],
      ),
    );
  }
}
