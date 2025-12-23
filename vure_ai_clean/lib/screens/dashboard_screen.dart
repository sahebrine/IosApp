import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vure_dashboard/widgets/animated_action_button.dart';
import 'package:vure_dashboard/widgets/animated_appbar_chip.dart';
import 'package:vure_dashboard/widgets/animated_filter_chip.dart';
import 'package:vure_dashboard/widgets/animated_gradient_button.dart';
import 'package:vure_dashboard/widgets/animated_stat_card.dart';
import 'package:vure_dashboard/widgets/animated_table_container.dart';
import '../services/api_client.dart';
import '../dialogs/create_key_dialog.dart';
import '../dialogs/extend_days_dialog.dart';
import '../dialogs/confirm_delete_dialog.dart';
import '../dialogs/success_dialog.dart';
import '../dialogs/reset_dialog.dart';
import '../widgets/status_badge.dart';

/* ============================================================
   BACKGROUND ANIMATION
============================================================ */
class VureAnimatedBackground extends StatefulWidget {
  const VureAnimatedBackground({super.key});

  @override
  State<VureAnimatedBackground> createState() => _VureAnimatedBackgroundState();
}

class _VureAnimatedBackgroundState extends State<VureAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _a1;
  late Animation<Alignment> _a2;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);

    _a1 = Tween(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _a2 = Tween(
      begin: Alignment.bottomRight,
      end: Alignment.topLeft,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: _a1.value,
              end: _a2.value,
              colors: const [
                Color(0xFF0B1020),
                Color(0xFF3B1C7A),
                Color(0xFF6C3BFF),
                Color(0xFF2A1458),
              ],
              stops: const [0.0, 0.35, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/* ============================================================
   DASHBOARD
============================================================ */

class DashboardScreen extends StatefulWidget {
  final String username;
  const DashboardScreen({super.key, required this.username});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  List keys = [];
  List filtered = [];

  String filter = "all";
  String search = "";
  bool loading = true;

  late AnimationController tableAnimCtrl;
  late Animation<double> tableFade;
  late Animation<Offset> tableSlide;

  String safe(dynamic v) => v?.toString() ?? "-";

  @override
  void initState() {
    super.initState();

    tableAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    tableFade = CurvedAnimation(parent: tableAnimCtrl, curve: Curves.easeOut);

    tableSlide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: tableAnimCtrl,
        curve: Curves.easeOutCubic,
      ),
    );

    fetch();
  }

  @override
  void dispose() {
    tableAnimCtrl.dispose();
    super.dispose();
  }

  Future<void> fetch() async {
    setState(() => loading = true);

    final res = await ApiClient.getKeys();
    if (res.statusCode == 200) {
      keys = res.data["keys"] ?? [];
      applyFilters();
      tableAnimCtrl.forward(from: 0);
    }

    setState(() => loading = false);
  }

  void applyFilters() {
    filtered = keys.where((k) {
      final s = search.toLowerCase();
      final matchSearch = s.isEmpty ||
          safe(k["key"]).toLowerCase().contains(s) ||
          safe(k["name"]).toLowerCase().contains(s) ||
          safe(k["hwid"]).toLowerCase().contains(s);

      if (!matchSearch) return false;

      switch (filter) {
        case "active":
          return k["status"] == "Active";
        case "pending":
          return k["status"] == "Pending";
        case "expired":
          return k["status"] == "Expired";
        case "used":
          return safe(k["hwid"]) != "-";
        case "notused":
          return safe(k["hwid"]) == "-";
        default:
          return true;
      }
    }).toList();

    setState(() {});
  }

  /* ================= UI HELPERS ================= */

  Widget statCard(String title, int count, String sub) {
    return Container(
      width: 180,
      height: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1327),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$count",
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 6),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
          Text(sub,
              style: const TextStyle(fontSize: 11, color: Colors.white60)),
        ],
      ),
    );
  }

  Widget filterChip(String key, String label) {
    final active = filter == key;
    return GestureDetector(
      onTap: () {
        filter = key;
        applyFilters();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? Colors.purple.withOpacity(.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? Colors.purple : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? Colors.purpleAccent : Colors.white70,
          ),
        ),
      ),
    );
  }

  /* ================= TABLE ================= */

  Widget tableWidget() {
    return AnimatedTableContainer(
      child: DataTable(
        headingTextStyle: const TextStyle(color: Colors.white),
        dataTextStyle: const TextStyle(color: Colors.white),
        columns: const [
          DataColumn(label: Text("الكود")),
          DataColumn(label: Text("الاسم")),
          DataColumn(label: Text("HWID")),
          DataColumn(label: Text("الحالة")),
          DataColumn(label: Text("المدة")),
          DataColumn(label: Text("الإجراءات")),
        ],
        rows: filtered.map<DataRow>((k) {
          return DataRow(cells: [
            DataCell(Text(safe(k["key"]))),
            DataCell(Text(safe(k["name"]))),
            DataCell(Text(safe(k["hwid"]))),
            DataCell(StatusBadge(safe(k["status"]))),
            DataCell(Text(safe(k["remaining"]))),
            DataCell(Row(
              children: [
                AnimatedActionButton(
                  text: "Reset HWID",
                  type: ActionType.reset,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ResetConfirmDialog(
                        keyValue: k["key"],
                        onConfirm: () async {
                          await ApiClient.resetKey(k["key"]);
                          fetch();
                          showDialog(
                            context: context,
                            builder: (_) => SuccessDialog(
                              title: "تمت العملية",
                              message:
                                  "تم إعادة تعيين HWID للكود:\n${k["key"]}",
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                AnimatedActionButton(
                  text: "+ أيام",
                  type: ActionType.extend,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => ExtendDaysDialog(
                        keyValue: k["key"],
                        onConfirm: (days) async {
                          await ApiClient.extendKey(k["key"], int.parse(days));
                          fetch();
                          showDialog(
                            context: context,
                            builder: (_) => SuccessDialog(
                              title: "تمت الإضافة",
                              message:
                                  "تم إضافة $days أيام للكود:\n${k["key"]}",
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                AnimatedActionButton(
                  text: "حذف",
                  type: ActionType.delete,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => DeleteConfirmDialog(
                        keyValue: k["key"],
                        onConfirm: () async {
                          await ApiClient.deleteKey(k["key"]);
                          fetch();
                          showDialog(
                            context: context,
                            builder: (_) => SuccessDialog(
                              title: "تم الحذف",
                              message: "تم حذف الكود:\n${k["key"]}",
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }

  /* ================= BUILD ================= */

  @override
  Widget build(BuildContext context) {
    final total = keys.length;
    final active = keys.where((k) => k["status"] == "Active").length;
    final pending = keys.where((k) => k["status"] == "Pending").length;
    final expired = keys.where((k) => k["status"] == "Expired").length;
    final used = keys.where((k) => safe(k["hwid"]) != "-").length;
    final notUsed = keys.where((k) => safe(k["hwid"]) == "-").length;

    return Stack(
      children: [
        const Positioned.fill(child: VureAnimatedBackground()),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: const Color(0xFF131B2E).withOpacity(.85),
              title: Row(
                children: [
                  Image.network(
                    "https://image2url.com/images/1765682676461-38f0310c-49ef-4ca7-86a4-45c8c8732eba.png",
                    height: 32, // أنسب من 35
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Vure Ai Dashboard",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  children: [
                    // ADMIN BADGE
                    AnimatedAppBarChip(
                      text: "Admin: ${widget.username}",
                      colors: const [
                        Color(0xFF6366F1),
                        Color(0xFF4338CA),
                        Color(0xFF312E81),
                      ],
                    ),

                    const SizedBox(width: 10),

                    // LOGOUT BUTTON
                    AnimatedAppBarChip(
                      text: "تسجيل خروج",
                      outlined: true,
                      colors: const [
                        Color(0xFFEF4444),
                        Color(0xFFB91C1C),
                      ],
                      onTap: () async {
                        await ApiClient.logout();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          "/login",
                          (route) => false,
                        );
                      },
                    ),

                    const SizedBox(width: 12),
                  ],
                ),
              ],
            ),
            body: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            AnimatedStatCard(
                              title: "إجمالي الأكواد",
                              count: total,
                              subtitle: "",
                            ),
                            AnimatedStatCard(
                              title: "فعالة",
                              count: active,
                              subtitle: "غير منتهية",
                            ),
                            AnimatedStatCard(
                              title: "غير فعالة",
                              count: pending,
                              subtitle: "بانتظار تفعليها",
                            ),
                            AnimatedStatCard(
                              title: "مستخدمة",
                              count: used,
                              subtitle: "HWID مرتبط",
                            ),
                            AnimatedStatCard(
                              title: "غير مستخدمة",
                              count: notUsed,
                              subtitle: "لم تُستخدم",
                            ),
                            AnimatedStatCard(
                              title: "منتهية",
                              count: expired,
                              subtitle: "انتهت",
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        /* SEARCH + BUTTONS */

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0E1327),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: "بحث حسب الكود / الاسم / HWID",
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (v) {
                                    search = v;
                                    applyFilters();
                                  },
                                ),
                              ),
                              AnimatedGradientButton(
                                text: "إنشاء كود",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => CreateKeyDialog(
                                      onConfirm: (duration, name) async {
                                        final res = await ApiClient.createKey(
                                            duration, name);
                                        fetch();
                                        showDialog(
                                          context: context,
                                          builder: (_) => SuccessDialog(
                                            title: "نجاح",
                                            message:
                                                "تم إنشاء كود جديد\nالاسم: $name\nالكود: ${res.data['key']}",
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              AnimatedGradientButton(
                                text: "إضافة أيام للجميع",
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => ExtendDaysDialog(
                                      keyValue: "",
                                      isGlobal: true,
                                      onConfirm: (days) async {
                                        await ApiClient.extendAll(
                                            int.parse(days));
                                        fetch();
                                        showDialog(
                                          context: context,
                                          builder: (_) => SuccessDialog(
                                            title: "تمت الإضافة",
                                            message:
                                                "تم إضافة $days أيام لجميع الأكواد",
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            AnimatedFilterChip(
                              label: "الكل",
                              active: filter == "all",
                              onTap: () {
                                setState(() {
                                  filter = "all";
                                  applyFilters();
                                });
                              },
                            ),
                            AnimatedFilterChip(
                              label: "فعال",
                              active: filter == "active",
                              onTap: () {
                                setState(() {
                                  filter = "active";
                                  applyFilters();
                                });
                              },
                            ),
                            AnimatedFilterChip(
                              label: "قيد التفعيل",
                              active: filter == "pending",
                              onTap: () {
                                setState(() {
                                  filter = "pending";
                                  applyFilters();
                                });
                              },
                            ),
                            AnimatedFilterChip(
                              label: "منتهي",
                              active: filter == "expired",
                              onTap: () {
                                setState(() {
                                  filter = "expired";
                                  applyFilters();
                                });
                              },
                            ),
                            AnimatedFilterChip(
                              label: "مستخدم",
                              active: filter == "used",
                              onTap: () {
                                setState(() {
                                  filter = "used";
                                  applyFilters();
                                });
                              },
                            ),
                            AnimatedFilterChip(
                              label: "غير مستخدم",
                              active: filter == "notused",
                              onTap: () {
                                setState(() {
                                  filter = "notused";
                                  applyFilters();
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        FadeTransition(
                          opacity: tableFade,
                          child: SlideTransition(
                            position: tableSlide,
                            child: tableWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
