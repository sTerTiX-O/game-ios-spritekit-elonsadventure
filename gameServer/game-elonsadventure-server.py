# -*- coding: utf-8 -*-
from flask import Flask, render_template, jsonify
import time
import uuid
import os


app = Flask(__name__)


#
# Exemple d'appel avec curl
#    curl http://127.0.0.1:5010/api/score/update/game/ElonAdventures/session/230847234/player/player23234/score/12
#    curl --insecure https://fonf.xxxxxx.xyz:0000/api/score/update/game/ElonAdventures/session/230847234/player/player23234/score/14
#
# Remarque: Pour que l'accès depuis l'extérieur fonctionne, il faut configurer le port forwarding au niveau des routeurs
#             - au niveau du routeur du fournisseur internet (ISP)
#             - au niveau du routeur Google Wifi interne 
#
#           Pour le certificat HTTPS, comme le serveur en Python utilise un certificat auto-signé, et qui ne correspond pas 
#           au nom de domaine utilisé pour arriver sur l'IP sortante du routeur de l'ISP, le client qui fait la requête doit
#           accpeter de ne pas pouvoir identifier le serveur (d'où l'option --insecure utilsée avec curl)
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

    # Rend le port d'écoute configurable (utile notamment pour GCP CloudRun)
    try:
        SERVER_PORT = os.getenv('SERVER_PORT')
    except:    
        SERVER_PORT='7500'

    # Rend l'écoute sur HTTPS configurable (doit être désactivé pour GCP CloudRun, car c'est lui qui fait la terminaison TLS)
    try:
        DO_NOT_USE_HTTPS = (os.getenv('DO_NOT_USE_HTTPS') is not None) and (os.getenv('DO_NOT_USE_HTTPS').lower() == "true")
    except:    
        DO_NOT_USE_HTTPS = False

    # Lance le serveur
    print("Environment variables SERVER_PORT[{}] DO_NOT_USE_HTTPS[{}]".format(os.getenv('SERVER_PORT'), os.getenv('DO_NOT_USE_HTTPS')))
    print("  -> running proutechos/elonsadventure-server with SERVER_PORT[{}] DO_NOT_USE_HTTPS[{}]".format(SERVER_PORT, DO_NOT_USE_HTTPS))
    if DO_NOT_USE_HTTPS:
        app.run(host='0.0.0.0', port=SERVER_PORT, debug=True)
    else:
        app.run(host='0.0.0.0', port=SERVER_PORT, debug=True, ssl_context='adhoc')

