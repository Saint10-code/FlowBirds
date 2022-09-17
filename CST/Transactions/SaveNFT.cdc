
import FlowBirds from "../Contracts/FlowBirds.cdc"
import NonFungibleToken from "../Contracts/NonFungibleToken.cdc"

transaction {


    prepare(signer: AuthAccount){
    let collection <- FlowBirds.createEmptyCollection()
    signer.save(<- collection, to: FlowBirds.CollectionStoragePath)
    signer.link<&FlowBirds.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, FlowBirds.CollectionPublic}>(FlowBirds.CollectionPublicPath, target: FlowBirds.CollectionStoragePath)}
    
    execute{
    log("We made a new collection!")
    }
    
    }


