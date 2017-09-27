import Foundation

func documentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	return paths[0]
}

func sectionsFile() -> URL {
	return documentsDirectory().appendingPathComponent("sections.plist")
}
