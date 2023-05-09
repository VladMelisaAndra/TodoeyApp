import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var attentionMessageLabel: UILabel!
    
     let defaults = UserDefaults.standard // an interface to the user's defaults db where you store key-value pairs persistently accross launches of your app
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self // the text field should report back to our view controller
        passwordTextField.delegate = self // the text field should report back to our view controller
        passwordTextField.textContentType = .oneTimeCode
        usernameTextField.textContentType = .oneTimeCode
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        usernameTextField.endEditing(true) // we are done editing and you can dismiss the keyboard
        passwordTextField.endEditing(true) // we are done editing and you can dismiss the keyboard
        if(passwordTextField.text != "" && usernameTextField.text != "") {
            if(defaults.string(forKey: usernameTextField.text!) != nil) {
                attentionMessageLabel.text = "A user with this username already exists."
            } else {
                attentionMessageLabel.text = ""
                self.defaults.set(passwordTextField.text, forKey: usernameTextField.text!)
                self.performSegue(withIdentifier: "fromRegisterGoToLogin", sender: self)
            }
        } else {
            attentionMessageLabel.text = "Username and password can't be blank!"
        }
        
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromRegisterGoToLogin", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // the text field will notify the controller that the user pressed the return key in the keyboard
        textField.endEditing(true) // we are done editing and you can dismiss the keyboard
        return true // the text field will be allowed to actually return
    }
    
}
