import random
import string

def generate_password(min_length=8):  # Added a default minimum length
    #Word Banks
    adjectives = [
    "Red", "Blue", "Green", "Yellow", "Orange", "Purple", "Black", "White", "Gray", "Brown",
    "Pink", "Aqua", "Beige", "Coral", "Gold", "Indigo", "Ivory", "Lime", "Maroon", "Mint",
    "Navy", "Olive", "Peach", "Plum", "Rose", "Ruby", "Silver", "Sky", "Tan", "Teal",
    "Turquoise", "Violet", "Amber", "Azure", "Bronze", "Cream", "Crimson", "Denim", "Emerald", "Fuchsia",
    "Jade", "Khaki", "Lavender", "Lemon", "Lilac", "Magenta", "Mauve", "Mustard", "Ochre", "Periwinkle",
    "Rust", "Salmon", "Sapphire", "Scarlet", "Slate", "Steel", "Topaz", "Umber", "Wheat", "Wine",
    "Large", "Small", "Tall", "Short", "Big", "Long", "Wide", "High", "Deep", "Few", "Many", "Full", "Empty",
    "Broad", "Colossal", "Fat", "Giant", "Great", "Huge", "Immense", "Little", "Massive", "Micro",
    "Mini", "Narrow", "Petite", "Puny", "Scant", "Shallow", "Skinny", "Slim", "Stout", "Teeny",
    "Thin", "Tiny", "Vast", "Wee", "Whole", "Ample", "Boundless", "Countless", "Double", "Enough",
    "Extra", "Grand", "Heavy", "Infinite", "Jumbo", "Limitless", "Major", "Minor", "Minus", "Month",
    "Number", "Plus", "Prime", "Single", "Triple", "Twin", "Utmost", "Zero",
    "Fast", "Slow", "Heavy", "Light", "Warm", "Cold", "Hot",
    "Brisk", "Cool", "Frosty", "Frigid", "Hasty", "Icy", "Lukewarm", "Nimble", "Quick", "Rapid",
    "Scalding", "Speedy", "Swift", "Tepid", "Toasty",
    "Soft", "Hard", "Wet", "Dry", "Rough", "Smooth", "Open", "Shut", "Dark", "Bright",
    "Bumpy", "Calm", "Clean", "Clear", "Cloudy", "Coarse", "Crisp", "Curly", "Damp", "Dense",
    "Dirty", "Dull", "Dusty", "Even", "Faint", "Firm", "Flat", "Fluffy", "Fuzzy", "Glassy",
    "Glossy", "Glum", "Gooey", "Grainy", "Greasy", "Gritty", "Hairy", "Hazy", "Icy", "Itchy",
    "Jagged", "Keen", "Lacy", "Leathery", "Loose", "Lumpy", "Lush", "Matte", "Messy", "Misty",
    "Muddy", "Murky", "Neat", "Oily", "Plain", "Polished", "Prickly", "Pure", "Rocky", "Sandy",
    "Sharp", "Shiny", "Silky", "Slick", "Slimy", "Slippy", "Solid", "Sparse", "Spiky", "Spongy",
    "Spotty", "Stable", "Sticky", "Stiff", "Still", "Straight", "Striped", "Sturdy", "Tangled", "Taut",
    "Tender", "Thick", "Tight", "Tough", "Uneven", "Velvet", "Wavy", "Waxy", "Wiry", "Woody",
    "Woolly", "Young", "Happy", "Sad", "Good", "Bad", "Loud",
    "Able", "Acute", "Afraid", "Alert", "Alive", "Angry", "Basic", "Best", "Bold", "Brave",
    "Brief", "Busy", "Calm", "Careful", "Certain", "Cheap", "Chief", "Civil", "Clever", "Close",
    "Comfy", "Common", "Coy", "Crazy", "Cruel", "Daft", "Dear", "Decent", "Dizzy", "Eager",
    "Early", "Easy", "Equal", "Fair", "False", "Fancy", "Fatal", "Final", "Fine", "Fond",
    "Formal", "Foul", "Frank", "Fresh", "Funny", "Gentle", "Glad", "Grand", "Grave", "Grim",
    "Guilty", "Harsh", "Honest", "Humble", "Ideal", "Idle", "Ill", "Jolly", "Juicy", "Junior",
    "Just", "Keen", "Kind", "Known", "Lame", "Late", "Lazy", "Legal", "Lively", "Local",
    "Lonely", "Loose", "Lost", "Loyal", "Lucky", "Mad", "Major", "Marine", "Mean", "Merry",
    "Mild", "Moral", "Mute", "Naive", "Nasty", "Neat", "Nervy", "Nice", "Noble", "Noisy",
    "Normal", "Odd", "Only", "Oral", "Other", "Outer", "Pale", "Past", "Perfect", "Plain",
    "Polite", "Poor", "Pop", "Pretty", "Prior", "Proud", "Quaint", "Quiet", "Ready", "Real",
    "Regal", "Rich", "Right", "Rigid", "Ripe", "Royal", "Rude", "Rural", "Safe", "Same",
    "Scared", "Secret", "Senior", "Severe", "Shady", "Sharp", "Sheer", "Shy", "Silly", "Simple",
    "Sincere", "Sleepy", "Slight", "Sloppy", "Smart", "Sole", "Sore", "Sound", "Sour", "Spare",
    "Spicy", "Spry", "Stale", "Steep", "Stern", "Stray", "Strict", "Stuck", "Super", "Sure",
    "Sweet", "Tame", "Tart", "Tasty", "Tense", "Thank", "Tidy", "Tired", "Total", "Tragic",
    "Tricky", "True", "Urban", "Useful", "Valid", "Vivid", "Wary", "Weak", "Weary", "Weird",
    "Wild", "Wise", "Witty", "Wrong", "Zany"
    ]

    nouns = [
    "Cat", "Dog", "Elephant", "Shark", "Tiger", "Bear", "Zebra", "Mouse", "Kangaroo", "Donkey",
    "Frog", "Duck", "Ant", "Pig", "Cow", "Bee", "Bug",
    "Adder", "Alpaca", "Badger", "Bat", "Beaver", "Bird", "Boar", "Bobcat", "Bull", "Bunny",
    "Camel", "Chick", "Clam", "Cobra", "Cod", "Colt", "Cougar", "Crab", "Crane", "Crow",
    "Cub", "Deer", "Dingo", "Dodo", "Dove", "Dragon", "Drake", "Eagle", "Eel", "Elk",
    "Emu", "Falcon", "Fawn", "Ferret", "Finch", "Fish", "Flea", "Flock", "Fly", "Foal",
    "Fowl", "Fox", "Gecko", "Goat", "Goose", "Gopher", "Grouse", "Gull", "Hamster", "Hare",
    "Hawk", "Hen", "Heron", "Hog", "Horse", "Hound", "Hyena", "Impala", "Insect", "Jackal",
    "Jaguar", "Jay", "Kid", "Kitten", "Koala", "Lamb", "Lark", "Leech", "Lemur", "Leopard",
    "Lion", "Lizard", "Llama", "Lobster", "Louse", "Lynx", "Macaw", "Magpie", "Mare", "Mink",
    "Mole", "Monkey", "Moose", "Moth", "Mule", "Muskox", "Newt", "Ocelot", "Octopi", "Orca",
    "Ostrich", "Otter", "Owl", "Ox", "Oyster", "Panda", "Parrot", "Penguin", "Pigeon", "Pony",
    "Poodle", "Possum", "Prawn", "Puffin", "Puma", "Pup", "Puppy", "Python", "Quail", "Rabbit",
    "Racoon", "Ram", "Rat", "Raven", "Rhino", "Roach", "Robin", "Rooster", "Salmon", "Seal",
    "Sheep", "Shrew", "Shrimp", "Skunk", "Sloth", "Snail", "Snake", "Spider", "Squid", "Stag",
    "Steed", "Stoat", "Stork", "Swallow", "Swan", "Swift", "Tapir", "Termite", "Thrush", "Tick",
    "Toad", "Trout", "Turkey", "Turtle", "Viper", "Vole", "Vulture", "Wallaby", "Walrus", "Wasp",
    "Weasel", "Whale", "Wolf", "Wombat", "Woody", "Worm", "Wren", "Yak", "Yeti",
    "Bicycle", "Car", "Train", "Bus", "Airplane", "Taxi", "Boat", "Scooter", "Motorcycle", "Skateboard", "Bike",
    "Ambulance", "Barge", "Canoe", "Cart", "Chopper", "Coach", "Craft", "Cruise", "Cutter", "Ferry",
    "Firetruck", "Glider", "Gondola", "Jeep", "Jet", "Jitney", "Kayak", "Limo", "Lorry", "Moped",
    "Pickup", "Plane", "Raft", "Ricksha", "Rocket", "Sailboat", "Scooter", "Sedan", "Ship", "Shuttle",
    "Sled", "Sleigh", "Sub", "Tank", "Tanker", "Towboat", "Towcar", "Tractor", "Tram", "Trolley",
    "Truck", "Tugboat", "Van", "Wagon", "Wheel", "Yacht", "Zeppelin",
    "Pen", "Cup", "Book", "Box", "Key", "Flag", "Shoe", "Ball", "Chair", "Phone", "Light", "Watch", "Card",
    "Anchor", "Anvil", "Arrow", "Artwork", "Ashtray", "Awl", "Axe", "Badge", "Bag", "Bait",
    "Balloon", "Band", "Banner", "Barrel", "Basin", "Basket", "Battery", "Bauble", "Bead", "Beam",
    "Bell", "Belt", "Bench", "Bib", "Binder", "Blade", "Blanket", "Blender", "Blimp", "Block",
    "Board", "Bolt", "Bone", "Bongos", "Booklet", "Boombox", "Boot", "Bottle", "Bowl", "Bowtie",
    "Bracelet", "Bracket", "Braid", "Branch", "Brass", "Brick", "Briefs", "Broach", "Broom", "Brush",
    "Bubble", "Bucket", "Buckle", "Bud", "Bulb", "Bumper", "Bunker", "Burette", "Button", "Cable",
    "Cage", "Cake", "Camera", "Candle", "Candy", "Cane", "Canister", "Cap", "Cape", "Carton",
    "Case", "Cash", "Cask", "Casket", "Cassette", "Ceiling", "Cell", "Chain", "Chalk", "Charm",
    "Chart", "Chisel", "Cigar", "Clamp", "Clasp", "Clay", "Cleat", "Clip", "Clipper", "Clock",
    "Clothe", "Cloud", "Clutch", "Coaster", "Cobweb", "Coil", "Coin", "Collar", "Comb", "Comet",
    "Cone", "Container", "Cork", "Cot", "Couch", "Counter", "Cover", "Cowbell", "Cradle", "Crate",
    "Crayon", "Cream", "Crib", "Crown", "Crumb", "Crutch", "Crystal", "Cue", "Cuff", "Curler",
    "Curtain", "Cushion", "Cymbal", "Dagger", "Dart", "Deck", "Decoy", "Deed", "Desk", "Device",
    "Dial", "Diaper", "Diary", "Dice", "Dinghy", "Disc", "Dish", "Doll", "Doorknob", "Doormat",
    "Dow", "Dozer", "Drain", "Drawer", "Drum", "Dryer", "Duct", "Dumbell", "Dynamo", "Dynamite",
    "Easel", "Envelope", "Eraser", "Fan", "Faucet", "Feather", "Fence", "Fiddle", "File", "Film",
    "Filter", "Fire", "Flake", "Flame", "Flap", "Flash", "Flask", "Flint", "Float", "Floss",
    "Flour", "Flute", "Folder", "Fork", "Frame", "Frisbee", "Fuel", "Funnel", "Fur", "Furnace",
    "Gadget", "Game", "Gear", "Gem", "Gift", "Giggle", "Gizmo", "Glass", "Glitter", "Globe",
    "Glove", "Glue", "Goggles", "Gold", "Golfclub", "Gong", "Gown", "Grater", "Grease", "Grill",
    "Grip", "Groove", "Gum", "Gun", "Gyro", "Hacksaw", "Hair", "Hairpin", "Hammer", "Hammock",
    "Hand", "Handle", "Hanger", "Harness", "Harp", "Hat", "Hatchet", "Headband", "Headset", "Heart",
    "Heater", "Helmet", "Hinge", "Hoe", "Hook", "Hoop", "Horn", "Hose", "Hula", "Hummer",
    "Ice", "Icon", "Ink", "Iron", "Jack", "Jacket", "Jar", "Jeans", "Jewel", "Joystick",
    "Jug", "Juice", "Jukebox", "Keg", "Kettle", "Keyboard", "Kindling", "Kit", "Kite", "Kleenex",
    "Knapsack", "Knife", "Knob", "Knocker", "Label", "Lace", "Ladle", "Lamp", "Lantern", "Laptop",
    "Latch", "Lava", "Lawnmower", "Leaf", "Leash", "Leather", "Legging", "Lens", "Letter", "Lever",
    "Lid", "Lifeboat", "Line", "Linen", "Locket", "Log", "Loom", "Lotion", "Lumber", "Lure",
    "Lyre", "Magazine", "Magnet", "Mail", "Mallet", "Mandolin", "Manhole", "Mantel", "Map", "Marble",
    "Marker", "Mask", "Mast", "Mat", "Match", "Mattress", "Medal", "Menu", "Mesh", "Metal",
    "Meter", "Mic", "Micro", "Microphone", "Milk", "Mirror", "Mixer", "Model", "Modem", "Money",
    "Monitor", "Mop", "Mortar", "Moss", "Motor", "Mould", "Mount", "Mower", "Mud", "Mug",
    "Music", "Muzzle", "Nail", "Napkin", "Needle", "Net", "News", "Nipple", "Noodle", "Note",
    "Nozzle", "Nut", "Nylon", "Oar", "Oil", "Ointment", "Ornament", "Outlet", "Oven", "Overalls",
    "Paddle", "Padlock", "Page", "Pail", "Paint", "Pan", "Pancake", "Panel", "Pants", "Paper",
    "Parcel", "Parchment", "Paste", "Pastry", "Patch", "Path", "Patio", "Pebble", "Pedal", "Peg",
    "Pencil", "Pendant", "Pennant", "Perfume", "Petal", "Pick", "Pickaxe", "Picture", "Pie", "Piggybank",
    "Pill", "Pillar", "Pillow", "Pin", "Pincers", "Pipe", "Pitcher", "Pitchfork", "Pizza", "Placard",
    "Plan", "Plank", "Plant", "Plate", "Platform", "Platter", "Playpen", "Pliers", "Plot", "Plow",
    "Plug", "Plunger", "Pocket", "Pod", "Pole", "Polo", "Pom", "Pompom", "Pool", "Post",
    "Pot", "Powder", "Power", "Press", "Price", "Prism", "Projector", "Prop", "Propeller", "Puck",
    "Puddle", "Pulley", "Pulp", "Pump", "Punch", "Puppet", "Purse", "Pushpin", "Puzzle", "Pyramid",
    "Quill", "Quilt", "Rack", "Racket", "Radio", "Raft", "Rag", "Rail", "Rake", "Rasp",
    "Rattle", "Razor", "Receipt", "Record", "Reel", "Remote", "Resin", "Ribbon", "Rice", "Rifle",
    "Ring", "Rivet", "Robe", "Rock", "Roller", "Roof", "Rope", "Rotor", "Router", "Rowboat",
    "Rubber", "Rudder", "Rug", "Ruler", "Sack", "Saddle", "Salt", "Sand", "Sandal", "Sash",
    "Satellite", "Sauce", "Saucer", "Saw", "Scale", "Scalpel", "Scarf", "Scepter", "Scissors", "Scoop",
    "Scraper", "Screen", "Screw", "Script", "Scroll", "Scuba", "Sculpture", "Scythe", "Seat", "Seed",
    "Server", "Shackle", "Shade", "Shaft", "Shaker", "Shampoo", "Shard", "Shawl", "Shears", "Sheet",
    "Shelf", "Shell", "Shield", "Shingle", "Shirt", "Shoelace", "Shorts", "Shot", "Shovel", "Shower",
    "Sign", "Signal", "Silk", "Silo", "Silver", "Sink", "Siren", "Sketch", "Skewer", "Ski",
    "Skillet", "Skirt", "Skull", "Slab", "Slate", "Sled", "Sleeve", "Slide", "Sling", "Slipper",
    "Slingshot", "Smock", "Smoke", "Snare", "Snorkel", "Snow", "Snowflake", "Soap", "Sock", "Soda",
    "Sofa", "Soil", "Solder", "Sole", "Soup", "Spade", "Spark", "Spatula", "Spear", "Sphere",
    "Spice", "Spike", "Spindle", "Spinner", "Spirit", "Spit", "Spoke", "Sponge", "Spool", "Spoon",
    "Spray", "Spring", "Sprinkler", "Spur", "Square", "Squeegee", "Squirtgun", "Stack", "Staff", "Stage",
    "Stain", "Stair", "Stake", "Stalk", "Stamp", "Staple", "Stapler", "Star", "Statue", "Steak",
    "Steam", "Steel", "Stem", "Stencil", "Step", "Stereo", "Stew", "Stick", "Sticker", "Stool",
    "Stopper", "Stove", "Strap", "Straw", "Stream", "String", "Stroller", "Stub", "Stud", "Sub",
    "Sugar", "Suit", "Suitcase", "Sun", "Sundial", "Surfboard", "Swab", "Sweater", "Switch", "Sword",
    "Syringe", "Syrup", "Table", "Tablet", "Tack", "Tag", "Tambourine", "Tank", "Tap", "Tape",
    "Target", "Tarp", "Tassel", "Tea", "Teacup", "Tee", "Tent", "Test", "Text", "Thimble",
    "Thread", "Throne", "Thumb", "Ticket", "Tie", "Tile", "Timer", "Tinder", "Tinfoil", "Tip",
    "Tissue", "Toast", "Toaster", "Token", "Tongs", "Tool", "Tooth", "Top", "Torch", "Tote",
    "Touchpad", "Towel", "Tower", "Toy", "Trace", "Track", "Tractor", "Trailer", "Trap", "Tray",
    "Tread", "Treasure", "Tree", "Trellis", "Triangle", "Trigger", "Trim", "Trinket", "Tripod", "Trophy",
    "Trowel", "Tube", "Tumbler", "Tunic", "Turbine", "Tutu", "Tweezer", "Twine", "Type", "Umbrella",
    "Uniform", "Urn", "Utensil", "Vacuum", "Valve", "Vase", "Vault", "Vector", "Velvet", "Vent",
    "Vest", "Video", "Vine", "Viola", "Violin", "Vise", "Visor", "Voice", "Volume", "Voucher",
    "Wad", "Wafer", "Wagon", "Wallet", "Wall", "Wand", "Washer", "Water", "Wax", "Weapon",
    "Web", "Wedge", "Wheel", "Whisk", "Whistle", "Widget", "Wig", "Winch", "Wind", "Window",
    "Wine", "Wire", "Wood", "Wool", "Word", "Work", "Wreath", "Wrench", "Wrinkle", "Wristband",
    "Xylophone", "Yardstick", "Yarn", "Yoke", "Yoyo", "Zipper"
    ]
    special_chars = "!@#$%^&*_+"  # Add more in future
    num_or_spec_char = string.digits + special_chars 
    #Password generation
    password = f"{random.choice(adjectives)}-{random.choice(nouns)}"  
    random_number = f"{random.randint(0, 9999):04d}"  
    special_char = random.choice(special_chars) 

    # Modified filling loop
    while len(password) < min_length -5:
        if random.random() < 0.7:  # 70% chance of a word pair - Change this value to change probability
            password = f"{password}-{random.choice(adjectives)}-{random.choice(nouns)}"
        else:  # 30% chance of a random character
            password = f"{password}{random.choice(num_or_spec_char)}"

    password = f"{special_char}{password}{random_number}"
    return password


while True:
    try:
        desired_length = int(input("Enter the desired minimum password length (at least 8): "))
        if desired_length >= 8:
            password = generate_password(desired_length)
            print(password)
            break  # Exit the loop after getting a valid password
        else:
            print("Password length must be at least 8 characters.")
    except ValueError as e:
        if str(e) == "invalid literal for int() with base 10: ''": #If no input received uses default length of 8
            print("Null input recieved; using default password length of 8 characters.")
            password = generate_password()
            print(password)
            break
        else: #Otherwise repompts for a valid number
            print("Please enter a valid number.")
