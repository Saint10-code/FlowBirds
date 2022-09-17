import FlowBirds from 0x03cb35230765e243

pub fun main(account: Address): Bool{
    let account = getAccount(account)
    let FlowBirdsCollectionPublicPathCap = account.getCapability<&FlowBirds.Collection{FlowBirds.CollectionPublic}>(FlowBirds.CollectionPublicPath)
    return  FlowBirdsCollectionPublicPathCap.check()
}

