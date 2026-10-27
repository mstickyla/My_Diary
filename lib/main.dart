import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const DiaryExpenseApp());
}

const _ink = Color(0xFF183A34);
const _mutedInk = Color(0xFF73817B);
const _paper = Color(0xFFF4F6F3);
const _line = Color(0xFFE2E8E3);
const _coral = Color(0xFFF2765B);
const _mint = Color(0xFFDCEFE5);

class DiaryExpenseApp extends StatelessWidget {
  const DiaryExpenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daybook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _ink,
          primary: _ink,
          surface: _paper,
        ),
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Arial', color: _ink),
          bodySmall: TextStyle(fontFamily: 'Arial', color: _mutedInk),
          labelLarge: TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.w600),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1700), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, animation, __) => const ExpenseHomePage(),
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 450),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ink,
      body: Stack(
        children: [
          Positioned(
            right: -105,
            top: -95,
            child: Container(
              width: 310,
              height: 310,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
              ),
            ),
          ),
          Positioned(
            right: -60,
            top: -50,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: _coral,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 22),
                const Text(
                  'daybook',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'A little record of every day',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontFamily: 'Arial',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 38,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 34,
                height: 4,
                decoration: BoxDecoration(
                  color: _coral,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenseEntry {
  ExpenseEntry({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  final String title;
  final double amount;
  final String category;
  final DateTime date;
}

const _categories = <String>[
  'Food',
  'Travel',
  'Home',
  'Coffee',
  'Health',
  'Other',
];

const _categoryColors = <String, Color>{
  'Food': Color(0xFFF5E5D6),
  'Travel': Color(0xFFDDE9F0),
  'Home': Color(0xFFE7E4F0),
  'Coffee': Color(0xFFF2E7CF),
  'Health': Color(0xFFDCEFE5),
  'Other': Color(0xFFE5EAE6),
};

const _categoryIcons = <String, IconData>{
  'Food': Icons.restaurant_rounded,
  'Travel': Icons.directions_bus_rounded,
  'Home': Icons.chair_alt_rounded,
  'Coffee': Icons.local_cafe_rounded,
  'Health': Icons.favorite_rounded,
  'Other': Icons.sell_rounded,
};

class ExpenseHomePage extends StatefulWidget {
  const ExpenseHomePage({super.key});

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final List<ExpenseEntry> _entries = [
    ExpenseEntry(
      title: 'Market groceries',
      amount: 32.80,
      category: 'Food',
      date: DateTime.now(),
    ),
    ExpenseEntry(
      title: 'Morning coffee',
      amount: 4.50,
      category: 'Coffee',
      date: DateTime.now(),
    ),
    ExpenseEntry(
      title: 'Metro card',
      amount: 18.00,
      category: 'Travel',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ExpenseEntry(
      title: 'Fresh flowers',
      amount: 12.00,
      category: 'Home',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  int _selectedTab = 0;
  static const _monthlyBudget = 1800.0;

  double get _monthTotal => _entries.fold(0, (total, entry) => total + entry.amount);

  double get _todayTotal => _entries
      .where((entry) => _isSameDay(entry.date, DateTime.now()))
      .fold(0, (total, entry) => total + entry.amount);

  bool _isSameDay(DateTime first, DateTime second) =>
      first.year == second.year && first.month == second.month && first.day == second.day;

  Future<void> _showAddExpense() async {
    final entry = await showModalBottomSheet<ExpenseEntry>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => const AddExpenseSheet(),
    );
    if (entry != null && mounted) {
      setState(() => _entries.insert(0, entry));
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monthLabel = _monthName(now.month);
    final greeting = now.hour < 12 ? 'Good morning' : (now.hour < 18 ? 'Good afternoon' : 'Good evening');
    final visibleEntries = _selectedTab == 0 ? _entries.take(4).toList() : _entries;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _TopBar(greeting: greeting),
                        const SizedBox(height: 28),
                        _MonthSummary(
                          monthLabel: monthLabel,
                          monthTotal: _monthTotal,
                          todayTotal: _todayTotal,
                          budget: _monthlyBudget,
                        ),
                        const SizedBox(height: 28),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                _selectedTab == 0 ? 'Recent entries' : 'All entries',
                                style: const TextStyle(
                                  color: _ink,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (_selectedTab == 0 && _entries.length > 4)
                              TextButton(
                                onPressed: () => setState(() => _selectedTab = 1),
                                style: TextButton.styleFrom(foregroundColor: _ink),
                                child: const Text('See all'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (visibleEntries.isEmpty)
                          const _EmptyEntries()
                        else
                          ...visibleEntries.map((entry) => _EntryTile(entry: entry)),
                        const SizedBox(height: 16),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            _BottomBar(
              selectedTab: _selectedTab,
              onSelected: (tab) => setState(() => _selectedTab = tab),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddExpense,
        backgroundColor: _coral,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add expense', style: TextStyle(fontFamily: 'Arial', fontWeight: FontWeight.w600)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.greeting});

  final String greeting;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(fontFamily: 'Arial', color: _mutedInk, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                '${_weekdayName(now.weekday)}, ${_monthName(now.month)} ${now.day}',
                style: const TextStyle(color: _ink, fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: _mint, borderRadius: BorderRadius.circular(15)),
          child: const Icon(Icons.auto_stories_rounded, color: _ink, size: 22),
        ),
      ],
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({
    required this.monthLabel,
    required this.monthTotal,
    required this.todayTotal,
    required this.budget,
  });

  final String monthLabel;
  final double monthTotal;
  final double todayTotal;
  final double budget;

  @override
  Widget build(BuildContext context) {
    final progress = (monthTotal / budget).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _ink, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$monthLabel at a glance',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontFamily: 'Arial',
                    fontSize: 13,
                  ),
                ),
              ),
              const Icon(Icons.north_east_rounded, color: _coral, size: 19),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            _money(monthTotal),
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation<Color>(_coral),
            ),
          ),
          const SizedBox(height: 11),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_money(budget - monthTotal)} left of ${_money(budget)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontFamily: 'Arial',
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                'Today ${_money(todayTotal)}',
                style: const TextStyle(color: Colors.white, fontFamily: 'Arial', fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});

  final ExpenseEntry entry;

  @override
  Widget build(BuildContext context) {
    final categoryColor = _categoryColors[entry.category] ?? _categoryColors['Other']!;
    final icon = _categoryIcons[entry.category] ?? _categoryIcons['Other']!;
    final dateLabel = _isToday(entry.date)
        ? 'Today'
        : (_isYesterday(entry.date) ? 'Yesterday' : '${_monthName(entry.date.month)} ${entry.date.day}');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: _line))),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: categoryColor, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: _ink, size: 21),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Arial', fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text('$dateLabel  ·  ${entry.category}',
                    style: const TextStyle(fontFamily: 'Arial', fontSize: 12, color: _mutedInk)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('−${_money(entry.amount)}',
              style: const TextStyle(fontFamily: 'Arial', fontSize: 15, fontWeight: FontWeight.w600, color: _ink)),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }
}

class _EmptyEntries extends StatelessWidget {
  const _EmptyEntries();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 38),
      child: Column(
        children: [
          Icon(Icons.edit_note_rounded, color: _mutedInk.withValues(alpha: 0.7), size: 38),
          const SizedBox(height: 9),
          const Text('No entries yet', style: TextStyle(color: _ink, fontSize: 17)),
          const SizedBox(height: 5),
          const Text('Add the first little note of your spending.',
              textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Arial', color: _mutedInk, fontSize: 13)),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.selectedTab, required this.onSelected});

  final int selectedTab;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: _line))),
      padding: const EdgeInsets.fromLTRB(36, 10, 36, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.grid_view_rounded, label: 'Overview', selected: selectedTab == 0, onTap: () => onSelected(0)),
          _NavItem(icon: Icons.receipt_long_rounded, label: 'Entries', selected: selectedTab == 1, onTap: () => onSelected(1)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label, required this.selected, required this.onTap});

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? _ink : _mutedInk;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(fontFamily: 'Arial', color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class AddExpenseSheet extends StatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  State<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<AddExpenseSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  String? _amountError;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    final amount = double.tryParse(_amountController.text.trim().replaceAll(',', '.'));
    if (amount == null || amount <= 0) {
      setState(() => _amountError = 'Enter an amount greater than zero');
      return;
    }
    Navigator.of(context).pop(
      ExpenseEntry(
        title: _titleController.text.trim().isEmpty ? _selectedCategory : _titleController.text.trim(),
        amount: amount,
        category: _selectedCategory,
        date: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(22, 12, 22, 22 + bottomInset),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(color: _line, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 22),
            const Text('A new entry', style: TextStyle(color: _ink, fontSize: 25, fontWeight: FontWeight.w600)),
            const SizedBox(height: 5),
            const Text('What did you spend today?', style: TextStyle(fontFamily: 'Arial', color: _mutedInk, fontSize: 13)),
            const SizedBox(height: 22),
            TextField(
              controller: _amountController,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) {
                if (_amountError != null) setState(() => _amountError = null);
              },
              style: const TextStyle(fontFamily: 'Arial', fontSize: 22, fontWeight: FontWeight.w600, color: _ink),
              decoration: InputDecoration(
                prefixText: '\$ ',
                prefixStyle: const TextStyle(fontFamily: 'Arial', color: _mutedInk, fontSize: 20),
                hintText: '0.00',
                errorText: _amountError,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Add a note (optional)',
                prefixIcon: const Icon(Icons.edit_note_rounded, color: _mutedInk),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 19),
            const Text('CATEGORY', style: TextStyle(fontFamily: 'Arial', color: _mutedInk, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.7)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categories.map((category) {
                final selected = category == _selectedCategory;
                return ChoiceChip(
                  avatar: Icon(_categoryIcons[category], size: 16, color: selected ? Colors.white : _ink),
                  label: Text(category),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _selectedCategory = category),
                  labelStyle: TextStyle(
                    fontFamily: 'Arial',
                    color: selected ? Colors.white : _ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: Colors.white,
                  selectedColor: _ink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide(color: selected ? _ink : _line),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save entry', style: TextStyle(fontFamily: 'Arial', fontSize: 15, fontWeight: FontWeight.w600)),
                style: FilledButton.styleFrom(
                  backgroundColor: _coral,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _money(double value) => '\$${value.toStringAsFixed(2)}';

String _monthName(int month) => const [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ][month - 1];

String _weekdayName(int weekday) => const [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
    ][weekday - 1];
