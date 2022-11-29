import Web3 from "web3";

// la fonction utils.soliditySha3 permet de reproduire le fonctionnement de keccak256 en local
// Il faut trouver le bon hash (Dans quel encadrement de chiffre chercher ? Voir les paramettre de la fonction)

// Vous pouvez travailler sans aucune connexion a la blockchain pour trouver la solution.

const cryptedPassword =
  "0x0082a7fe5a578f7e8b41851c3f922f4aadc6cc57395d858bb57426e02b4db36a";

function brutForcePassword(number) {
  let hashed = Web3.utils.soliditySha3({
    type: "uint16",
    value: number,
  });

  if (hashed.toString() === cryptedPassword) {
    console.log(number);
  }
}

for (let i = 0; i <= 65535; i++) {
  brutForcePassword(i);
}
