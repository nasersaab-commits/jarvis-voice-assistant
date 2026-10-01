import server


def test_extract_action_splits_spoken_text_and_action():
    text, action = server.extract_action("Ich suche das. [ACTION:SEARCH] wetter morgen")
    assert text == "Ich suche das."
    assert action == {"type": "SEARCH", "payload": "wetter morgen"}


def test_extract_action_without_action():
    text, action = server.extract_action("Guten Morgen, Sir.")
    assert text == "Guten Morgen, Sir."
    assert action is None


def test_extract_action_only_action():
    text, action = server.extract_action("[ACTION:SCREEN]")
    assert text == ""
    assert action == {"type": "SCREEN", "payload": ""}


def test_system_prompt_fills_in_time():
    prompt = server.get_system_prompt()
    assert "{time}" not in prompt
    assert "[ACTION:SEARCH]" in prompt
