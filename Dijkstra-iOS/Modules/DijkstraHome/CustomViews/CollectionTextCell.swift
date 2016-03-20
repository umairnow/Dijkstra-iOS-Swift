//
//  CollectionTextCell.swift
//  InterviewTest
//
//  Created by Umair Aamir on 3/15/16.
//  Copyright © 2016 MyWorkout AS. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class CollectionTextCell: UICollectionViewCell, UITextViewDelegate {
    
    @IBOutlet weak var lblNotifying: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var textDidChanged: (newText: String) -> Void = {_ in}
    var textViewEmpty: () -> Void = {}
    var sliderValueDidChange: (newValue: Int) -> Void = {_ in}
    
    private let toolbarHeight: CGFloat = 50
    
    private lazy var toolbar: UIToolbar = {
       [unowned self] in
        let toolbar = UIToolbar()
        toolbar.bounds = CGRectMake(0, 0, utility.SCREEN_WIDTH, self.toolbarHeight)
        toolbar.sizeToFit()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "btnDoneActionHandler:")
        ]
        return toolbar
    }()
    
    @IBOutlet weak var textViewHeader: KMPlaceholderTextView!
    @IBOutlet weak var slideControlHeader: UISlider!
    
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        self.textViewHeader.inputAccessoryView = self.toolbar
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.characters.last == " " {
            self.textDidChanged(newText: textView.text.trimEndsSpacing())
        }
        if textView.text.trimEndsSpacing().isEmpty {
            self.textViewEmpty()
        }
    }
    
    // MARK: - Action Handler
    
    @IBAction func sliderValueChangeHandler(sender: UISlider) {
        self.sliderValueDidChange(newValue: Int(sender.value * 10))
    }
    
    @IBAction func btnDoneActionHandler(sender: UIButton) {
        self.textViewHeader.resignFirstResponder()
    }
    
    // MARK: - Helping Methods
    
    func hideNotifyingMessages(hide: Bool) -> Void {
        self.lblNotifying.hidden = hide
        self.activityIndicator.hidden = hide
    }
}
