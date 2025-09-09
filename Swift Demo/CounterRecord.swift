import Foundation

struct CounterRecord: Identifiable {
    let id: String
    var count: Int
    let ownerId: String?
    let createdAt: Date
}
