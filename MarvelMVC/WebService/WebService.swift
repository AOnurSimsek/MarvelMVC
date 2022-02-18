//
//  WebService.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 16.02.2022.
//

import Foundation
import Alamofire
import ObjectMapper
import FirebaseAnalytics

class WebService {
    
    private static let apiKey : String = "82d176180b57cbd5606769d194e9e548"
    private static let privateKey : String = "8d07b721dd8fb5eb1d0141f076109890deaac506"
    private static let ts : String = NSUUID().uuidString
    private static let hash : String = (ts + privateKey + apiKey).md5()
    
    public static func getCharacters(limit: Int ,offset: Int,
                                     success: @escaping ((CharactersModel?)->Void),
                                     fail: @escaping ((String?)->Void)
    ){
        let _url : String = "https://gateway.marvel.com/v1/public/characters"
                                                                + "?hash=" + hash
                                                                + "&limit=" + "\(limit)"
                                                                + "&apikey=" + apiKey
                                                                + "&offset=" + "\(offset)"
                                                                + "&ts=" + ts
        guard let url = URL(string: _url)
        else {
            fail("URL error")
            return
        }
        
        AF.request(url, method: .get, parameters: nil).responseJSON { response in
            guard let data = response.value as? [String:Any]
            else {
                fail("Response Data Error")
                return
            }
            if let model : CharactersModel = Mapper<CharactersModel>().map(JSON: data) {
                success(model)
            }
            else {
                fail("Response Map Error")
            }
        }
        
    }
    
    public static func getComicsForCharacter(characterId: Int,
                                             success: @escaping ((ComicsMainModel?)->Void),
                                             fail: @escaping ((String?)->Void)
    ){
        let _url : String = "https://gateway.marvel.com/v1/public/characters/\(characterId)/comics"
                                                                        + "?hash=" + hash
                                                                        + "&apikey=" + apiKey
                                                                        + "&ts=" + ts
                                                                        + "&format=comic"
                                                                        + "&dateRange=2005-01-01%2C2022-02-16"
                                                                        + "&orderBy=-focDate"
                                                                        + "&limit=10"
        guard let url = URL(string: _url)
        else {
            fail("URL Error")
            return
        }
        
        AF.request(url, method: .get, parameters: nil).responseJSON { response in
            guard let data = response.value as? [String:Any]
            else {
                fail("Response Data Error")
                return
            }
            if let model : ComicsMainModel = Mapper<ComicsMainModel>().map(JSON: data) {
                success(model)
            }
            else {
                fail("Response Map Error")
            }
        }
    }
    
    public static func saveAnalytics(characterId: Int){
        Analytics.logEvent("CharacterDetail", parameters: [
            "CharacterId" : (characterId) as NSObject,
        ])
    }
    
}
