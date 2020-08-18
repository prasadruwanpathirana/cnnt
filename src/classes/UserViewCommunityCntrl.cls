//Author : Omsairam
//Description: Om sai ram can help us to make this success...+
public class UserViewCommunityCntrl {
    
    public UserViewCommunityCntrl(){
        ConnectApi.FeedElementPage fep = ConnectApi.ChatterFeeds.getFeedElementsFromFeed(Network.getNetworkId(), ConnectApi.FeedType.Record, '0052w00000533BZAAY');
        system.debug('fep::'+fep);
    }
    
}