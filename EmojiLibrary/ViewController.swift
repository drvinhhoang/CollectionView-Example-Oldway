

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
        
        
        // If not in editing mode, for every indexpath of selected items. 
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
        // Get all indexpaths of seclected items
        guard let selectedIndices = collectionView.indexPathsForSelectedItems else { return }
        
        // Identify sections that have items get selected.
        let sectionsToDelete = Set(selectedIndices.map({ $0.section}))
        
        // For each section:
        sectionsToDelete.forEach { section in
            //1. loop through all selected indexpaths and filtered out those items in that section.
            let indexPathsForSection = selectedIndices.filter { $0.section == section }
            //2. sort indexpaths by compare values of items from high to low
            let sortedIndexPaths = indexPathsForSection.sorted(by: { $0.item > $1.item })
            
            // 3. Delete items at sortedIndexPaths (delete backward to prevent array out of range)
            dataSource.deleteEmoji(at: sortedIndexPaths)
            // 4. delete items in collectionView
            collectionView.deleteItems(at: sortedIndexPaths)
        }
        
    }
}

