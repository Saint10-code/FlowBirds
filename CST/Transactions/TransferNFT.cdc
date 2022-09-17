import FlowBirds from "../Contracts/FlowBirds.cdc"

transaction(receipient: Address, id: UInt64) {

prepare(signer: AuthAccount){
   let signerCollection = signer.borrow<&FlowBirds.Collection>(from: FlowBirds.CollectionStoragePath)
                    ?? panic("The signer does not have a collection setup")

   let receipientCollection = getAccount(receipient).getCapability(FlowBirds.CollectionPublicPath)
                                    .borrow<&FlowBirds.Collection{FlowBirds.CollectionPublic}>()
                                    ?? panic("A linked collection does not exist here")

   receipientCollection.deposit(token: <- signerCollection.withdraw(withdrawID: id))
}

execute{
   log ("We just transferred an NFT")
   }
} 

