import Foundation

// Function to calculate the Jaccard similarity between two strings
func jaccardSimilarity(_ string1: String, _ string2: String) -> Double {
    // Split the input strings into sets of words
    let set1 = Set(string1.split(separator: " "))
    let set2 = Set(string2.split(separator: " "))
    
    // Calculate the intersection and union of the two sets
    let intersection = set1.intersection(set2).count
    let union = set1.union(set2).count
    
    // Return the Jaccard similarity as the ratio of the intersection to the union
    return Double(intersection) / Double(union)
}
