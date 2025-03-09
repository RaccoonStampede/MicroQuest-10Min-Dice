extends Node2D

var hero = {"name": "Sock Sage", "wit": 8, "luck": 3, "charm": 6, "grit": 5}
var inventory = ["Dusty Lint"]
var stage = 0
var quest_data = {}
var current_choices = []
var roll_history = []

func _ready():
    var file = FileAccess.open("res://data/QuestData.json", FileAccess.READ)
    if file:
        quest_data = JSON.parse_string(file.get_as_text())
        file.close()
    else:
        $StoryText.text = "[center][b]Error: Quest data not found![/b][/center]"
        return
    $StoryText.text = "[center][b]" + quest_data["intro"] + "[/b][/center]"
    await get_tree().create_timer(2.5).timeout
    next_stage()

func next_stage():
    stage += 1
    if stage <= quest_data["stages"].size():
        var current_stage = quest_data["stages"][stage - 1]
        $StoryText.text = "[b]" + current_stage["text"] + "[/b]"
        $StoryText.scroll_to_line(0)
        current_choices = filter_choices(current_stage["choices"])
        show_choices(current_choices)
    else:
        end_quest()

func filter_choices(choices):
    var valid_choices = []
    for choice in choices:
        if "requires" in choice:
            if choice["requires"] in inventory:
                valid_choices.append(choice)
        else:
            valid_choices.append(choice)
    return valid_choices

func show_choices(choices):
    for child in $ChoiceContainer.get_children():
        child.queue_free()
    for i in range(choices.size()):
        var button = preload("res://scenes/ChoiceButton.tscn").instantiate()
        button.text = choices[i]["option"]
        button.connect("pressed", Callable(self, "choice_made").bind(i))
        $ChoiceContainer.add_child(button)

func choice_made(choice_idx):
    var choice = current_choices[choice_idx]
    var roll = roll_dice(choice["dice"])
    $DiceResult.text = "Rolled " + choice["dice"] + ": " + str(roll)
    roll_history.append(roll)
    
    var stat_value = hero[choice["stat"]]
    var outcome_text = ""
    
    if roll >= stat_value + 2:
        outcome_text = choice["crit_success"] if "crit_success" in choice else choice["success_text"]
        if "reward" in choice:
            inventory.append(choice["reward"])
    elif roll >= stat_value:
        outcome_text = choice["success_text"]
        if "reward" in choice:
            inventory.append(choice["reward"])
    else:
        outcome_text = choice["fail_text"]
        if "penalty" in choice and choice["penalty"] in inventory:
            inventory.erase(choice["penalty"])
    
    $StoryText.text += "\n[i]" + outcome_text + "[/i]"
    $StoryText.scroll_to_line($StoryText.get_line_count() - 1)
    
    for child in $ChoiceContainer.get_children():
        if child.has_node("AudioStreamPlayer"):
            child.get_node("AudioStreamPlayer").play()
    
    await get_tree().create_timer(3.0).timeout
    $DiceResult.text = ""
    next_stage()

func roll_dice(dice_type):
    if dice_type == "d20":
        return randi_range(1, 20)
    elif dice_type == "d6":
        return randi_range(1, 6)
    return 0

func end_quest():
    var ending_idx = calculate_ending()
    var ending = quest_data["endings"][ending_idx]
    $StoryText.text = "[center][b]" + ending["text"] + "[/b][/center]"
    if "reward" in ending:
        inventory.append(ending["reward"])
    $StoryText.text += "\n\n[i]Final Inventory: " + str(inventory) + "[/i]"
    for child in $ChoiceContainer.get_children():
        child.queue_free()

func calculate_ending():
    var successes = 0
    for roll in roll_history:
        if roll >= hero["wit"] or roll >= hero["charm"] or roll >= hero["luck"] or roll >= hero["grit"]:
            successes += 1
    if inventory.has("Jam Key"):
        return 0
    elif successes >= 3:
        return 1
    elif successes >= 1:
        return 2
    else:
        return 3
