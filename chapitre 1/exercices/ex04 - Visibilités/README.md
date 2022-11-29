# Exercice 04 - Les visibilités

## Tâche:

Apprenez les différentes visibilités des variables et des fonctions dans Solidity.

## Indications:

- Ouvrez le fichier `Visiblity.sol`.
- Ce smart contract contiendra toutes les variables que vous avez créées à l'étape 3.
- Définissez la visibilité d'**answerToLife** et de **wrongAnswerToLife** afin qu'elles soient visibles pour tout le monde.
- Définissez la visibilité de **sentence**, **isTrue** et **owner** afin qu'elles soient visibles que par le smart contract.

## Félicitations:

Bravo, vous pouvez maintenant définir la visibilité d'une variable !\
Ceci sera utile lorsque quelqu'un ne doit pas accéder à certaines données.

La visibilité n'est pas seulement pour les variables, mais aussi pour les fonctions.\
Cependant, il existe d'autres types que public et private, internal et external.

Internal permet de rendre un élément seulement accessible par le smart contract et ceux qui dérivent de celui-ci (vous allez voir dans le prochain module à quoi cela correspond).\
External permet de rendre une fonction accessible par tous les autres smart contracts mais pas lui-même.

Public permet de rendre un élément accessible par tout le monde.\
Private permet de rendre une fonction seulement accessible au smart contract (c'est la visibilité la plus restrictive).

Lorsqu'une variable publique est créée, le compilateur Solidity crée automatiquement une méthode spéciale, un getter, qui vous permet de récupérer la valeur de cette variable.

Par défaut toutes les variables sans visibilité précisée vont être internal tandis que les fonctions auront public comme visibilité par défaut.

Toutes ces visibilités sont celles de Solidity mais dans la blockchain les fonctions seront tout de même visibles.

## Prochaine étape:

Vous aller apprendre à faire des array de variables.