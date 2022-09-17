import FlowBirds from "../Contracts/FlowBirds.cdc"

transaction(user: Address, name: String) {

prepare(signer: AuthAccount){
   let minter = signer.borrow<&FlowBirds.NFTMinter>(from: FlowBirds.NFTMinterStorage)
                    ?? panic("The signer is not a minter")

   let collection = getAccount(user).getCapability(FlowBirds.CollectionPublicPath)
                                    .borrow<&FlowBirds.Collection{FlowBirds.CollectionPublic}>()
                                    ?? panic("A linked collection does not exist here")

   let nft <- minter.mintNFT(name: name)
   collection.deposit(token: <- nft)

}

execute{
   log ("We just minted an NFT")
   }
} 



