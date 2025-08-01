import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  final String patientName;
  final String phoneNumber;
  final String score;
  final VoidCallback onTap;
  final VoidCallback onEditTap;

  const ProfileCard({
    super.key,
    required this.patientName,
    required this.phoneNumber,
    required this.score,
    required this.onTap,
    required this.onEditTap,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 24 : 16,
        vertical: 8,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 32,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.patientName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.phoneNumber,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getScoreColor(widget.score),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.score,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isLargeScreen) ...[
                const SizedBox(width: 16),
                IconButton(
                  onPressed: widget.onEditTap,
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.grey.shade600,
                  ),
                  tooltip: 'Edit Patient',
                ),
                IconButton(
                  onPressed: widget.onTap,
                  icon: Icon(
                    Icons.visibility_outlined,
                    color: Colors.blue.shade700,
                  ),
                  tooltip: 'View Details',
                ),
              ] else ...[
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.grey.shade600,
                  ),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: widget.onEditTap,
                      child: const Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: widget.onTap,
                      child: const Row(
                        children: [
                          Icon(Icons.visibility_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('View'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(String score) {
    if (score == 'High') return Colors.red.shade600;
    if (score == 'Moderate') return Colors.orange.shade600;
    return Colors.green.shade600;
  }
}