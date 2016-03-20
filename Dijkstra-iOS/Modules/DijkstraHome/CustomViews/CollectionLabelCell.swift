//
//  CollectionLabelCell.swift
//  InterviewTest
//
//  Created by Umair Aamir on 3/15/16.
//  Copyright © 2016 MyWorkout AS. All rights reserved.
//

import UIKit

class CollectionLabelCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    let kLabelHorizontalInsets: CGFloat = 8.0
    
    // In layoutSubViews, need set preferredMaxLayoutWidth for multiple lines label
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set what preferredMaxLayoutWidth you want
        lblTitle.preferredMaxLayoutWidth = self.bounds.width - 2 * kLabelHorizontalInsets
    }
    
    func configCell(title: String) {
        lblTitle.text = title
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
