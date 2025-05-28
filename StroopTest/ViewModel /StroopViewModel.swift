import SwiftUI
import Firebase

class StroopviewModel: ObservableObject {
    @Published var stroopQuestions: [Question] = []
    
    func getQuestions(set: String) {
        // Clear existing questions when fetching new ones
        self.stroopQuestions = []
        
        // Use the set parameter instead of hardcoded "Round_1"
        let db = Firestore.firestore()
        
        db.collection(set).getDocuments { (snapshot, error) in
            // Handle error case
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                return
            }
            
            // Make sure we have documents
            guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                print("No documents found in collection \(set)")
                return
            }
            
            // Parse documents and update on main thread
            DispatchQueue.main.async {
                self.stroopQuestions = snapshot.documents.compactMap { (document) -> Question? in
                    do {
                        let question = try document.data(as: Question.self)
                        return question
                    } catch {
                        return nil
                    }
                }
                print("\(self.stroopQuestions)")
            }
        }
    }
}

