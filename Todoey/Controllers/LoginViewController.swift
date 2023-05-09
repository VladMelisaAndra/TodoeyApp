import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var attentionMessageLabel: UILabel!
    
    let defaults = UserDefaults.standard // an interface to the user's defaults db where you store key-value pairs persistently accross launches of your app
    var userLoggedIn: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self // the text field should report back to our view controller
        passwordTextField.delegate = self // the text field should report back to our view controller
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        usernameTextField.endEditing(true) // we are done editing and you can dismiss the keyboard
        passwordTextField.endEditing(true) // we are done editing and you can dismiss the keyboard
        if(passwordTextField.text != "" && usernameTextField.text != "") {
            if(passwordTextField.text! == defaults.string(forKey: usernameTextField.text!)) {
                userLoggedIn = usernameTextField.text!
                self.performSegue(withIdentifier: "fromLoginGoToTodoList", sender: self)
            } else {
                attentionMessageLabel.text = "Username/password combination is wrong!"
            }
        } else {
            attentionMessageLabel.text = "Username and password can't be blank!"
        }
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "fromLoginGoToRegister", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // the text field will notify the controller that the user pressed the return key in the keyboard
        textField.endEditing(true) // we are done editing and you can dismiss the keyboard
        return true // the text field will be allowed to actually return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromLoginGoToTodoList" {
            let nav = segue.destination as! UINavigationController // the view controller that will be initialized when the segue gets triggered
            let svc = nav.topViewController as! TodoListViewController
            svc.userLoggedIn = userLoggedIn
        }
    }
}
