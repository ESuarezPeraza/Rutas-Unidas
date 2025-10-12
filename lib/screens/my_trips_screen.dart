import 'package:flutter/material.dart';
import 'package:myapp/widgets/trip_section.dart';

class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'Mis Viajes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              const TripSection(
                title: 'Viajes Programados',
                items: [
                  {
                    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCxCu3i_M0mZfioxOYw1eH0FgcyTOstL5cy2PnLLtOVJRUcJV0JOVfi3zjkcepGxFZP3oGpTERRjg89jtDTIiBJbbK_AqP7hFb4uYVJN76NvjsY8o01Sl24HUcw22IWTpdWOavAHMQo1Qzoe6qT3BBjBFsjCd0pCT74AB5gu1Flu2LhgnmKymN9U-zt_LuM9IasqeMRM1Z2dkrjZooioAwztd4Xw1ZE2AJHSs48t_BAXGU4ueQp7FGfdfCVQUqCrHfJH9aWp0jQfbdR',
                    'title': 'Ruta de los Andes',
                    'subtitle': '15 de Julio, 2024',
                    'tag': {'label': 'Organizador', 'type': 'primary'}
                  },
                  {
                    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCPRKLM4Bgl8Zgl_XYUGQPcN4rQb3n8viDNqT_O7v9QsAqaCIBnzdDwILSMlfQpqaJFZOEf4_vzklNFUHUZpvKmJkLzOu5YvkT-SUC_-xpFA3HgEtuSRUxoQ-kH-LfIOhjjfjuf1fitOGXk5IYKNSKga7fc_2gAP_KN4SWJ_DGaOp0U1HK62WaKDLa0wjcv4pS99dCPlz-zZKAaVk1xFnVW071lSO6ul9z_jhp0kX6l9-h23-nD-inw17P_oircUubCt1RjpVfyD80a',
                    'title': 'Carretera del Sur',
                    'subtitle': '22 de Julio, 2024',
                    'tag': {'label': 'Participante', 'type': 'neutral'}
                  }
                ],
              ),
              const SizedBox(height: 32),
              Opacity(
                opacity: 0.7,
                child: const TripSection(
                  title: 'Viajes Realizados',
                  items: [
                    {
                      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDiKZ_dFvhC43qLpokoMKzzhAbGGbavqXhPxfTPoIeYG71m_DfRM6HX0VSGcDyqXhwCLRR095NiRp_F7xqhMS8urtxQijx2ey08xyN-a6I_HKflq-IFhRVoZRCRpGji9HzUxOHAqvKhcG76pUwkWVTMUk1LpsiLZB2rv3Y3b-3_laJBl5DyXH28ICJRG7E1b0geQbwoPbbSg881-GavNF2oqQNJ8UuJCzW_XO2-65Aci8JM28sFqO-oz5Hqz_PSC4pIHkBfPWuSfc4c',
                      'title': 'Costa Oriental',
                      'subtitle': '10 de Junio, 2024',
                      'tag': {'label': 'Participante', 'type': 'neutral'}
                    },
                    {
                      'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuArDJmYhrORWAA7ASPyGXEQlaXOtLJrbDpmsTvyQLuQxiFDQG2-QjO-VpO-PItiRIfBCWXdGN21EKz-R0DTJFB9n1sesYDtoMHSN_0dHsIoviyMsX5AJbRtSf3uFib47xidZJLlXxuHMH_fO9O2XpeY6ecfDg2C8tr7-URoNixTx1_J3KfR61YkkfCShx2687XL2qu7qJBMsxnwSdfV9qKipWV7d5dW2-7JJQLj3o8wNYI56cfUbPzaHxxrJC0_W08VWQ2PAW5sbcHG',
                      'title': 'Llanos Centrales',
                      'subtitle': '5 de Mayo, 2024',
                      'tag': {'label': 'Organizador', 'type': 'primary'}
                    }
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
