//
//  FavoriteScreenViewController.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 16.02.2022.
//

import UIKit

class FavoriteScreenViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    
    var characterResults : [CharactersResultModel] = CoreData.getSavedCharacters() {
        didSet {
            collectionView.reloadData()
        }
    }
    var savedCharacters : [Int] = CoreData.getSavedCharactersIds()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setUI()
    }
    
    func setUI(){
        backButton.setTitle("", for: .normal)
        titleLabel.font = .systemFont(ofSize: 28, weight: .medium)
        seperatorView.makeShadow(color: .black, offset: CGSize(width: 0, height: 0), opacity: 0.5, radius: 4)
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMainScreen", sender: nil)
    }
    
}

extension FavoriteScreenViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
        
    func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: "MainScreenCollectionViewCell" , bundle: nil), forCellWithReuseIdentifier: MainScreenCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 250)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characterResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenCollectionViewCell.identifier, for: indexPath) as! MainScreenCollectionViewCell
        cell.isFavorite = true
        cell.indexPath = indexPath
        cell.delegate = self
        cell.model = characterResults[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        nextVC.characterModel = characterResults[indexPath.row]
        if let cell = collectionView.cellForItem(at: indexPath) as? MainScreenCollectionViewCell {
            nextVC.isFavorite = cell.isFavorite
        }
        nextVC.reloadDelegate = self
        nextVC.modalPresentationStyle = .currentContext
        self.present(nextVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0.5
            
            UIView.animate(withDuration: 0.5) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }
        else {
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 500, 10, 0)
            cell.layer.transform = rotationTransform
            cell.alpha = 0.5
            
            UIView.animate(withDuration: 0.5) {
                cell.layer.transform = CATransform3DIdentity
                cell.alpha = 1.0
            }
        }
    }
    
}

extension FavoriteScreenViewController: cellFavoriteButtonProtocol {
    func buttonPressed(id: Int?, isFavorite: Bool?, index: IndexPath?) {
        guard let idValue = id
        else {
            return
        }
        for index in 0...characterResults.count-1 {
            if let id = characterResults[index].id {
                if id == idValue {
                    characterResults.remove(at: index)
                    break
                }
            }
        }
        
        CoreData.deleteSavedCharacter(characterId: idValue)
        savedCharacters = savedCharacters.filter {$0 != idValue}
        collectionView.reloadData()
    }
}

extension FavoriteScreenViewController: ReloadProtocol {
    func reloadCollectionView() {
        savedCharacters = CoreData.getSavedCharactersIds()
        characterResults = CoreData.getSavedCharacters()
    }
}



