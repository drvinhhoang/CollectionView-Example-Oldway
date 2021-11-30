//
//  DataSource.swift
//  EmojiLibrary
//
//  Created by VINH HOANG on 30/11/2021.
//

import UIKit

class DataSource: NSObject, UICollectionViewDataSource {
   
    let emojis = Emoji.shared
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return emojis.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let section = emojis.sections[section]
        let emojis = emojis.data[section]
        
        return emojis?.count ?? 0
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else {
            fatalError("Can not create cell!")
        }
        
        let category = emojis.sections[indexPath.section]
      let item = emojis.data[category]?[indexPath.item]  ?? ""
        
        cell.emojiLabel.text = item
        return  cell
    }
    
    
    //MARK: - Create header view for section
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let emojiHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiHeaderView.reuseIdentifier, for: indexPath) as? EmojiHeaderView else {
            fatalError("Cannot create EmojiHeaderView")
        }
        
        let category = emojis.sections[indexPath.section]
        
        emojiHeaderView.textLabel.text = category.rawValue
        
        return emojiHeaderView
    }
    
}


extension DataSource {
    func addEmoji(_ emoji: String, to category: Emoji.Category) {
        guard var emojiData = self.emojis.data[category] else { return }
        emojiData.append(emoji)
        self.emojis.data.updateValue(emojiData, forKey: category)
        
    }
}
