//
//  ContentModel.swift
//  Learner App
//
//  Created by Philippe Reichen on 10/8/21.
//

import Foundation
import Firebase

class ContentModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    // List of modules
    @Published var modules = [Module]()
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    var styleData: Data?
    
    // Current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    
    init() {
        
        
        // Parse local json data
        // Change to Firebase to getlocalStyles
        
        getLocalStyles()
        
        // Get Database Model
        
        getModules()

        // Download remote json file and parse data
        // removed for using Firebase
//        getRemoteData()
        
    }
    
    // MARK: - Data methods
    
    func getLessons(module: Module, completion: @escaping () -> Void){

        // Specify path
        
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        // Get documents
        
        collection.getDocuments {snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Array to trck lessons
                
                var lessons = [Lesson]()
                
                // Loop through the documents and build array of lessons
                
                for doc in snapshot!.documents {
                    
                    // New lessons
                    
                    var l = Lesson()
                    
                    l.id = doc["id"] as? String ?? UUID().uuidString
                    l.title = doc["title"] as? String ?? ""
                    l.video = doc["video"] as? String ?? ""
                    l.duration = doc["duration"] as? String ?? ""
                    l.explanation = doc["explanation"] as? String ?? ""
                    
                    // Add the lesson to rhe arrray
                    
                    lessons.append(l)
                    
                }
                
                // Setting the lessons to the module as it is a struct it has to be set to the copy in page
                // Loop through published modules array and find the one that matches the id of the copy that got passed in (use index and enumerated)
                
                for (index, m) in self.modules.enumerated() {
                    
                    // Find the module we want
                    if m.id == module.id {
                       
                        //Set the lessons
                        self.modules[index].content.lessons = lessons
                        
                        // Call the completion closure
                        
                        completion()
                    }
                   
                }
            }
        }
    }
    
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        
        // Specify path
        
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        // Get documents
        
        collection.getDocuments {snapshot, error in
            
            if error == nil && snapshot != nil {
                
                // Array to trck lessons
                
                var questions = [Question]()
                
                // Loop through the documents and build array of lessons
                
                for doc in snapshot!.documents {
                    
                    // New lessons
                    
                    var q = Question()
                    
                    q.id = doc["id"] as? String ?? UUID().uuidString
                    q.content = doc["title"] as? String ?? ""
                    q.correctIndex = doc["correctIndex"] as? Int ?? 0
                    q.answers = doc["answers"] as? [String] ?? [String]()
                  
                    questions.append(q)
                    
                }
                
                // Setting the lessons to the module as it is a struct it has to be set to the copy in page
                // Loop through published modules array and find the one that matches the id of the copy that got passed in (use index and enumerated)
                
                for (index, q) in self.modules.enumerated() {
                    
                    // Find the module we want
                    if q.id == module.id {
                       
                        //Set the lessons
                        self.modules[index].test.questions = questions
                        
                        // Call the completion closure
                        
                        completion()
                    }
                   
                }
            }
        }
    }
                
                
                
    
    func getModules() {
      
        // Specify path
        let collection = db.collection("modules")
        
        // Get documents
        
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                
                // Create an array for the modules
                
                var modules = [Module]()
                
                
                // Loop through the documents returned
                for doc in snapshot!.documents {
                    
                    // Create a new module instance
                    
                    var m = Module()
                    
                    // Parse out the values from the document into the module instance
                    m.id = doc["id"] as? String ?? UUID().uuidString
                    m.category = doc["category"] as? String ?? ""
                    
                    // Parse the lesson content
                    let contentMap = doc["content"] as! [String:Any]
                    
                    m.content.id = contentMap["id"] as? String ?? ""
                    m.content.description = contentMap["description"] as? String ?? ""
                    m.content.image = contentMap["image"] as? String ?? ""
                    m.content.time = contentMap["time"] as? String ?? ""
                    
                    
                    //Parse the test content
                    let testMap = doc["test"] as! [String:Any]
                    
                    m.test.id = testMap["id"] as? String ?? ""
                    m.test.description = testMap["description"] as? String ?? ""
                    m.test.image = testMap["image"] as? String ?? ""
                    m.test.time = testMap["time"] as? String ?? ""
                    
                    
                    // Add it to our array
                    
                    modules.append(m)
                    
                    
                }
                
                // Assign our modules to the published property
                // Use DispatchQueque fro upating the UI
                
                DispatchQueue.main.async {
                    self.modules = modules
                }
            }
        }
        
    }
    // Change to Firebase to getlocalStyles
    
    func getLocalStyles() {
      
        
        /*
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read the file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
        }
        catch {
            // TODO log error
            print("Couldn't parse local data")
        }*/
        
        // Parse the style data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse style data")
        }
        
    }
    
    func getRemoteData() {
        
        // String path
        
        let urlString = "https://philreic.github.io/learningapp-data/data2.json"
        
        //Create a url object
        let url = URL(string : urlString)
        
        guard url != nil else {
// Could not create url
            return
        }
       
        // Create a URLRequest object
        let request = URLRequest(url: url!)
        
        // Get the session and kick off the task
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            // Check if theres in error
            guard error == nil else {
                // There was an error
                return
                
            }
            
            do{
            //Create json decoder
            let decoder = JSONDecoder()
            
            // Decode
                
                let modules = try decoder.decode([Module].self, from: data!)
                
                // Append parsed modules into modules property
                
                DispatchQueue.main.async {
                    
                    self.modules += modules
                
                }
                
               
                }
            
            catch {
                
                // Could not parse json
                
            }
        }
        
       // Kick of data task
        dataTask.resume()
        
    }
    
    // MARK: - Module navigation methods
    
    func beginModule(_ moduleid:String) {
        
        // Find the index for this module id
        for index in 0..<modules.count {
            
            if modules[index].id == moduleid {
            
                // Found the matching module
                currentModuleIndex = index
                break
            }
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
    }
    
    func beginLesson(_ lessonIndex:Int) {
        
        // Check that the lesson index is within range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
        codeText = addStyling(currentLesson!.explanation)
    }
    
    func nextLesson() {
        
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            
            // Set the current lesson property
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        }
        else {
            // Reset the lesson state
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    func hasNextLesson() -> Bool {
        
        guard currentModule != nil else {
            return false
        }
        
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    func beginTest(_ moduleId:String) {
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question index
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0  > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Set the question content
            codeText = addStyling(currentQuestion!.content)
        }
    }
    
    func nextQuestion() {
        
        // Advance the question index
        currentQuestionIndex += 1
        
        // Check that its within the range of questions
        if currentQuestionIndex < currentModule!.test.questions.count {
            
           // Set the current question
            
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
            
        }
        
        else {
            // If not then reset the properties
            
            currentQuestionIndex = 0
            currentQuestion = nil
        }
  
        
    }
 
    
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(styleData!)
        }
        
        // Add the html data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            
            resultString = attributedString
        }
        
        return resultString
    }
}
