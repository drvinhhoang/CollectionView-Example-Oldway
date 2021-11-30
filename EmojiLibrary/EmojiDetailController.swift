

import UIKit

class EmojiDetailController: UIViewController {
  
  var emoji: String? {
    didSet {
      if let label = textLabel {
        label.text = emoji
      }
    }
  }
  
  @IBOutlet weak var textLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textLabel.text = emoji
  }
}
