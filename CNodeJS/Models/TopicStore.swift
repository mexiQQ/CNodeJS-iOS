//
//  TopicStore.swift
//  CNodeJS
//
//  Created by why on 10/20/14.
//  Copyright (c) 2014 why. All rights reserved.
//

import Alamofire

private let _sharedTopicStore = TopicStore()

enum TopicType:Int {
    case AllType    = 0
    case ShareType  = 1
    case AskType    = 2
    case JobType    = 3
}

enum LoadMode:Int {
    case Refresh    = 0
    case LoadMore  = 1
}

class TopicStore: NSObject {
    
    // topic data array
    var topicArray: [[TopicModel]] = [[TopicModel]](count: 4, repeatedValue: [TopicModel]())
    
    // current page number
    var nowPages = [1,1,1,1]
    
    // topics' values in parameter of api
    var topicValues = ["all","share","ask","job"]

    
    class var sharedInstance : TopicStore {
        return _sharedTopicStore
    }

    func loadData(type:TopicType, mode:LoadMode, finishedClosure:()->Void) {
        if(mode == .Refresh) {
            nowPages[type.rawValue] = 0
        }else if(mode == .LoadMore) {
            nowPages[type.rawValue] += 1
        }
        
        let url = "https://cnodejs.org/api/v1/topics?page=\(nowPages[type.rawValue])&tab=\(topicValues[type.rawValue])"
        
        Alamofire.request(.GET, url)
            .responseJSON {(_, _, JSON, _) in
                var topics = JSON as NSArray
                for item in topics {
                    var topicDic = item as NSDictionary
                    TopicStore.sharedInstance.topicArray[type.rawValue].append(ConvertTool.dictionaryToTopic(topicDic))
                }
                
                finishedClosure()
        }
        
    }
    
}
