import UIKit



// Colors
let appColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
let navigationBarColor = UIColor(red: 235/255, green: 25/255, blue: 65/255, alpha: 1.0)
let buttonColor = UIColor.white

struct Constants {
	static var isTesting = true
}

func defaultData() -> [Section] {
	
	var fullList: [Section] = []
	
	let produceSection = Section()
	produceSection.name = "Produce Section"
	produceSection.isSelected = true
	let apples = Item(name: "Apples", isInCart: false, isOnGroceryList: true)
	let bananas = Item(name: "Bananas", isInCart: false, isOnGroceryList: true)
	let carrots = Item(name: "Carrots", isInCart: false, isOnGroceryList: false)
	let celery = Item(name: "Celery", isInCart: false, isOnGroceryList: false)
	produceSection.masterListItem.append(apples)
	produceSection.masterListItem.append(bananas)
	produceSection.masterListItem.append(carrots)
	produceSection.masterListItem.append(celery)
	fullList.append(produceSection)
	
	let deliSection = Section()
	deliSection.name = "Deli"
	let cheese = Item(name: "Cheese", isInCart: false, isOnGroceryList: true)
	let meat = Item(name: "Lunch Meat", isInCart: false, isOnGroceryList: false)
	let salad = Item(name: "Potato Salad", isInCart: false, isOnGroceryList: true)
	deliSection.masterListItem.append(cheese)
	deliSection.masterListItem.append(meat)
	deliSection.masterListItem.append(salad)
	fullList.append(deliSection)
	
	let breadSection = Section()
	breadSection.name = "Bread Aisle"
	let bread = Item(name: "Bread", isInCart: false, isOnGroceryList: true)
	let rolls = Item(name: "Hamburger Rolls", isInCart: false, isOnGroceryList: false)
	breadSection.masterListItem.append(bread)
	breadSection.masterListItem.append(rolls)
	fullList.append(breadSection)
	
	let dairySection = Section()
	dairySection.name = "Dairy Section"
	let milk = Item(name: "Milk", isInCart: false, isOnGroceryList: true)
	let eggs = Item(name: "Eggs", isInCart: false, isOnGroceryList: true)
	let butter = Item(name: "Butter", isInCart: false, isOnGroceryList: false)
	dairySection.masterListItem.append(milk)
	dairySection.masterListItem.append(eggs)
	dairySection.masterListItem.append(butter)
	fullList.append(dairySection)
	
	let householdSection = Section()
	householdSection.name = "Household Items Aisle"
	let pt = Item(name: "Paper Towels", isInCart: false, isOnGroceryList: true)
	let tp = Item(name: "Toilet Paper", isInCart: false, isOnGroceryList: false)
	householdSection.masterListItem.append(pt)
	householdSection.masterListItem.append(tp)
	fullList.append(householdSection)
	
	return fullList
}


