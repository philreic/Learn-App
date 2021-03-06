//
//  Models.swift
//  Learner App
//
//  Created by Philippe Reichen on 10/9/21.
//

import Foundation

struct Module: Decodable, Identifiable {
    // For Firebase change Int to String as the data in Firebase will be String
    
    var id: String = ""
    var category: String = ""
    var content: Content = Content()
    var test: Test = Test()
}

struct Content: Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var lessons: [Lesson] = [Lesson]()
    
}

struct Lesson: Decodable, Identifiable {
    
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explanation: String = ""
    
}

struct Test: Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var questions: [Question] = [Question]()
}

struct Question: Decodable, Identifiable {
    
    var id: String = ""
    var content: String = ""
    var correctIndex: Int = 0
    var answers: [String] = [String]()
}
