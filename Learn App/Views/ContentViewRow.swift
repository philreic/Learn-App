//
//  ContentViewRow.swift
//  Learner App
//
//  Created by Philippe Reichen on 10/11/21.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    var index: Int
    
    var lesson: Lesson {
    
       // if model.currentModule != nil &&
        
        // Alternate to nil check
           if index < model.currentModule?.content.lessons.count ?? 0 {
            
            return model.currentModule!.content.lessons[index]
        }
        else{
            return Lesson(id: "", title: "", video: "", duration: "", explanation: "")
            
        }
    }
    
    var body: some View {
        
        //let lesson = model.currentModule!.content.lessons[index]
        
        // Lesson card
        ZStack (alignment: .leading) {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            HStack (spacing: 30) {
                
                Text(String(index + 1))
                    .bold()
                
                VStack (alignment: .leading) {
                    Text(lesson.title)
                        .bold()
                    Text(lesson.duration)
                }
                
            }
            .padding()
        }
            .padding(.bottom, 5)
        
    }
}
