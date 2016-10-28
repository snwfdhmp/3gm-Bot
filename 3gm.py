import mechanize
agent = mechanize.Browser()
agent.set_handle_robots(False)
agent.add_headers = [('User-agent', 'Firefox')]
agent.open("http://www.3gm.fr")
agent.form = list(agent.forms())[0] 
agent.form["email"] = ""
agent.form["pass"] = ""
agent.form["serveur"] = "1"
agent.form["connexion"] = "1"
agent.submit()
agent.open("http://www.3gm.fr/game/")
print agent.get_data()