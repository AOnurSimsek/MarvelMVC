//
//  ComicsCollectionViewCell.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 18.02.2022.
//

import UIKit

class ComicsCollectionViewCell: UICollectionViewCell {
    
    static let identifier : String = "ComicsCollectionViewCellIdentifier"
    
    var thumbnail : ThumbnailModel? {
        didSet {
            guard let thumb = thumbnail
            else {
                return
            }
            imageView.sd_setImage(with: thumb.getImageURL() , completed: nil)
        }
    }
        
    let imageView : UIImageView = {
       let x = UIImageView()
        x.contentMode = .scaleToFill
       return x
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
        layer.masksToBounds = true
                        
        imageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        
        contentView.addSubview(imageView)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
