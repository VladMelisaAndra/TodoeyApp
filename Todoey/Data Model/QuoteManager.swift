import Foundation

//By convention, Swift protocols are usually written in the file that has the class/struct which will call the delegate methods, i.e. the CoinManager.
protocol QuoteManagerDelegate {
    //Create the method stubs wihtout implementation in the protocol
    func didUpdateQuote(quoteText: String)
    func didFailWithError(error: Error)
}

struct QuoteManager {
    //Create an optional delegate that will have to implement the delegate methods. Which we can notify when we have updated the price.
    var delegate: QuoteManagerDelegate?
    
    let urlString = "https://zenquotes.io/api/today"
    
    func getQuote() {
        //Use optional binding to unwrap the URL
        if let url = URL(string: urlString) {
            
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            //Create a new data task for the URLSession
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let quoteText = self.parseJSON(safeData) {
                        //Call the delegate method in the delegate (ViewController) and
                        //pass along the necessary data.
                        print("Am luat quote-ul: \(quoteText)")
                        self.delegate?.didUpdateQuote(quoteText: quoteText)
                    }
                }
            }
            task.resume()
        }
    }
        
    
    func parseJSON(_ data: Data) -> String? {
        do {
            // try to decode the data using the QuoteData structure
            let decodedData = try JSONDecoder().decode([QuoteData].self, from: data)
            return decodedData.first!.q
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

