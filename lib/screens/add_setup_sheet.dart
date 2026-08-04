import 'package:flutter/material.dart';

import '../models/bike_model.dart';

class AddSetupSheet extends StatefulWidget {
  const AddSetupSheet({super.key});

  @override
  State<AddSetupSheet> createState() => _AddSetupSheetState();
}

class _AddSetupSheetState extends State<AddSetupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _ownerController = TextEditingController();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();
  final _frameController = TextEditingController();
  final _forkController = TextEditingController();
  final _handlebarController = TextEditingController();
  final _stemController = TextEditingController();
  final _gripsController = TextEditingController();
  final _headsetController = TextEditingController();
  final _seatpostController = TextEditingController();
  final _saddleController = TextEditingController();
  final _seatClampController = TextEditingController();
  final _hubsController = TextEditingController();
  final _rimsController = TextEditingController();
  final _spokesController = TextEditingController();
  final _nipplesController = TextEditingController();
  final _tiresController = TextEditingController();
  final _cranksetController = TextEditingController();
  final _bottomBracketController = TextEditingController();
  final _chainController = TextEditingController();
  final _lokringController = TextEditingController();
  final _pedalsController = TextEditingController();
  final _strapsController = TextEditingController();
  final _chainringController = TextEditingController();
  final _cogController = TextEditingController();

  @override
  void dispose() {
    _ownerController.dispose();
    _nameController.dispose();
    _imageController.dispose();
    _frameController.dispose();
    _forkController.dispose();
    _handlebarController.dispose();
    _stemController.dispose();
    _gripsController.dispose();
    _headsetController.dispose();
    _seatpostController.dispose();
    _saddleController.dispose();
    _seatClampController.dispose();
    _hubsController.dispose();
    _rimsController.dispose();
    _spokesController.dispose();
    _nipplesController.dispose();
    _tiresController.dispose();
    _cranksetController.dispose();
    _bottomBracketController.dispose();
    _chainController.dispose();
    _lokringController.dispose();
    _pedalsController.dispose();
    _strapsController.dispose();
    _chainringController.dispose();
    _cogController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 8),
              Text(
                'новый сэтап',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              _sectionCard(
                context,
                'рама',
                [
                  _textField(_ownerController, 'юзерку бро',
                      required: true, action: TextInputAction.next),
                  _textField(_nameController, 'нэйм фикса',
                      required: true, action: TextInputAction.next),
                  _textField(_imageController, 'ссылка на фото',
                      required: true, action: TextInputAction.next),
                  _textField(_frameController, 'рама',
                      required: true, action: TextInputAction.next),
                  _textField(_forkController, 'вилка',
                      action: TextInputAction.next),
                ],
              ),
              _sectionCard(
                context,
                'кокпит',
                [
                  _textField(_handlebarController, 'руль',
                      action: TextInputAction.next),
                  _textField(_stemController, 'вынос',
                      action: TextInputAction.next),
                  _textField(_gripsController, 'грипсы / обмотка',
                      action: TextInputAction.next),
                ],
              ),
              _sectionCard(
                context,
                'рулевая',
                [
                  _textField(_headsetController, 'рулевая',
                      action: TextInputAction.next),
                ],
              ),
              _sectionCard(
                context,
                'посадка',
                [
                  _textField(_seatpostController, 'подседельный штырь',
                      action: TextInputAction.next),
                  _textField(_saddleController, 'седло',
                      action: TextInputAction.next),
                  _textField(_seatClampController, 'подседельный зажим',
                      action: TextInputAction.next),
                ],
              ),
              _sectionCard(
                context,
                'трансмиссия',
                [
                  _textField(_cranksetController, 'система (шатуны)',
                      action: TextInputAction.next),
                  Row(
                    children: [
                      Expanded(
                        child: _numberField(_chainringController, 'звезда',
                            action: TextInputAction.next),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _numberField(_cogController, 'задняя звезда',
                            action: TextInputAction.next),
                      ),
                    ],
                  ),
                  _textField(_bottomBracketController, 'каретка',
                      action: TextInputAction.next),
                  _textField(_chainController, 'цепь',
                      action: TextInputAction.next),
                  _textField(_lokringController, 'локринг',
                      action: TextInputAction.next),
                ],
              ),
              _sectionCard(
                context,
                'колёса',
                [
                  _textField(_hubsController, 'втулки',
                      action: TextInputAction.next),
                  _textField(_rimsController, 'обода',
                      action: TextInputAction.next),
                  _textField(_spokesController, 'спицы',
                      action: TextInputAction.next),
                  _textField(_nipplesController, 'ниппели',
                      action: TextInputAction.next),
                ],
              ),
              _sectionCard(
                context,
                'покрышки',
                [
                  _textField(_tiresController, 'покрышки',
                      action: TextInputAction.next),
                ],
              ),
              _sectionCard(
                context,
                'педали',
                [
                  _textField(_pedalsController, 'педали',
                      action: TextInputAction.next),
                  _textField(_strapsController, 'стрепы / туклипы',
                      action: TextInputAction.next),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('добавить сэтап'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    bool required = false,
    int maxLines = 1,
    TextInputAction action = TextInputAction.next,
    bool capitalize = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        textInputAction: action,
        textCapitalization:
            capitalize ? TextCapitalization.sentences : TextCapitalization.none,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'обязательно';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _numberField(TextEditingController controller, String label,
      {TextInputAction action = TextInputAction.next}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textInputAction: action,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.05),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          final number = int.tryParse(value ?? '');
          if (number == null || number <= 0) return 'неверно';
          return null;
        },
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      Bike(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        ownerName: _ownerController.text.trim(),
        bikeName: _nameController.text.trim(),
        imageUrl: _imageController.text.trim(),
        frameSize: [
          _frameController.text.trim(),
          _forkController.text.trim(),
          _headsetController.text.trim(),
        ].where((value) => value.isNotEmpty).join('\n'),
        chainring: _chainringController.text.trim().isEmpty
            ? 0
            : int.parse(_chainringController.text),
        cog: _cogController.text.trim().isEmpty
            ? 0
            : int.parse(_cogController.text),
        wheelset: [
          _hubsController.text.trim(),
          _rimsController.text.trim(),
          _spokesController.text.trim(),
          _nipplesController.text.trim(),
        ].where((value) => value.isNotEmpty).join('\n'),
        cockpit: [
          _handlebarController.text.trim(),
          _stemController.text.trim(),
          _gripsController.text.trim(),
        ].where((value) => value.isNotEmpty).join('\n'),
        drivetrain: [
          _cranksetController.text.trim(),
          _bottomBracketController.text.trim(),
          _chainController.text.trim(),
          _lokringController.text.trim(),
        ].where((value) => value.isNotEmpty).join('\n'),
        seating: [
          _seatpostController.text.trim(),
          _saddleController.text.trim(),
          _seatClampController.text.trim(),
        ].where((value) => value.isNotEmpty).join('\n'),
        extras: [
          _tiresController.text.trim(),
          _pedalsController.text.trim(),
          _strapsController.text.trim(),
        ].where((value) => value.isNotEmpty).join('\n'),
      ),
    );
  }
}
