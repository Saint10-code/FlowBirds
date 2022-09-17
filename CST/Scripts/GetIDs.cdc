import FlowBirds from "../Contracts/FlowBirds.cdc"
import NonFungibleToken from "../Contracts/NonFungibleToken.cdc"

pub fun main(user: Address): [UInt64] {


        let collection = getAccount(user).getCapability(FlowBirds.CollectionPublicPath)
                                .borrow<&FlowBirds.Collection{FlowBirds.CollectionPublic}>()
                                ?? panic ("A collection doesn't exist here.")

        return collection.getIDs()
}