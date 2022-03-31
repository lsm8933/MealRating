//
//  RatingControl.swift
//  MealRating
//
//  Created by Jing Li on 7/12/21.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: Properties
    private var starButtons: [UIButton] = []
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setUpButtons()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setUpButtons()
        }
    }
    
    var rating: Int = 0 {
        didSet {
            updateButtonSelections()
        }
    }

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
    // MARK: - Private Methods
    /// programmatically create buttons with images for different states, add constraints, and update the selected number of buttons,
    private func setUpButtons() {
        // First remove existing buttons from RatingControl stack view and starbuttons array
        for button in starButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        starButtons.removeAll()
        
        // Button Images: images credit to https://icons8.com
        let bundle = Bundle(for: type(of: self))
        let starEmpty = UIImage(named: "starEmpty", in: bundle, compatibleWith: self.traitCollection)
        let starHighlighted = UIImage(named: "starHighlighted", in: bundle, compatibleWith: self.traitCollection)
        let starSelected = UIImage(named: "starSelected", in: bundle, compatibleWith: self.traitCollection)
        
        // Add Star Buttons to the RatingControl stack view
        for index in 0..<starCount {
            let starButton = UIButton()
            
            // Setup button images
            //starButton.backgroundColor = UIColor.blue
            starButton.setImage(starEmpty, for: .normal)
            starButton.setImage(starHighlighted, for: .highlighted)
            starButton.setImage(starSelected, for: .selected)
            starButton.setImage(starHighlighted, for: [.selected, .highlighted])
            
            // Stackview add subview
            addArrangedSubview(starButton)
            
            // Programmatically set up auto layout
            starButton.translatesAutoresizingMaskIntoConstraints = false
            starButton.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            starButton.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // Accessibility
            starButton.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Add target to action, alternative to IBAction
            starButton.addTarget(self, action: #selector(RatingControl.starButtonClicked(button:)), for: .touchUpInside)
            
            // Add to button array
            starButtons.append(starButton)
        }
        updateButtonSelections()
    }
    
    /// update the number of selected starButtons to match user rating.
    private func updateButtonSelections() {
        
        for (index, button) in starButtons.enumerated() {
            button.isSelected = (index + 1 <= rating)
            
            // Accessibility
            if index + 1 == rating {
                button.accessibilityHint = "Tap this, and rating will be reset to zero"
            }
            button.accessibilityValue = "\(rating) stars rating has been set."
        }
    }
    
    // MARK: - Star Button Actions
    /// update rating based on which button was pressed: if the current rating button was pressed, rating will be reset to 0; else rating will be set to (index of the button) + 1
    @objc func starButtonClicked(button: UIButton) {
        guard let index = starButtons.firstIndex(of: button) else {
            fatalError("\(button) does not exist in starButtons.")
        }
        
        if index + 1 == rating {
            rating = 0
        } else {
            rating = index + 1
        }
    }

}
