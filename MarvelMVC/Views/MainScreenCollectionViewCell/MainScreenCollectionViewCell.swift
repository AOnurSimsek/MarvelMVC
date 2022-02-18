//
//  MainScreenCollectionViewCell.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 17.02.2022.
//

import UIKit
import SDWebImage

class MainScreenCollectionViewCell: UICollectionViewCell {

    static let identifier : String = "MainScreenCollectionViewCellIdentifier"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var delegate : cellFavoriteButtonProtocol?
    var indexPath : IndexPath?
    
    var isFavorite : Bool? {
        didSet {
            guard let favState = isFavorite
            else {
                return
            }
            
            if favState {
                favoriteImageView.image = UIImage(named: "favorite_highlighted")
            }
            else {
                favoriteImageView.image = UIImage(named: "favorite_normal")
            }
        }
    }
    
    var model : CharactersResultModel? {
        didSet {
            guard let unwrappedModel = model
            else {
                return
            }
            
            imageView.sd_setImage(with: unwrappedModel.thumbnail?.getImageURL()) { _image, _error, _, _ in
                    guard let averageColor = _image?.averageColor
                    else {
                        return
                    }
                        self.mainView.layer.borderColor = averageColor.cgColor
                        self.mainView.makeShadow(color: averageColor, offset: CGSize(width: 0, height: 0), opacity: 0.5, radius: 4)
            }
            
            nameLabel.text = unwrappedModel.name.unwrapString()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        createGesture()
    }
    
    func setUI(){
        self.contentView.clipsToBounds = false
        
        mainView.layer.borderWidth = 3
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        
        favoriteImageView.tintColor  = .marvelLogoRed
        favoriteImageView.layer.zPosition = 1
        favoriteImageView.makeShadow(color: .marvelLogoRed, offset: .zero, opacity: 0.5, radius: 5)
        
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    }
    
    func createGesture(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonPresseed))
        favoriteImageView.addGestureRecognizer(gesture)
        favoriteImageView.isUserInteractionEnabled = true
    }
    
    @objc func favoriteButtonPresseed(){
        delegate?.buttonPressed(id: model?.id, isFavorite: self.isFavorite, index: indexPath)
    }
    
}
