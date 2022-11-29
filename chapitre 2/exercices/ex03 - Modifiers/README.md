# Exercice 03 - Les modifiers

## Tâche:

Créez un `modifier` qui permet de voir si la personne qui appelle une fonction est l'`owner` du contrat.

## Indications:

- Ouvrez le fichier `Modifier.sol`.
- Créez un contrat **Modifier**.
- Créez un constructeur pour stocker l'adresse de l'owner du contrat.
- Créez un `modifier` **isOwner** qui permet de bloquer le code si jamais la personne qui appelle la fonction n'est pas l'owner du contract via un `require`.
- Appliquez ce `modifier` sur une fonction que vous créez.

## Félicitations:

Vous savez maintenant comment créer et utiliser un `modifier`.

Vous allez aussi utiliser `require` qui est très utile pour faire des conditions avant d'exécuter des fonctions. \
Vous avez aussi d'autres keywords tels qu'`assert` et `revert` qu'on vous conseille d'aller voir.

## Prochaine étape:

Vous allez apprendre comment fonctionne la mémoire en EVM.