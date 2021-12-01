

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let dataSource = DataSource()
    let delegate = EmojiCollectionViewDelegate(numberOfItemsPerRow: 6, interItemSpacing: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.allowsMultipleSelection = true
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        deleteButton.isEnabled = isEditing
        addButton.isEnabled = !isEditing
        
        collectionView.indexPathsForVisibleItems.forEach {
            guard let emojiCell = collectionView.cellForItem(at: $0) as? EmojiCell else { return }
            emojiCell.isEditing = editing
        }
        
        if !isEditing {
            collectionView.indexPathsForSelectedItems?.compactMap({ $0 }).forEach {
                collectionView.deselectItem(at: $0, animated: true)
            }
        }
        
    }
    
    @IBAction func addEmoji(_ sender: UIBarButtonItem) {
        let (category, randomEmoji) = Emoji.randomEmoji()
        dataSource.addEmoji(randomEmoji, to: category)
        
        let emojiCount = collectionView.numberOfItems(inSection: 0)
        let insertedIndex = IndexPath(item: emojiCount, section: 0)
        
        collectionView.insertItems(at: [insertedIndex])
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if isEditing && identifier == "showEmojiDetail" {
            return false
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showEmojiDetail",
              let emojiCell = sender as? EmojiCell,
              let emojiDetailController = segue.destination as? EmojiDetailController,
              let indexPath = collectionView.indexPath(for: emojiCell),
              let emoji = Emoji.shared.emoji(at: indexPath)
        else {
            fatalError()
        }
        
        emojiDetailController.emoji = emoji
        
    }
    
    
    @IBAction func deleteEmoji(_ sender: Any) {
        guard let selectedIndices = collectionView.indexPathsForSelectedItems else { return }
        let sectionsToDelete = Set(selectedIndices.map({ $0.section}))
        
        sectionsToDelete.forEach { section in
            let indexPathsForSection = selectedIndices.filter { $0.section == section }
            let sortedIndexPaths = indexPathsForSection.sorted(by: { $0.item > $1.item })
            
            dataSource.deleteEmoji(at: sortedIndexPaths)
            collectionView.deleteItems(at: sortedIndexPaths)
        }
        
    }
}

