//
//  MainScreenViewController.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 16.02.2022.
//

import UIKit

class MainScreenViewController: UIViewController {
    
    //TopView
    @IBOutlet weak var topLogoImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var seperatorLine: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var charactersModel : [CharactersResultModel] = []
    var charactersLimit : Int = 30
    var charactersOffset : Int = 0
    var savedCharacters : [Int] = CoreData.getSavedCharactersIds()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCollectionView()
        fetchData(limit: charactersLimit, offset: charactersOffset)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func setUI(){
        topLogoImageView.makeShadow(color: .black, offset: CGSize(width: 0, height: 3), opacity: 0.5, radius: 8)
        
        seperatorLine.makeShadow(color: .black, offset: CGSize(width: 0, height: 0), opacity: 0.5, radius: 4)

        favoriteButton.setTitle("", for: .normal)
        favoriteButton.setImage(UIImage(named: "star"), for: .normal)
        favoriteButton.tintColor = .black
        favoriteButton.backgroundColor = .marvelLogoRed
        favoriteButton.layer.cornerRadius = 8
        favoriteButton.layer.masksToBounds = true
        favoriteButton.makeShadow(color: .marvelLogoRed, offset: CGSize(width: 0, height: 3), opacity: 0.5, radius: 8)
        
    }
    
    func fetchData(limit: Int, offset: Int) {
        LoadingView.shared.startLoadingView(vc: self)
        WebService.getCharacters(limit: limit, offset: offset) { response in
            if let unwrappedResult = response?.data?.result {
                if offset == 0 {
                    self.charactersModel = unwrappedResult
                }
                else {
                    self.charactersModel.append(contentsOf: unwrappedResult)
                }
                self.collectionView.reloadData()
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
    
    @IBAction func favoriteButtonPressd(_ sender: UIButton) {
        performSegue(withIdentifier: "toFavoriteVC", sender: nil)
    }
    
    @IBAction func unwindToMainScreen( _ seg: UIStoryboardSegue) {
        savedCharacters = CoreData.getSavedCharactersIds()
        collectionView.reloadData()
    }

}

extension MainScreenViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
        
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
        charactersModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainScreenCollectionViewCell.identifier, for: indexPath) as! MainScreenCollectionViewCell
        
        if indexPath.row == charactersModel.count-1 {
            let newLimit = charactersLimit + 30
            let newOffset = charactersOffset + 30
            fetchData(limit: newLimit, offset: newOffset)
        }
        
        if savedCharacters.contains(charactersModel[indexPath.row].id ?? 0) {
            cell.isFavorite = true
        }
        else {
            cell.isFavorite = false
        }
        
        cell.indexPath = indexPath
        cell.delegate = self
        cell.model = charactersModel[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        nextVC.characterModel = charactersModel[indexPath.row]
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

extension MainScreenViewController: cellFavoriteButtonProtocol {
    func buttonPressed(id: Int?, isFavorite: Bool?, index: IndexPath?) {
        guard let favValue = isFavorite, let idValue = id, let indexValue = index
        else {
            return
        }
        
        if favValue {
            CoreData.deleteSavedCharacter(characterId: idValue)
            savedCharacters = savedCharacters.filter {$0 != idValue}
        }
        else {
            for element in charactersModel {
                if idValue == element.id {
                    CoreData.saveCharacter(character: element)
                    savedCharacters.append(idValue)
                    break
                }
            }
        }
        
        collectionView.reloadItems(at: [indexValue])
    }
}

extension MainScreenViewController: ReloadProtocol {
    func reloadCollectionView() {
        savedCharacters = CoreData.getSavedCharactersIds()
        collectionView.reloadData()
    }
}
