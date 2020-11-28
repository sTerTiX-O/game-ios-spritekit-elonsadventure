# -*- coding: utf-8 -*-
from flask import Flask, render_template, jsonify
import time
import uuid


app = Flask(__name__)


#
# Exemple d'appel avec curl
# curl http://127.0.0.1:5010//api/score/update/game/ElonAdventures/session/230847234/player/LaMerde/score/12
#
@app.route("/api/score/update/game/<gameId>/session/<sessionId>/player/<playerId>/score/<score>")
def updateScore(gameId, sessionId, playerId, score):

    uuidScoreUpdate = uuid.uuid4().hex
    timeServerScoreUpdate = int(time.time())

    print('Game[{}]/Session[{}] - Le score de [{}] est maintenant de [{}]'.format(gameId, sessionId, playerId, score))    
    
    messageRetour = {
        "scoreUpdateUUID" : uuidScoreUpdate,
        "serverTime": timeServerScoreUpdate,
        "otherPlayersScores": {}
    }

    return messageRetour



# Lance le serveur
if __name__ == "__main__":
    app.run(host='0.0.0.0', port='5010', debug=True)
