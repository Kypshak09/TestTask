import Foundation
import Combine

class StudentInfoViewModel: ObservableObject {

    @Published var studentInfo: StudentInfo?
    var cancellables = Set<AnyCancellable>()

    init() {
        getStudentInfo()
    }

    func getStudentInfo() {
        guard let url = Bundle.main.url(forResource: "StudentInfoJson", withExtension: "json") else {
            print("File not found.")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                return element.data
            }
            .decode(type: StudentInfo.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] studentInfo in
                self?.studentInfo = studentInfo
            })
            .store(in: &cancellables)
    }
    
    func downloadFile(from urlString: String, completion: @escaping (URL?, Error?) -> Void) {
           guard let url = URL(string: urlString) else {
               print("Invalid URL.")
               return
           }

           let downloadTask = URLSession.shared.downloadTask(with: url) { (location, response, error) in
               guard let tempLocation = location, error == nil else {
                   print("Error downloading file: \(error!)")
                   completion(nil, error)
                   return
               }
               
               let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
               let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
               
               do {
                   if FileManager.default.fileExists(atPath: destinationUrl.path) {
                       try FileManager.default.removeItem(at: destinationUrl)
                   }
                   try FileManager.default.copyItem(at: tempLocation, to: destinationUrl)
                   completion(destinationUrl, nil)
               } catch (let writeError) {
                   print("Error creating a file at \(destinationUrl) : \(writeError)")
                   completion(nil, writeError)
               }
           }
           
           downloadTask.resume()
       }
}


