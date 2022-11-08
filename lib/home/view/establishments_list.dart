import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mikhuy/home/cubit/google_maps_cubit.dart';
import 'package:mikhuy/shared/enums/request_status.dart';
import 'package:mikhuy/theme/theme.dart';
import 'package:models/establishment.dart';

class EstablishmentsList extends StatelessWidget {
  const EstablishmentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleMapsCubit, GoogleMapsState>(
      builder: (context, state) {
        if (state.requestStatus == RequestStatus.completed) {
          return const _EstablishmentsListView();
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _EstablishmentsListView extends StatelessWidget {
  const _EstablishmentsListView();

  @override
  Widget build(BuildContext context) {
    final establishments = context.select<GoogleMapsCubit, List<Establishment>>(
      (value) => value.state.establishments,
    );

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => context.read<GoogleMapsCubit>().getEstablisments(),
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
          itemCount: establishments.length,
          itemBuilder: (context, index) => EstablishmentListItem(
            establishments[index],
          ),
        ),
      ),
    );
  }
}

class EstablishmentListItem extends StatelessWidget {
  const EstablishmentListItem(Establishment establishment, {super.key})
      : _establishment = establishment;

  final Establishment _establishment;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final openingTime = DateTime(
      now.year,
      now.month,
      now.day,
      _establishment.openingTime.hour,
      _establishment.openingTime.minute,
    );

    final closingTime = DateTime(
      now.year,
      now.month,
      now.day,
      _establishment.closingTime.hour,
      _establishment.closingTime.minute,
    );

    final isOpen = now.isAfter(openingTime) && now.isBefore(closingTime);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _establishment.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: 4),
          Text(
            _establishment.address,
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isOpen ? 'Abierto ahora' : 'Cerrado',
                style: Theme.of(context).textTheme.overline!.copyWith(
                      color: isOpen ? AppColors.success : AppColors.danger,
                    ),
              ),
              const Text('35 productos disponibles'),
            ],
          ),
        ],
      ),
    );
  }
}