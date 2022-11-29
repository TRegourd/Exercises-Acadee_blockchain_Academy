# Exercice 04 - Les mémoires

Cet exercice n'en est pas réellement un puisque c'est pour que vous compreniez la différence entre les différents types de mémoires sur un smart contrat.

Tout d'abord vous avez le **storage** qui est un stockage **permanent** permettant de stocker tout ce qui va persister.\
C'est là où sont stockées toutes les variables et fonctions à l'intérieur du contract.

Ensuite, vous avez la **memory** qui est un stockage **temporaire**.\
Elle existe juste le temps de l'exécution du contrat et est utilisée par défaut dans les méthodes des fonctions.

Pour autant vous devriez parfois spécifier quelle mémoire utiliser.\
Notamment quand vous voudrez créer une array dans une fonction ou juste utiliser une array en paramètre d'une fonction.

Dès que vous allez utiliser du **storage** c'est ici que vous allez payer ce que l'on appelle du **gas**.\
Plus vous dépensez de **gas**, plus grand sera le cout en ethereum pour exécuter la transaction.\
C'est pour cela qu'on tente d'utiliser le moins possible le storage.

Une autre optimisation importante, est d'utiliser les bons types de variables.\
Vous avez déjà pu voir les types basiques, mais il faut savoir que vous pouvez spécifier pour chaque variable le nombre de bits qu'elle va prendre dans le stockage, permettant ainsi d'utiliser moins de gas.
