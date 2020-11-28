

Pour recréer le VirtualEnv sur un autre ordinateur sur lequel vous avez récupéré le code de "Elon's Adventure Game Server"


# Aller dans le répertoire du projet, dans la partie serveur Python
cd <repertoireProjetPartiePyhon>

# Créer le VirtualEnv (attention, il faut bien taper python3, car le VirtualEnv n'est pas encore créé et il faut être sûr de la version de python)
python3 -m venv env

# Activer le VirtualEnv
source ./env/bin/activate

# Installer dedans toutes les dépendances
pip install -r requirements.txt

# Regénérer le fichier requirements.txt, au cas où il aurait changé (à cause de nouvelles dépendances qui seraient apparues)
pip freeze > requirements.txt
