//
//  DetailScreenViewController.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 16.02.2022.
//

import UIKit

class DetailScreenViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var comicsLabel: UILabel!
    @IBOutlet weak var comicsCollectionView: UICollectionView!
    
    var characterModel : CharactersResultModel?
    var isFavorite : Bool?
    var comics : [ComicResultModel] = []
    var reloadDelegate : ReloadProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDatas()
        setTargets()
        saveAnalytics()
        setCollectionView()
        fetchData()
    }
    
    func setUI(){
        backButton.setTitle("", for: .normal)
        characterImageView.contentMode = .scaleToFill
        
        nameLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .lightGray
        
        checkFavoriteState()
    }
    
    func fetchData(){
        LoadingView.shared.startLoadingView(vc: self)
        WebService.getComicsForCharacter(characterId: (characterModel?.id ?? 0)) { response in
            if let unwrappedResult = response?.data?.result {
                self.comics = unwrappedResult
                self.comicsCollectionView.reloadData()
                LoadingView.shared.stopLoadingView()
            }
            else {
                LoadingView.shared.stopLoadingView()
                self.showAlert("Unknow error occured.")
            }
        } fail: { error in
            LoadingView.shared.stopLoadingView()
            self.showAlert(error.unwrapError())
        }
    }
    
    func checkFavoriteState(){
        if let favState = isFavorite {
            if favState {
                favoriteImageView.image = UIImage(named: "favorite_highlighted")
            }
            else {
                favoriteImageView.image = UIImage(named: "favorite_normal")
            }
        }
    }
    
    func setDatas(){
        characterImageView.sd_setImage(with: characterModel?.thumbnail?.getImageURL()) { _image, _error, _, _ in
            if let averageColor = _image?.averageColor {
                self.nameLabel.textColor = averageColor
            }
            else {
                self.nameLabel.textColor = .marvelLogoRed
            }
        }
        nameLabel.text = characterModel?.name.unwrapString()
        descriptionLabel.text = characterModel?.description.unwrapString()
        comicsLabel.attributedText = "Comics".createAttributedText(stringTwo: "( Newest )")
    }
    
    func setTargets(){
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonPressed))
        favoriteImageView.addGestureRecognizer(gesture)
        favoriteImageView.isUserInteractionEnabled = true
    }
    
//MARK: - Selectors
    
    @objc func favoriteButtonPressed(){
        if let favState = isFavorite, let idValue = characterModel?.id, let model = characterModel {
            if favState {
                CoreData.deleteSavedCharacter(characterId: idValue)
                isFavorite = false
            }
            else {
                CoreData.saveCharacter(character: model)
                isFavorite = true
            }
        }
        
        checkFavoriteState()
    }
    
    @objc func backButtonPressed(){
        reloadDelegate?.reloadCollectionView()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveAnalytics(){
        if let id = characterModel?.id {
            WebService.saveAnalytics(characterId: id)
        }
    }

}

//MARK: - CollectionView
extension DetailScreenViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    func setCollectionView(){
        comicsCollectionView.delegate = self
        comicsCollectionView.dataSource = self
        comicsCollectionView.showsHorizontalScrollIndicator = false
        comicsCollectionView.register(ComicsCollectionViewCell.self, forCellWithReuseIdentifier: ComicsCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 160)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicsCollectionViewCell.identifier, for: indexPath) as! ComicsCollectionViewCell
        cell.thumbnail = comics[indexPath.row].thumbnail
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 200, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0.5
            
            UIView.animate(withDuration: 0.5) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }

}


