# Exercice 10 - Le random

## Tâche:

Créez un nombre random.

## Indications:

- Ouvrez le fichier `Random.sol`.
- Créez un smart contract **Random**.
- Créez une fonction **getRandom** qui retourne un uint256 et prend en paramètre une string.
- Implémentez cette fonction en plusieurs étapes :
  - Chiffrez cette string via keccak.
  - Faites une opération qui dépend du block pour avoir un nombre aléatoire.
  - Retournez un nombre qui dérive de ces étapes.

## Félicitations:

Vous savez maintenant comment générer un nombre pseudo-aléatoire.
Comme le nombre dépend du block, si celui-ci est connu à l'avance, le nombre aléatoire pourra être connu lui aussi à l'avance.

C'est pour cela qu'on utilise des oracles du type [chainlink](https://chain.link/).

## Prochaine étape:

Vous allez maintenant pouvoir appliquer tout ce que vous avez appris pour pouvoir recréer **Leboncoin** en décentralisé.