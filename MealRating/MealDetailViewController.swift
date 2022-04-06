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

    @IBOutlet weak var ratingControl: RatingControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        // set up delegate to respond to textfield inputs
        nameTextField.delegate = self
        // TODO: nameTextfield.text is empty: should popup alert when saving
        //to solve cursor always flashing
        //nameTextField.tintColor = UIColor.clear
        //updateSaveButtonStatus()
        
        if let meal = self.meal {
            nameTextField.text = meal.name
            if let imageData = meal.imageData {
                chooseImageView.image = UIImage(data: imageData)
            }
            ratingControl.rating = meal.rating
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let barButton = sender as? UIBarButtonItem, barButton === saveButton {
            
            let mealName = nameTextField.text ?? ""
            let mealImage = chooseImageView.image
            let mealRating = ratingControl.rating
            
            if meal != nil { // update meal
                meal?.name = mealName
                meal?.rating = mealRating
                meal?.imageData = mealImage?.jpegData(compressionQuality: 1)
            } else { // insert new meal
                meal = Meal(id: nil, name: mealName, rating: mealRating, imageData: mealImage?.jpegData(compressionQuality: 1))
            }
        }
    }
    
    // MARK: - IBAction for Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // If presented modally (adding a new meal), even if detail scene would still be embeded in a navigation controller in this case.
        if presentingViewController is UINavigationController {
            dismiss(animated: true, completion: nil)
        // If only pushed on navigation stack without under modal operations
        } else if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
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
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //updateSaveButtonStatus()
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Private methods
    private func updateSaveButtonStatus() {
        saveButton.isEnabled = !(nameTextField.text?.isEmpty ?? true)
    }
}

