import 'package:flutter/material.dart';
import 'package:flutter_assignment/features/home/models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Color(0xFFF0EFEF),
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          user.name,
          style: TextStyle(fontSize: width * 0.05, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem(
                width: width,
                title: 'Name',
                value: user.name,
                icon: Icons.person,
              ),
              _buildDetailItem(
                width: width,
                title: 'Email',
                value: user.email,
                icon: Icons.email,
              ),
              _buildDetailItem(
                width: width,
                title: 'Phone',
                value: user.phone,
                icon: Icons.phone,
              ),
              _buildDetailItem(
                width: width,
                title: 'Website',
                value: user.website,
                icon: Icons.web,
              ),
              _buildDetailItem(
                width: width,
                title: 'Address',
                value: user.address.fullAddress,
                icon: Icons.location_on,
              ),
              Divider(height: width * 0.08),
              _buildDetailItem(
                width: width,
                title: 'Company',
                value: user.company.name,
                icon: Icons.business,
              ),
              _buildDetailItem(
                width: width,
                title: 'Catchphrase',
                value: user.company.catchPhrase,
                icon: Icons.message,
              ),
              _buildDetailItem(
                width: width,
                title: 'BS',
                value: user.company.bs,
                icon: Icons.work_outline,
              ),
              SizedBox(height: width * 0.06),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required double width,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: width * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.indigoAccent, size: width * 0.06),
          SizedBox(width: width * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: width * 0.035, color: Colors.grey),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
