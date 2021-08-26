//
//  MealDetailViewController.swift
//  MealRating
//
//  Created by Jing Li on 3/31/21.
//

import UIKit

class MealDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // MARK: Properties
    // new meal to add when saveButton is tapped.
    var meal: Meal?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var chooseImageView: UIImageView!
    // after setting ratingControl in storyboard identity inspector, connect the outlet reference to the controller
    @IBOutlet weak var ratingControl: RatingControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // set up delegate to respond to textfield inputs
        nameTextField.delegate = self
        // TODO: naneTextfield.text is empty: should popup alert when saving
        //to solve cursor always flashing
        //nameTextField.tintColor = UIColor.clear
        //updateSaveButtonStatus()
        
        if let meal = self.meal {
            nameTextField.text = meal.name
            chooseImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // does nothing in this case, but good practice to call super method in case for subclassing other view controller classes
        super.prepare(for: segue, sender: sender)
        
        if let barButton = sender as? UIBarButtonItem, barButton === saveButton {
            // name of meal cannot be nil, which is text of textfield could be (String?)
            let mealName = nameTextField.text ?? ""
            let mealImage = chooseImageView.image
            let mealRating = ratingControl.rating
            
            meal = Meal(name: mealName, photo: mealImage, rating: mealRating)
        }
    }
    
    // MARK: IBAction for Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController { // If presented modally (adding a new meal), even if detail scene would still be embeded in a navigation controller in this case.
            dismiss(animated: true, completion: nil)
        } else if navigationController != nil { // If only pushed on navigation stack without under modal operations
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("expecting UIImage but having \(info)")
        }
        
        chooseImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //updateSaveButtonStatus()
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //updateSaveButtonStatus()
        //navigationItem.title = textField.text
//        nameLabel.text = textField.text
//        // Apple code bug fix
//        textField.text = ""
    }
    
    // MARK: Private methods
    private func updateSaveButtonStatus() {
        saveButton.isEnabled = !(nameTextField.text?.isEmpty ?? true)
    }
}

