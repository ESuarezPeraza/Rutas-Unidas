import 'package:flutter/material.dart';
import 'package:myapp/widgets/experience_bar.dart';
import 'package:myapp/widgets/profile_header.dart';
import 'package:myapp/widgets/trip_history.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text(
          'Perfil',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: const [
              ProfileHeader(
                avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBRuJtAXl-pMkSPS6-E6bPS39UzT2QN_feFuNBroYh67HJuTvU7qUmSqifsW2TTJM07stMNqoMnX8L5HOVbKCAOSRlAGLuuXc1JWPIj1iI_DUE0kuNC4WRhsXh4FVsmG_sv4Tjxflla7YWYLr_asKSIWdbzexqFf7Em2YF8crnXPLz9aO8soVmGYluk_38RFcsU3olNJ7cc0dygrIRAnbIl8lS3l4MIOl3_CXJwdoYhOFbx85nZQ_KlrpS5j_u8E-1jx3R9fJpnv7Ma',
                name: 'Ricardo Mendoza',
                role: 'Organizador',
                memberSince: 'Miembro desde 2022',
              ),
              SizedBox(height: 32),
              ExperienceBar(
                label: 'Nivel de Experiencia',
                valueLabel: '75/100',
                progress: 0.75,
              ),
              SizedBox(height: 32),
              TripHistory(
                title: 'Viajes',
                tabs: ['Pasados', 'Futuros'],
                activeTab: 0,
                trips: [
                  {
                    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCe3zkSW7gzrW60tsid4uuP5n_BLt0f7SQd8InqLIMjgbTjDLutDvlKEbE17uL276a5M7wNijJayXaaDVoOIj7HC5hg6Ye0haW68OhPP2VESUKI_JQ-0ag9_g6uFtNfVXH95OWVuHIFiIwM-mLXlTrAte64hDx8e9ZaZCWPZWbegNZFq6h8hkF6VLqqcjJXFmmHcyU18BGOJqWNgDt_TK3Iz8ww9wXizZ0_YQWsqkvmU1NU9hBexokisbP8n2KozYUiF5izyA88y7XN',
                    'title': 'Ruta de los Andes',
                    'subtitle': '20 de Mayo, 2023',
                  },
                  {
                    'imageUrl': 'https://lh3.googleusercontent.com/aida-public/AB6AXuC2EJnSbntMHuuuDZ1QVZG1q3RZIQbssTtzNsWPgpZuCtn_UjiVseCBciHgOGWNNiObaGjsN8IJ-SptitWPeCeaNt669Nsq1Owe9t7VxWxGM2gn9mKwxvUAxO-08OutVIiDIMx0enrrcp7G_1q9jxZkRaMGkgew4bNhKW6hMXJQcNYNgo_31SBFE7q7HQ8D3T-HE6AxQtcQ7A8NSYTwp4CVW1ohhmrt4u87N6qye-cKh0rwXRXX28nQDvvmN6v5KFAKOBjGWV9mrLJG',
                    'title': 'Carretera del Sur',
                    'subtitle': '15 de Marzo, 2023',
                  }
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
