
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>


typedef struct item_struct {
	char* name;
	char* intro;
	char* description;
	bool usable;
} item;

typedef struct room_struct {
	char* name;
	char* description;
	bool accessible;
	bool firstTime;
	int items[10];
} room;


//GLOBAL DATA^^^^^^


void MoveItem(int actionVar, int selectedObject, int playerSatchel[15], item allGameItems[10], room*** presentLocation, int* row, int* column, room roomsMap[3][3]) {
	switch (actionVar) {
		case 6:
			if ((***presentLocation).items[selectedObject] == 1) {
				(***presentLocation).items[selectedObject] = 0;
				**presentLocation = &roomsMap[1][2];
				(***presentLocation).items[selectedObject] = 1;
				**presentLocation = &roomsMap[*row][*column];
				printf("You pick up the %s.\n", allGameItems[selectedObject].name);
			}
			else {
				printf("I don't see any %s.", allGameItems[selectedObject].name);
			}
			break;
		case 7:
			**presentLocation = &roomsMap[1][2];
			if ((***presentLocation).items[selectedObject] == 1) {
				(***presentLocation).items[selectedObject] = 0;
				printf("%s dropped.", allGameItems[selectedObject].name);
				**presentLocation = &roomsMap[*row][*column];
				(***presentLocation).items[selectedObject] = 1;
			}
			else    {
				printf("You don't have anything of the sort.");
				**presentLocation = &roomsMap[*row][*column];
			}
			break;
		default: break;
	}
	return;
}

void PrintSatchelContents(int playerSatchel[15], item allGameItems[10], room*** presentLocation, int* row, int* column, room roomsMap[3][3]) {
	int i = 0;
	
	printf("--INVENTORY--\n");
	**presentLocation = &roomsMap[1][2];
	for (i = 0; i < 10; ++i) {
		if ((***presentLocation).items[i] != 0) {
			printf("	%s\n", allGameItems[i].name);
		}
	}
	**presentLocation = &roomsMap[*row][*column];
	
	return;
}

void Travel(int directionVal, item allGameItems[10], room*** presentLocation, int** row, int** column, room mapArray[3][3]) {
	char* direction;
	int i = 0;
	
	(***presentLocation).accessible = false;
	switch (directionVal) {
		case 1: direction = "north"; 
				**row -= 1; 
				break;
		case 2: direction = "east"; 
				**column += 1; 
				break;
		case 3: direction = "south"; 
				**row += 1; 
				break;
		case 4: direction = "west"; 
				**column -= 1; 
				break;
		case 5: direction = ""; 
				**row = 10; 
				**column = 21; 
				printf("It works.");
				break;
		default: 
				direction = "You did not travel."; 
				break;
	}
	
	**presentLocation = &mapArray[**row][**column];   //FIXED: was changing mapArray, now is changing which entry is pointed to
	(***presentLocation).accessible = true;
	
	printf("You traveled %s.\n\n%s\n", direction, (***presentLocation).name);
	if ((***presentLocation).firstTime == true) {
		printf("\n%s\n", (***presentLocation).description);
	}
	for (i = 0; i < 10; ++i) {
		if ((***presentLocation).items[i] == 1 && (***presentLocation).firstTime == true) {
			printf("	%s\n", allGameItems[i].intro);
		}
	}
	(***presentLocation).firstTime = false;
	
	
	
	return;
}


void InputSearch(room** currentLocation, char topTierArchive[10][20], char secondArchive[10][20], char thirdArchive[10][20], int playerPack[15], item** currentObject, item allItems[10], char inputString[], int* currentRow, int* currentColumn, room arrayOfRooms[3][3]) {
	int i = 0;
	int actionVal = 0;
	int specifier = 0;
	int object = 0;
	//int extra = 0;
	char* keyWord;
	
	for (i = 0; i < strlen(inputString); ++i) {
		inputString[i] = (char)tolower(inputString[i]);
	} //ACCEPTS NON-CASE SENSITIVE INPUT
	
	
	//INPUT IDENTIFICATION
	for (i = 0; i < 8; ++i) {
		keyWord = strstr(inputString, topTierArchive[i]);
		if (keyWord != NULL) {
			actionVal = i;
		}
	}
	for (i = 0; i < 5; ++i) {
		keyWord = strstr(inputString, secondArchive[i]);
		if (keyWord != NULL) {
			specifier = i;
		}
	}
	for (i = 0; i < 7; ++i) {
		keyWord = strstr(inputString, thirdArchive[i]);
		if (keyWord != NULL) {
			object = i;
		}
	}
	/*
	for (i = 0; i < 10; ++i) {
		keyWord = strstr(inputString, fourthArchive[i]);
		if (keyWord != NULL) {
			extra = i;
		}
	}*/
	//INPUT IDENTIFICATION
	
	
	switch (actionVal) {
		case 0: break;
		case 1: case 2: case 3: 
			Travel(specifier, allItems, &currentLocation, &currentRow, &currentColumn, arrayOfRooms); 
			break;
		case 4: printf("It works."); break;
		case 5: PrintSatchelContents(playerPack, allItems, &currentLocation, currentRow, currentColumn, arrayOfRooms) ; break;
		case 6: case 7:
			MoveItem(actionVal, object, playerPack, allItems, &currentLocation, currentRow, currentColumn, arrayOfRooms);
			break;
		default: printf("I don't compute."); break;
	}
	
	return;
}


//*****|| MAIN ||*****


int main(int argc, char **argv)
{
	char input[20];
	char firstKeyMatrix[10][20] = {{"quit"},{"move"},{"travel"},{"go"},{"does it work?"},{"inventory"},{"pick up"},{"drop"}};
	char secondKeyMatrix[10][20] = {{""}, {"north"},{"east"},{"south"},{"west"}};
	char thirdKeyMatrix[10][20] = {{""},{"knife"},{"remote"},{"glass"},{"plate"},{"toilet paper"},{"iron"}};
	//char fourthKeyMatrix[10][20];
	int satchel[15];
	int currentLocationRow = 1;
	int currentLocationColumn = 1;
	int numTurn = 0;
	room* currentRoom = NULL;
	item* currentItem = NULL;
	int i = 0;
	//int j = 0;
	
	
	//ITEM INITIALIZATION
	item knife;
		knife.name = "nasty knife";
		knife.intro = "On the table is a nasty-looking knife.";
		knife.description = "This rusty, old knife looks like it's seen its best days, though it could probably still cut adequately.";
		knife.usable = false;
	item remote;
		remote.name = "TV remote";
		remote.intro = "On the couch is a remote that probably goes to the TV.";
		remote.description = "A remote for the TV. I wonder if it still works?";
		remote.usable = false;
	item glassOJ;
		glassOJ.name = "glass of orange juice";
		glassOJ.intro = "There's a glass of orange juice on the table, and it's still cold.";
		glassOJ.description = "A full glass of freshly squeezed Florida orange juice. Sounds satisfying..";
		glassOJ.usable = false;
	item toiletPaper;
		toiletPaper.name = "roll of toilet paper";
		toiletPaper.description = "When you gotta go, you gotta go..";
		toiletPaper.usable = false;
	item iron;
		iron.name = "clothes iron";
		iron.description = "Someone must have been using this recently.. It's still hot!";
		iron.usable = false;
	item plate;
		plate.name = "dinner plate";
		plate.description = "A ceramic dinner plate, with an old farmhouse painted intricately on it. Probably worth something!";
		plate.usable = false;
	//ITEM INITIALIZATION
	
	
	//INVENTORY INITIALIZATION
	room inventory; //initializing the player's inventory as a room, since they share enough characteristics
		inventory.name = "Inventory";
		inventory.description = "This is your pack.";
		inventory.firstTime = false;
		inventory.accessible = true;
			inventory.items[0] = 0;
			inventory.items[1] = 0;
			inventory.items[2] = 0;
			inventory.items[3] = 0;
			inventory.items[4] = 0;
			inventory.items[5] = 0;
			inventory.items[6] = 0;
			inventory.items[7] = 0;
			inventory.items[8] = 0;
			inventory.items[9] = 0;
	//ROOM INITIALIZATION
	room kitchen;
		kitchen.name = "Kitchen";
		kitchen.description = "Welcome to the kitchen. Hungry?";
		kitchen.accessible = false;
		kitchen.firstTime = true;
			kitchen.items[1] = 1;
			kitchen.items[3] = 1;
	room livingRoom;
		livingRoom.name = "Living Room";
		livingRoom.description = "You walk into the living room. Along the wall is a lamp on a desk, and the couch on the other side. Directly in front of you is a large flat-screen plasma TV.";
		livingRoom.accessible = false;
		livingRoom.firstTime = true;
			livingRoom.items[2] = 1;
	room diningRoom;
		diningRoom.name = "Dining Room";
		diningRoom.description = "There is a table in the middle of the room, with plates out for dinner.";
		diningRoom.accessible = false;
		diningRoom.firstTime = true;
			diningRoom.items[4] = 1;
	room den;
		den.name = "Den";
		den.description = "There is a set of antlers hanging on the far wall, and a fireplace by the adjacent left wall. The fire is going and it is warm.";
		den.accessible = false;
		den.firstTime = true;
	room laundryRoom;
		laundryRoom.name = "Laundry Room";
		laundryRoom.description = "Ew. Dirty socks everywhere.";
		laundryRoom.accessible = false;
		laundryRoom.firstTime = true;
			laundryRoom.items[6] = 1;
	room bathroom;
		bathroom.name = "Bathroom";
		bathroom.description = "Someone forget to flush! Better open the window.";
		bathroom.accessible = false;
		bathroom.firstTime = true;
			bathroom.items[5] = 1;
	room porch;
		porch.name = "Porch";
		porch.description = "Junk everywhere. Whoever lives here must be a hoarder.";
		porch.accessible = false;
		porch.firstTime = true;
	room emptyRoom;
		emptyRoom.name = "Empty Room";
		emptyRoom.description = "";
		emptyRoom.accessible = false;
		emptyRoom.firstTime = false;
	//ROOM INITIALIZATION
	
	
	for (i = 0; i < 15; ++i) {
		satchel[i] = 1;
	}
	
	room mapRooms[3][3] = {{bathroom, kitchen, laundryRoom},{den, livingRoom, inventory},{emptyRoom, diningRoom, porch}};
	item gameItems[10] = {{}, knife, remote, glassOJ, plate, toiletPaper, iron, {}, {}, {}};
	
	currentRoom = &mapRooms[1][1];
	(*currentRoom).accessible = true;
	
	printf("	**||---Welcome to ZORK---||**\n\n	<%s>\n%s\n", (*currentRoom).name, (*currentRoom).description);
	
	
	
	//PRIMARY LOOP
	while (strcmp(input, "quit") != 0) {
		++numTurn;
		
		printf("\n>>");
		scanf(" %50[^\n]", input);
		
		
		InputSearch(&currentRoom, firstKeyMatrix, secondKeyMatrix, thirdKeyMatrix, satchel, &currentItem, gameItems, input, &currentLocationRow, &currentLocationColumn, mapRooms);
		
		
		//printf("	Location: %i, %i", currentLocationRow, currentLocationColumn);
		if (numTurn % 50 == 0) {
			printf("		[Turns: %i]", numTurn);
		}
		printf("\n\n\n");
	}
	
	return 0;
}
