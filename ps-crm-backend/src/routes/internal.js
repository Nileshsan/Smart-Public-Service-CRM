const express  = require('express');
const router   = express.Router();
const crypto   = require('crypto');
const Complaint = require('../models/Complaint');

// Internal route — no auth, only for voice service / phone channel
// POST /api/internal/complaint
router.post('/complaint', async (req, res) => {
  try {
    const { name, phone, ward, locality, category, description, urgency } = req.body;

    // Map voice category to schema enum
    const categoryMap = {
      'roads': 'Roads', 'road': 'Roads',
      'water supply': 'Water', 'water': 'Water',
      'electricity': 'Electricity',
      'sanitation': 'Sanitation',
      'parks': 'Other', 'park': 'Other',
      'other': 'Other'
    };
    const mappedCategory = categoryMap[(category || '').toLowerCase()] || 'Other';
    const mappedUrgency  = ['Low','Medium','High'].includes(urgency) ? urgency : 'Medium';

    // Check for open duplicate
    const duplicate = await Complaint.findOpenDuplicate(ward, locality, mappedCategory);

    if (duplicate) {
      // Add this caller as a new filer on the existing complaint
      duplicate.filers.push({
        citizen: { name: name || 'Phone Caller', email: `${phone}@phone.caller`, phone },
        description,
      });
      await duplicate.save();
      return res.json({
        success: true,
        duplicate: true,
        complaintNumber: duplicate.complaintNumber,
        message: `Merged with existing complaint ${duplicate.complaintNumber}`
      });
    }

    // New complaint
    const duplicateKey = Complaint.buildDuplicateKey(ward, locality, mappedCategory);
    const complaint = new Complaint({
      title:    `${mappedCategory} issue at ${locality}, ${ward}`,
      category: mappedCategory,
      urgency:  mappedUrgency,
      location: { ward, locality, address: `${locality}, ${ward}` },
      duplicateKey,
      filers: [{
        citizen: { name: name || 'Phone Caller', email: `${phone}@phone.caller`, phone },
        description,
      }],
    });

    await complaint.save();
    res.json({
      success: true,
      duplicate: false,
      complaintNumber: complaint.complaintNumber,
      id: complaint._id
    });

  } catch (err) {
    console.error('[internal] complaint error:', err.message);
    res.status(500).json({ success: false, error: err.message });
  }
});

module.exports = router;