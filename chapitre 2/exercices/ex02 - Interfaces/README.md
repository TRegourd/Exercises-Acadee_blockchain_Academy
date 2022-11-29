# Exercice 02 - Les interfaces

## Tâche:

Écrivez votre première interface en Solidity.

## Indications:

- Construisez une interface pour votre compteur dans `Interface.sol`. Votre interface doit être nommée `Counter`.
- Implémentez ce qui suit :
  - Une fonction **increment**.
  - Une fonction **reset**.
  - Une fonction **setCount**, prenant en paramètre le nouveau `count`.
  - Une fonction **getValue**, retournant la valeur actuelle du `count`.
- Soyez conscient de leur portée.

## Félicitations:

Les interfaces sont un outil très puissant dans la programmation orientée objet.\
Je vous invite vivement à jeter un coup d'œil à l'[ERC20](https://docs.openzeppelin.com/contracts/4.x/erc20) d'openzepplin.

Quelques informations sur les interfaces :
- L'interface ne peut pas avoir de fonction avec implémentation.
- Les fonctions d'une interface ne peuvent être que du type externe.
- L'interface ne peut pas avoir de constructeur.
- L'interface ne peut pas avoir de variables d'état.
- Une interface peut avoir des enum, des structures auxquels on peut accéder en utilisant la notation par point du nom de l'interface.

Bien sûr, vous pouvez hériter de cette interface pour implémenter vos propres fonctions.

De plus vous aurez plusieurs types spécifiques à la programmation orientée objet tel que pure, view que l'on vous conseille de regarder.

## Prochaine étape:

Vous allez maintenant voir comment rendre le code un peu plus propre via des `Modifiers`.
