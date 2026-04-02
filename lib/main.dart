import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AnestCalcApp());
}

// ─── CORES ────────────────────────────────────────────────────────
const Color kBg = Color(0xFFF5F2EE);
const Color kSurface = Color(0xFFFFFFFF);
const Color kSurface2 = Color(0xFFF0ECE6);
const Color kBorder = Color(0xFFE0D9D0);
const Color kText = Color(0xFF1A1714);
const Color kTextMuted = Color(0xFF7A736A);
const Color kAccent = Color(0xFF2D5A4E);
const Color kAccentLight = Color(0xFFE8F0EE);
const Color kWarn = Color(0xFFB85C00);
const Color kWarnLight = Color(0xFFFFF3E8);
const Color kWarnBorder = Color(0xFFF5C89A);
const Color kDanger = Color(0xFFB82020);
const Color kDangerLight = Color(0xFFFDEAEA);
const Color kDangerBorder = Color(0xFFF5AAAA);
const Color kOk = Color(0xFF1E6B45);
const Color kOkLight = Color(0xFFE6F4ED);
const Color kOkBorder = Color(0xFF9FD4BB);

// ─── MODELOS ──────────────────────────────────────────────────────
class Vasoconstritor {
  final String id;
  final String label;
  final double epiMgTubete;
  const Vasoconstritor({required this.id, required this.label, required this.epiMgTubete});
}

class Anestesico {
  final String id;
  final String nome;
  final String conc;
  final double mgTubete;
  final double doseMaxKg;
  final double doseMaxAbs;
  final double volTubete;
  final List<Vasoconstritor> vasoconstritores;
  const Anestesico({
    required this.id, required this.nome, required this.conc,
    required this.mgTubete, required this.doseMaxKg, required this.doseMaxAbs,
    required this.volTubete, required this.vasoconstritores,
  });
}

class Perfil {
  final String id;
  final String label;
  final String icon;
  final List<String>? anestesicosPermitidos;
  final Map<String, dynamic> limites;
  final String? obs;
  const Perfil({
    required this.id, required this.label, required this.icon,
    this.anestesicosPermitidos, required this.limites, this.obs,
  });
}

// ─── BASE DE DADOS ────────────────────────────────────────────────
const List<Anestesico> anestesicos = [
  Anestesico(
    id: 'lido2', nome: 'Lidocaína 2%', conc: '2%',
    mgTubete: 36, doseMaxKg: 7.0, doseMaxAbs: 500, volTubete: 1.8,
    vasoconstritores: [
      Vasoconstritor(id: 'epi100', label: 'Epinefrina 1:100.000', epiMgTubete: 0.018),
      Vasoconstritor(id: 'epi200', label: 'Epinefrina 1:200.000', epiMgTubete: 0.009),
    ],
  ),
  Anestesico(
    id: 'mepi3', nome: 'Mepivacaína 3%', conc: '3% (sem vaso)',
    mgTubete: 54, doseMaxKg: 6.6, doseMaxAbs: 400, volTubete: 1.8,
    vasoconstritores: [
      Vasoconstritor(id: 'semvaso', label: 'Sem vasoconstritor', epiMgTubete: 0),
    ],
  ),
  Anestesico(
    id: 'mepi2', nome: 'Mepivacaína 2%', conc: '2% + Levonordefrina',
    mgTubete: 36, doseMaxKg: 6.6, doseMaxAbs: 400, volTubete: 1.8,
    vasoconstritores: [
      Vasoconstritor(id: 'levo', label: 'Levonordefrina 1:20.000', epiMgTubete: 0),
    ],
  ),
  Anestesico(
    id: 'artic4', nome: 'Articaína 4%', conc: '4%',
    mgTubete: 68, doseMaxKg: 7.0, doseMaxAbs: 500, volTubete: 1.7,
    vasoconstritores: [
      Vasoconstritor(id: 'epi100', label: 'Epinefrina 1:100.000', epiMgTubete: 0.017),
      Vasoconstritor(id: 'epi200', label: 'Epinefrina 1:200.000', epiMgTubete: 0.0085),
    ],
  ),
  Anestesico(
    id: 'prilo3', nome: 'Prilocaína 3%', conc: '3% + Felipressina',
    mgTubete: 54, doseMaxKg: 6.0, doseMaxAbs: 400, volTubete: 1.8,
    vasoconstritores: [
      Vasoconstritor(id: 'feli', label: 'Felipressina 0,03 UI/ml', epiMgTubete: 0),
    ],
  ),
  Anestesico(
    id: 'bupi05', nome: 'Bupivacaína 0,5%', conc: '0,5%',
    mgTubete: 9, doseMaxKg: 2.0, doseMaxAbs: 90, volTubete: 1.8,
    vasoconstritores: [
      Vasoconstritor(id: 'semvaso', label: 'Sem vasoconstritor', epiMgTubete: 0),
    ],
  ),
];

const List<Perfil> perfis = [
  Perfil(id: 'saudavel', label: 'Saudável', icon: '🧑‍⚕️',
    anestesicosPermitidos: null, limites: {}, obs: null),
  Perfil(id: 'gestante', label: 'Gestante', icon: '🤰',
    anestesicosPermitidos: ['lido2'], limites: {'default': 2},
    obs: 'Prilocaína contraindicada (metemoglobinemia). Felipressina contraindicada (ação ocitócica). Apenas Lidocaína 2% com epinefrina, máx. 2 tubetes.'),
  Perfil(id: 'cardiopata', label: 'Cardiopata', icon: '❤️',
    anestesicosPermitidos: ['lido2', 'artic4', 'prilo3', 'bupi05'],
    limites: {'epi100': 2, 'epi200': 4, 'default': 3},
    obs: 'Com Epi 1:100.000: máx. 2 tubetes. Com Epi 1:200.000: máx. 4 tubetes. Felipressina preferível por não causar alteração cardiovascular.'),
  Perfil(id: 'hipertenso', label: 'Hipertenso', icon: '🩺',
    anestesicosPermitidos: null, limites: {'epi100': 2, 'feli': 3, 'default': 4},
    obs: 'PA acima de 140x90 mmHg: contraindicar procedimento eletivo. Epi 1:100.000 máx. 2 tubetes; Felipressina máx. 3 tubetes.'),
  Perfil(id: 'diabetico', label: 'Diabético', icon: '🍬',
    anestesicosPermitidos: null, limites: {'epi100': 3, 'epi200': 4, 'default': 4},
    obs: 'Felipressina segura (não altera glicemia). Com epinefrina: máx. 3 tubetes por sessão.'),
  Perfil(id: 'crianca', label: 'Criança', icon: '👶',
    anestesicosPermitidos: ['lido2'], limites: {'byWeight': true},
    obs: 'Dose calculada por peso: 1 tubete a cada 9,09 kg (Lidocaína 2% + Epi 1:200.000 recomendada pela AAPD). Prilocaína evitar em crianças anêmicas.'),
  Perfil(id: 'idoso', label: 'Idoso', icon: '👴',
    anestesicosPermitidos: null, limites: {'epi100': 3, 'epi200': 4, 'default': 4},
    obs: 'Idosos mais sensíveis a vasoconstritores. Preferir Lidocaína 2% + Epi 1:200.000. Não ultrapassar 0,04 mg de adrenalina por consulta.'),
];

// ─── APP ──────────────────────────────────────────────────────────
class AnestCalcApp extends StatelessWidget {
  const AnestCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnestCalc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kAccent),
        fontFamily: GoogleFonts.dmSans().fontFamily,
        scaffoldBackgroundColor: kBg,
      ),
      home: const AnestCalcPage(),
    );
  }
}

// ─── RESULTADO ────────────────────────────────────────────────────
class ResultData {
  final int tubetesArredondado;
  final double doseFinal;
  final double dosePorPeso;
  final double tubetesPorPeso;
  final double doseMaxAbs;
  final double tubetesAbsoluto;
  final String limitePerfilLabel;
  final List<AlertData> alerts;
  final Perfil perfil;
  final Anestesico anest;
  final Vasoconstritor vaso;
  final double peso;

  ResultData({
    required this.tubetesArredondado, required this.doseFinal,
    required this.dosePorPeso, required this.tubetesPorPeso,
    required this.doseMaxAbs, required this.tubetesAbsoluto,
    required this.limitePerfilLabel, required this.alerts,
    required this.perfil, required this.anest,
    required this.vaso, required this.peso,
  });
}

class AlertData {
  final String type; // 'warn', 'danger', 'ok'
  final String icon;
  final String msg;
  AlertData({required this.type, required this.icon, required this.msg});
}

// ─── PÁGINA PRINCIPAL ─────────────────────────────────────────────
class AnestCalcPage extends StatefulWidget {
  const AnestCalcPage({super.key});
  @override
  State<AnestCalcPage> createState() => _AnestCalcPageState();
}

class _AnestCalcPageState extends State<AnestCalcPage> {
  int _step = 1;
  Perfil? _perfil;
  Anestesico? _anestesico;
  Vasoconstritor? _vasoconstritor;
  double? _peso;
  ResultData? _result;
  final TextEditingController _pesoCtrl = TextEditingController();

  @override
  void dispose() {
    _pesoCtrl.dispose();
    super.dispose();
  }

  void _goStep(int n) {
    setState(() => _step = n);
  }

  void _selectPerfil(Perfil p) {
    setState(() {
      _perfil = p;
      _anestesico = null;
      _vasoconstritor = null;
    });
  }

  void _selectAnest(Anestesico a) {
    setState(() {
      _anestesico = a;
      _vasoconstritor = null;
    });
  }

  void _selectVaso(Vasoconstritor v) {
    setState(() => _vasoconstritor = v);
  }

  void _calcular() {
    final anest = _anestesico!;
    final perfil = _perfil!;
    final peso = _peso!;
    final vasoId = _vasoconstritor!.id;

    final dosePorPeso = anest.doseMaxKg * peso;
    final tubetesPorPeso = dosePorPeso / anest.mgTubete;
    final tubetesAbsoluto = anest.doseMaxAbs / anest.mgTubete;

    double? limitePerfil;
    String limitePerfilLabel = 'Sem restrição adicional';

    if (perfil.limites['byWeight'] == true) {
      limitePerfil = peso / 9.09;
      limitePerfilLabel = '${peso.toStringAsFixed(0)} ÷ 9,09 = ${limitePerfil.toStringAsFixed(2)} tubetes';
    } else if (perfil.limites[vasoId] != null) {
      limitePerfil = (perfil.limites[vasoId] as num).toDouble();
      limitePerfilLabel = '$limitePerfil tubetes (perfil ${perfil.label})';
    } else if (perfil.limites['default'] != null) {
      limitePerfil = (perfil.limites['default'] as num).toDouble();
      limitePerfilLabel = '$limitePerfil tubetes (perfil ${perfil.label})';
    }

    double tubetesFinais = min(tubetesPorPeso, tubetesAbsoluto);
    if (limitePerfil != null) tubetesFinais = min(tubetesFinais, limitePerfil);
    tubetesFinais = (tubetesFinais * 10).floor() / 10;
    final tubetesArredondado = tubetesFinais.floor();
    final doseFinal = tubetesArredondado * anest.mgTubete;

    final alerts = <AlertData>[];
    if (limitePerfil != null && limitePerfil <= tubetesPorPeso) {
      alerts.add(AlertData(
        type: 'warn', icon: '⚠️',
        msg: 'O limite do perfil ${perfil.label} é mais restritivo que o cálculo por peso. O resultado foi limitado a $tubetesArredondado tubetes.',
      ));
    }
    if (perfil.obs != null) {
      alerts.add(AlertData(type: 'ok', icon: 'ℹ️', msg: perfil.obs!));
    }
    if (tubetesArredondado == 0) {
      alerts.add(AlertData(
        type: 'danger', icon: '🔴',
        msg: 'O peso informado resulta em menos de 1 tubete seguro. Reavalie a indicação ou consulte um especialista.',
      ));
    }

    setState(() {
      _result = ResultData(
        tubetesArredondado: tubetesArredondado,
        doseFinal: doseFinal,
        dosePorPeso: dosePorPeso,
        tubetesPorPeso: tubetesPorPeso,
        doseMaxAbs: anest.doseMaxAbs,
        tubetesAbsoluto: tubetesAbsoluto,
        limitePerfilLabel: limitePerfilLabel,
        alerts: alerts,
        perfil: perfil,
        anest: anest,
        vaso: _vasoconstritor!,
        peso: peso,
      );
      _step = 5;
    });
  }

  void _reiniciar() {
    setState(() {
      _perfil = null;
      _anestesico = null;
      _vasoconstritor = null;
      _peso = null;
      _result = null;
      _pesoCtrl.clear();
      _step = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 60),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildStepIndicator(),
                  const SizedBox(height: 28),
                  _buildCurrentStep(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text('AnestCalc',
          style: TextStyle(
            fontSize: 32, color: kAccent, fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            fontFamily: GoogleFonts.dmSerifDisplay().fontFamily,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4),
        Text('Calculadora de Anestesia Odontológica · Uso Clínico',
          style: TextStyle(fontSize: 13, color: kTextMuted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      children: [
        for (int i = 1; i <= 5; i++) ...[
          _StepDot(number: i, currentStep: _step),
          if (i < 5) Expanded(child: _StepLine(stepIndex: i, currentStep: _step)),
        ],
      ],
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      case 4: return _buildStep4();
      case 5: return _buildStep5();
      default: return const SizedBox();
    }
  }

  // ── STEP 1: PERFIL ──────────────────────────────────────────────
  Widget _buildStep1() {
    final options = [
      ('saudavel', '🧑‍⚕️', 'Saudável', 'Sem condições sistêmicas relevantes'),
      ('gestante', '🤰', 'Gestante', 'Grávida ou amamentando'),
      ('cardiopata', '❤️', 'Cardiopata', 'Doença cardiovascular ASA III/IV'),
      ('hipertenso', '🩺', 'Hipertenso', 'Pressão arterial elevada controlada'),
      ('diabetico', '🍬', 'Diabético', 'Diabetes mellitus controlado'),
      ('crianca', '👶', 'Criança', 'Paciente pediátrico'),
    ];

    return _Card(
      title: 'Perfil do paciente',
      subtitle: 'Selecione o perfil clínico para filtrar os anestésicos seguros',
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final cellWidth = (constraints.maxWidth - 10) / 2;
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: cellWidth / 130,
                children: options.map((o) {
                  final p = perfis.firstWhere((p) => p.id == o.$1);
                  return _OptionButton(
                    icon: o.$2, label: o.$3, desc: o.$4,
                    selected: _perfil?.id == o.$1,
                    onTap: () => _selectPerfil(p),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 10),
          _OptionButton(
            icon: '👴', label: 'Idoso',
            desc: 'Maior sensibilidade a vasoconstritores',
            selected: _perfil?.id == 'idoso',
            fullWidth: true,
            onTap: () => _selectPerfil(perfis.firstWhere((p) => p.id == 'idoso')),
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            label: 'Continuar →',
            enabled: _perfil != null,
            onPressed: () => _goStep(2),
          ),
        ],
      ),
    );
  }

  // ── STEP 2: ANESTÉSICO ──────────────────────────────────────────
  Widget _buildStep2() {
    return _Card(
      title: 'Anestésico',
      subtitle: 'Apenas os indicados para o perfil selecionado estão ativos',
      child: Column(
        children: [
          ...anestesicos.map((a) {
            final allowed = _perfil!.anestesicosPermitidos == null ||
                _perfil!.anestesicosPermitidos!.contains(a.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _AnestButton(
                nome: a.nome,
                meta: '${a.mgTubete.toStringAsFixed(0)} mg/tubete · max ${a.doseMaxKg} mg/kg · máx abs. ${a.doseMaxAbs.toStringAsFixed(0)} mg',
                badge: a.conc,
                allowed: allowed,
                selected: _anestesico?.id == a.id,
                onTap: allowed ? () => _selectAnest(a) : null,
              ),
            );
          }),
          const SizedBox(height: 12),
          _PrimaryButton(
            label: 'Continuar →',
            enabled: _anestesico != null,
            onPressed: () => _goStep(3),
          ),
          const SizedBox(height: 10),
          _GhostButton(label: '← Voltar', onPressed: () => _goStep(1)),
        ],
      ),
    );
  }

  // ── STEP 3: VASOCONSTRITOR ──────────────────────────────────────
  Widget _buildStep3() {
    final vasos = _anestesico!.vasoconstritores;
    return _Card(
      title: 'Vasoconstritor',
      subtitle: 'Associações disponíveis para o anestésico escolhido',
      child: Column(
        children: [
          ...vasos.map((v) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _AnestButton(
              nome: v.label,
              meta: null,
              badge: null,
              allowed: true,
              selected: _vasoconstritor?.id == v.id,
              onTap: () => _selectVaso(v),
            ),
          )),
          const SizedBox(height: 12),
          _PrimaryButton(
            label: 'Continuar →',
            enabled: _vasoconstritor != null,
            onPressed: () => _goStep(4),
          ),
          const SizedBox(height: 10),
          _GhostButton(label: '← Voltar', onPressed: () => _goStep(2)),
        ],
      ),
    );
  }

  // ── STEP 4: PESO ────────────────────────────────────────────────
  Widget _buildStep4() {
    return _Card(
      title: 'Peso do paciente',
      subtitle: 'Insira o peso para calcular a dose máxima segura',
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _pesoCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32, fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.dmMono().fontFamily, color: kText,
                  ),
                  decoration: InputDecoration(
                    hintText: '70',
                    hintStyle: const TextStyle(color: kTextMuted),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kBorder, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: kAccent, width: 2),
                    ),
                    filled: true,
                    fillColor: kSurface,
                  ),
                  onChanged: (val) {
                    final v = double.tryParse(val);
                    setState(() => _peso = (v != null && v > 0) ? v : null);
                  },
                ),
              ),
              const SizedBox(width: 12),
              const Text('kg', style: TextStyle(fontSize: 16, color: kTextMuted, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 20),
          _PrimaryButton(
            label: 'Calcular →',
            enabled: _peso != null,
            onPressed: _calcular,
          ),
          const SizedBox(height: 10),
          _GhostButton(label: '← Voltar', onPressed: () => _goStep(3)),
        ],
      ),
    );
  }

  // ── STEP 5: RESULTADO ───────────────────────────────────────────
  Widget _buildStep5() {
    final r = _result!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Summary bar
        Container(
          decoration: BoxDecoration(
            color: kSurface2,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.only(bottom: 20),
          child: Wrap(
            spacing: 16, runSpacing: 6,
            children: [
              _summaryChip('${r.perfil.icon} ${r.perfil.label}'),
              _summaryChip('💊 ${r.anest.nome}'),
              _summaryChip('💉 ${r.vaso.label}'),
              _summaryChip('⚖️ ${r.peso.toStringAsFixed(0)} kg'),
            ],
          ),
        ),
        // Result card
        Container(
          decoration: BoxDecoration(
            color: kSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBorder),
            boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 16, offset: Offset(0, 2))],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Hero
              Container(
                color: kAccent,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('${r.tubetesArredondado}',
                        style: TextStyle(
                          fontSize: 80, color: Colors.white,
                          fontWeight: FontWeight.w700, height: 1,
                          fontFamily: GoogleFonts.dmSerifDisplay().fontFamily,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text('TUBETES RECOMENDADOS',
                      style: TextStyle(fontSize: 13, color: Colors.white70, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 8),
                    Text('${r.anest.nome} · ${r.anest.conc}',
                      style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _resultRow('Dose total', '${r.doseFinal.toStringAsFixed(0)} mg'),
                    _resultRow('Dose máx. pelo peso',
                      '${r.dosePorPeso.toStringAsFixed(0)} mg (${r.tubetesPorPeso.toStringAsFixed(1)} tubetes)'),
                    _resultRow('Dose máx. absoluta',
                      '${r.doseMaxAbs.toStringAsFixed(0)} mg (${r.tubetesAbsoluto.toStringAsFixed(1)} tubetes)'),
                    _resultRow('Limite do perfil', r.limitePerfilLabel, last: true),
                    const SizedBox(height: 8),
                    ...r.alerts.map((a) => _AlertWidget(alert: a)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _PrimaryButton(label: '↺ Novo cálculo', enabled: true, onPressed: _reiniciar),
        const SizedBox(height: 20),
        const Text(
          '⚠️ Esta calculadora é uma ferramenta de apoio clínico baseada em literatura odontológica.\n'
          'O julgamento clínico do profissional habilitado prevalece sobre qualquer resultado.\n'
          'Fonte: Malamed 6ª ed., FDA, StatPearls/NCBI, AAPD.',
          style: TextStyle(fontSize: 11, color: kTextMuted, height: 1.6),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _summaryChip(String text) {
    return Text(text, style: const TextStyle(fontSize: 12, color: kTextMuted));
  }

  Widget _resultRow(String key, String val, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: last ? null : const Border(bottom: BorderSide(color: kBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(key, style: const TextStyle(fontSize: 13, color: kTextMuted)),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(val,
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600,
                fontFamily: GoogleFonts.dmMono().fontFamily, color: kText,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── WIDGETS REUTILIZÁVEIS ────────────────────────────────────────
class _Card extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _Card({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 16, offset: Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20, color: kAccent, fontWeight: FontWeight.w700, fontFamily: GoogleFonts.dmSerifDisplay().fontFamily)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 13, color: kTextMuted)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String icon;
  final String label;
  final String desc;
  final bool selected;
  final bool fullWidth;
  final VoidCallback onTap;
  const _OptionButton({
    required this.icon, required this.label, required this.desc,
    required this.selected, required this.onTap, this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? kAccentLight : kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? kAccent : kBorder, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kText)),
            const SizedBox(height: 2),
            Text(desc, style: const TextStyle(fontSize: 11, color: kTextMuted, height: 1.3)),
          ],
        ),
      ),
    );
  }
}

class _AnestButton extends StatelessWidget {
  final String nome;
  final String? meta;
  final String? badge;
  final bool allowed;
  final bool selected;
  final VoidCallback? onTap;
  const _AnestButton({
    required this.nome, this.meta, this.badge,
    required this.allowed, required this.selected, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? kAccentLight : kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? kAccent : kBorder, width: 2),
        ),
        child: Opacity(
          opacity: allowed ? 1.0 : 0.35,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                        child: Text(nome, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kText)),
                      ),
                      if (!allowed) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: kWarnLight, borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: kWarnBorder),
                          ),
                          child: const Text('restrito', style: TextStyle(fontSize: 10, color: kWarn, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ]),
                    if (meta != null) ...[
                      const SizedBox(height: 2),
                      Text(meta!, style: const TextStyle(fontSize: 11, color: kTextMuted)),
                    ],
                  ],
                ),
              ),
              if (badge != null)
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: kSurface2, borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: kBorder),
                    ),
                    child: Text(badge!, style: TextStyle(
                      fontSize: 11, color: kTextMuted, fontFamily: GoogleFonts.dmMono().fontFamily,
                    )),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback? onPressed;
  const _PrimaryButton({required this.label, required this.enabled, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: kAccent,
          disabledBackgroundColor: kAccent.withAlpha(100),
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white54,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2)),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const _GhostButton({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: kTextMuted,
          side: const BorderSide(color: kBorder, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int number;
  final int currentStep;
  const _StepDot({required this.number, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isActive = number == currentStep;
    final isDone = number < currentStep;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 28, height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? kAccent : isDone ? kOkLight : kSurface,
        border: Border.all(
          color: isActive ? kAccent : isDone ? kOk : kBorder, width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 11, fontWeight: FontWeight.w600, fontFamily: GoogleFonts.dmMono().fontFamily,
          color: isActive ? Colors.white : isDone ? kOk : kTextMuted,
        ),
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final int stepIndex;
  final int currentStep;
  const _StepLine({required this.stepIndex, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isDone = stepIndex < currentStep;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 2,
      color: isDone ? kOk : kBorder,
    );
  }
}

class _AlertWidget extends StatelessWidget {
  final AlertData alert;
  const _AlertWidget({required this.alert});

  @override
  Widget build(BuildContext context) {
    Color bg, fg, border;
    switch (alert.type) {
      case 'warn':
        bg = kWarnLight; fg = kWarn; border = kWarnBorder;
      case 'danger':
        bg = kDangerLight; fg = kDanger; border = kDangerBorder;
      default:
        bg = kOkLight; fg = kOk; border = kOkBorder;
    }
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg, borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(alert.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(alert.msg, style: TextStyle(fontSize: 13, color: fg, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
