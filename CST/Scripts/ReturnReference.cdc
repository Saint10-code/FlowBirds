import FlowBirds from "../Contracts/FlowBirds.cdc"
import NonFungibleToken from "../Contracts/NonFungibleToken.cdc"

pub fun main(user: Address, id: UInt64): &NonFungibleToken.NFT{


        let collection = getAccount(user).getCapability(FlowBirds.CollectionPublicPath)
                                .borrow<&FlowBirds.Collection{FlowBirds.CollectionPublic}>()
                                ?? panic ("A collection doesn't exist here.")

        let nftRef: &FlowBirds.NFT = collection.borrowFlowBirdsNFT(id: id)

        log (nftRef.name)
        return nftRef 
}
