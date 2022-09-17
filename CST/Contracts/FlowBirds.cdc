
import NonFungibleToken from "./Contracts/NonFungibleToken.cdc"

pub contract FlowBirds: NonFungibleToken{

    pub var totalSupply: UInt64
    pub let CollectionStoragePath: StoragePath
    pub let CollectionPublicPath: PublicPath
    pub let NFTMinterStorage: StoragePath

    pub event ContractInitialized()
    pub event Withdraw(id: UInt64, from: Address?)
    pub event Deposit(id: UInt64, to: Address?)
    pub event Minted(id: UInt64, name: String)


        pub resource NFT: NonFungibleToken.INFT {
            pub let id: UInt64 
            pub let name: String 


            init(_name: String){
                self.id = self.uuid 
                self.name = _name 
                emit Minted (id: self.id, name: self.name)
                
                FlowBirds.totalSupply = FlowBirds.totalSupply + 1
            }        
        }

        pub resource interface CollectionPublic{
                pub fun deposit(token: @NonFungibleToken.NFT)
                pub fun getIDs(): [UInt64]
                pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT
                pub fun borrowFlowBirdsNFT(id: UInt64): &NFT
                 
        }

            pub resource Collection: NonFungibleToken.Provider, NonFungibleToken.Receiver, NonFungibleToken.CollectionPublic, CollectionPublic{
              
                pub var ownedNFTs: @{UInt64: NonFungibleToken.NFT}

                pub fun deposit(token: @NonFungibleToken.NFT){ 
                    let nft <- token as! @NFT
                    emit Deposit(id: nft.id, to: self.owner?.address)
                    self.ownedNFTs[nft.id] <-! nft
                }
                pub fun withdraw(withdrawID: UInt64): @NonFungibleToken.NFT {
                    let nft <- self.ownedNFTs.remove(key: withdrawID) ?? panic("No NFT here")
                    emit Withdraw(id: withdrawID, from: self.owner?.address)
                    return <- nft
                }
                pub fun getIDs(): [UInt64]{
                return self.ownedNFTs.keys
                }
                pub fun borrowNFT(id: UInt64): &NonFungibleToken.NFT {
                    return (&self.ownedNFTs[id] as &NonFungibleToken.NFT?)!
                }
                
                pub fun borrowFlowBirdsNFT(id: UInt64): &NFT {
                    let ref = (&self.ownedNFTs[id] as auth &NonFungibleToken.NFT?)!
                    return ref as! &NFT
                    }

                init(){
                self.ownedNFTs <- {}
                }

                destroy(){
                destroy self.ownedNFTs
                }
            }
        
        pub resource NFTMinter{
            pub fun mintNFT(name: String): @NFT{
            return <- create NFT (_name: name)
            }
        }

         pub fun createEmptyCollection(): @NonFungibleToken.Collection {
            return <- create Collection()
        }


        init(){
        self.totalSupply = 0 
        self.CollectionStoragePath = /storage/FlowBirdsNFTStorage
        self.CollectionPublicPath = /public/FlowBirdsNFTPublic
        self.NFTMinterStorage = /storage/NFTMinterStorage

        self.account.save(<- create NFTMinter(), to: /storage/NFTMinterStorage)
        emit ContractInitialized()
        }
}
 

