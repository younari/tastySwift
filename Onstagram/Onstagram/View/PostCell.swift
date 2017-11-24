//
//  PostCell.swift
//  Onstagram
//
//  Created by 김기윤 on 22/11/2017.
//  Copyright © 2017 yunari.me. All rights reserved.
//

import UIKit

protocol CommentCellDelegate {
    func postCellDidSelectedCommentBtn(_ data: PostModel)
}

class PostCell: UITableViewCell {
    
    // cellFromNib
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var contentsTextView: UITextView!

    var delegate: CommentCellDelegate?
    
    @IBAction func didTapCommentBtn(_ sender: UIButton) {
        guard let postData = self.postData else { return }
        delegate?.postCellDidSelectedCommentBtn(postData)
    }

    var postData: PostModel? {
        didSet {
            self.contentsTextView.text = postData?.contents
            
            // Image from URL
            if let url = postData?.imgUrl {
                self.postImageView.loadImage(URLstring: url, completion: { (isSuccess) in
                    if !isSuccess {
                        self.postImageView.image = #imageLiteral(resourceName: "NoImage")
                    }
                })
            }
            
            // Image from library
            if let image = postData?.image {
                self.postImageView.image = image
            }
            
        }
    }
    
    // Estimated Cell Size 만들 때 필요
    static var cellFromNib: PostCell {
        guard let cell = Bundle.main.loadNibNamed("PostCell", owner: nil, options: nil)?.first as? PostCell else {
            return PostCell()
        }
        return cell
    }
    
    
}