import 'package:flutter/material.dart';

class TripHistory extends StatefulWidget {
  final String title;
  final List<String> tabs;
  final int activeTab;
  final List<Map<String, String>> trips;

  const TripHistory({
    super.key,
    required this.title,
    required this.tabs,
    required this.activeTab,
    required this.trips,
  });

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {
  late int _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.activeTab;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(widget.tabs.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _activeTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: _activeTab == index ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2)),
                ),
                child: Text(
                  widget.tabs[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: _activeTab == index ? FontWeight.bold : FontWeight.normal,
                    color: _activeTab == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.trips.length,
          itemBuilder: (context, index) {
            final trip = widget.trips[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Image.network(
                  trip['imageUrl']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                title: Text(trip['title']!),
                subtitle: Text(trip['subtitle']!),
              ),
            );
          },
        ),
      ],
    );
  }
}
