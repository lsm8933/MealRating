//
//  MealDetailViewController.swift
//  MealRating
//
//  Created by Jing Li on 3/31/21.
//

import UIKit

class MealDetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // MARK: Properties
    var meal: Meal?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var chooseImageView: UIImageView!

    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInputFields()
        setupKeyboardDismiss()
    }

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // meal name is required.
        guard let nameText = nameTextField.text, nameText != "" else {
    
            let emptyNameAlertController = UIAlertController(title: "Enter Name", message: "Please enter a name for your meal.", preferredStyle: .alert)
            emptyNameAlertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
            self.present(emptyNameAlertController, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let barButton = sender as? UIBarButtonItem, barButton === saveButton, let mealName = nameTextField.text {
            
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
    @objc func tapDismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
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
    // dismiss keyboard with return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Private methods
    fileprivate func setupInputFields() {
        guard let meal = meal else {
            return
        }
        
        nameTextField.text = meal.name
        if let imageData = meal.imageData {
            chooseImageView.image = UIImage(data: imageData)
        }
        ratingControl.rating = meal.rating
    }
    
    fileprivate func setupKeyboardDismiss() {
        // dismiss keyboard when user finishes textfield editing.
        nameTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDismissKeyboard(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
}

