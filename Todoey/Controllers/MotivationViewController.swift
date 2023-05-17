import Foundation
import UIKit

class MotivationViewController: UIViewController {
    
    @IBOutlet weak var quoteTextLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    var quoteManager = QuoteManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quoteTextLabel.contentMode = .scaleToFill
        quoteTextLabel.numberOfLines = 0
        quoteManager.delegate = self
        quoteManager.getQuote()

    }
    
    @IBAction func shareButtonClicked(_ sender: UIButton) {
            let quoteText = quoteTextLabel.text ?? ""
            let shareActivity = UIActivityViewController(activityItems: [quoteText], applicationActivities: nil)
            present(shareActivity, animated: true, completion: nil)
        }
    
}

//MARK: - QuoteManagerDelegate
                          // added protocol
extension MotivationViewController: QuoteManagerDelegate {
    //When the quoteManager gets the quoteText it will call this method and pass it over

    func didUpdateQuote(quoteText: String) {
        //we need to get hold of the main thread to update the UI, otherwise our app will crash if we
        //try to do this from a background thread (URLSession works in the background).
        print("1")
        print(quoteText)
        DispatchQueue.main.async {
            print("2")
            print(quoteText)
            self.quoteTextLabel.text = quoteText
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


