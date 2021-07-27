const redisClient1 = require('redis').createClient(6379, 'redis');

const Redlock = require('redlock');

const redlock = new Redlock(
    [redisClient1],
    {
        driftFactor: 0.01, // multiplied by lock ttl to determine drift time
        retryCount:  10,
        retryDelay:  200, // time in ms
        retryJitter:  200 // time in ms
    }
);

redlock.on('clientError', function(err) {
    console.error('A redis error has occurred:', err);
});

// from: https://stackoverflow.com/a/12646864
function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
}

const DAY_IN_MILLISECONDS = 1000 * 60 * 60 * 24;

async function createAuctionResults(auction) {
    console.log("createAuctionResults " + auction.id);
    const parkCount = auction.get("parkCount");

    const query = new Parse.Query("Offer");
    query.equalTo("auction", auction);
    query.descending("price");
    query.skip(parkCount-1);

    const minimumAcceptedOffer = await query.first({useMasterKey: true});
    const minimumAcceptedPrice = (minimumAcceptedOffer)?minimumAcceptedOffer.get("price"):0;

    const acceptedOffersQuery = new Parse.Query("Offer");
    acceptedOffersQuery.equalTo("auction", auction);
    acceptedOffersQuery.greaterThanOrEqualTo("price", minimumAcceptedPrice);
    const acceptedOffers = await acceptedOffersQuery.find({useMasterKey: true});
    const numbers = [];
    for (let i = 1; i <= parkCount; i++) {
        numbers.push(i);
    }
    shuffleArray(numbers);
    shuffleArray(acceptedOffers);

    for(let i = 0; i < acceptedOffers.length && i < parkCount; i++) {
        const number = numbers[i];
        const offer = acceptedOffers[i];
        const auctionResult = new Parse.Object("AuctionResult");
        auctionResult.set("offer", offer);
        auctionResult.set("number", number);
        auctionResult.set("auction", auction);
        auctionResult.set("user", offer.get("user"));
        auctionResult.set("price", minimumAcceptedPrice);
        auctionResult.save(null, {useMasterKey: true})
    }
}

async function makeAuctionInProgress(auction) {
    console.log("makeAuctionInProgress " + auction.id);
    await createAuctionResults(auction);
    auction.set("status", 'inprogress');
    auction.save(null, {useMasterKey: true});
}

async function finilizeAuction(auction) {
    console.log("finilizeAuction " + auction.id);
    auction.set("status", 'finished');
    await auction.save(null, {useMasterKey: true});
}

async function createNewAuction(settings) {
    console.log("createNewAuction");
    const auction = new Parse.Object("Auction");
    auction.set('minimumPrice', settings.minimumPrice);
    auction.set('parkCount', settings.parkCount);
    auction.set('status', 'new');
    auction.set('endedAt', new Date(new Date().getTime() + (settings.auctionNewDays + settings.auctionInprogressDays) * DAY_IN_MILLISECONDS));
    await auction.save(null, {useMasterKey: true});
    return auction;
}

async function updateParkPlaces(auction, settings) {
    const parkCount = (auction)?auction.get("parkCount"):settings.parkCount;

    console.log("updateParkPlaces " + (auction?auction.id:'-') + "  parkCount: " + parkCount);
    for(let i = 1; i <= parkCount; i++) {
        const query = new Parse.Query("ParkPlace");
        query.equalTo("number", i);
        const result = await query.find({useMasterKey: true});
        let parkPlace;
        if (result.length == 0) {
            parkPlace = new Parse.Object("ParkPlace");

            parkPlace.set("number", i);
        } else {
            parkPlace = result[0];
        }

        let parkOwner = null;
        if (auction !== null) {
            const acutionResultQuery = new Parse.Query("AuctionResult");
            acutionResultQuery.equalTo("auction", auction);
            acutionResultQuery.equalTo("number", i);
            acutionResultQuery.include("user");
            const acutionResults = await acutionResultQuery.find({useMasterKey: true});
            if (acutionResults.length) {
                parkOwner = acutionResults[0].get("user");
            }
        }
        parkPlace.set("owner", parkOwner);
        parkPlace.set("isActive", true);
        await parkPlace.save(null, {useMasterKey: true});

    }

    // Deactivate other parkPlaces:
    {
        const query = new Parse.Query("ParkPlace");
        query.greaterThan("number", parkCount);
        const result = await query.find({useMasterKey: true});

        for(let parkPlace of result) {
            parkPlace.set("isActive", false);
            parkPlace.set("owner", null);
            await parkPlace.save(null, {useMasterKey: true});
        }

    }
}

Parse.Cloud.job('scheduleAuctions', async (request) => {
    console.log();
    console.log();
    console.log("=========================================");
    console.log('scheduleAuctions');
    console.log();
    // TODO: ACLs
    // ​const { params, headers, log, message } = request;

    const settingsQuery = new Parse.Query("Settings");
    const settingsObject = await settingsQuery.first({useMasterKey: true});
    const settings = {
        minimumPrice: settingsObject.get("minimumPrice"),
        parkCount: settingsObject.get("parkCount"),
        auctionNewDays: settingsObject.get("auctionNewDays"),
        auctionInprogressDays: settingsObject.get("auctionInprogressDays"),
    };
    let newAuction = null;
    // If there is new auction,
    {
        const query = new Parse.Query("Auction");
        query.equalTo('status', 'new');
        const result = await query.find({useMasterKey: true});

        if (result.length > 0) {
            if (result.length > 1) {
                console.warn("There are more than one Auction with status new! something is wrong!");
                for(let i = 1; i < result.length; i++) {
                    result[i].set("status", "conflicted");
                    await result[i].save(null, {useMasterKey: true});
                }
            }
            const auction = result[0];
            newAuction = auction;
            const auctionAgeInDays = Math.round((new Date() - auction.get('createdAt')) / DAY_IN_MILLISECONDS);

            console.log("new_auction.id: " + auction.id + " age: " + auctionAgeInDays);
        }
    }
    // finilize inprogress auction
    let inProgressAuction = null;
    {
        const query = new Parse.Query("Auction");
        query.equalTo('status', 'inprogress');
        const result = await query.find({useMasterKey: true});

        if (result.length > 0) {
            if (result.length > 1) {
                console.warn("There are more than one Auction with status new! something is wrong!");
                for(let i = 1; i < result.length; i++) {
                    result[i].set("status", "conflicted");
                    await result[i].save(null, {useMasterKey: true});
                }
            }
            const auction = result[0];
            hasAnyNewInprogressAuction = true;
            inProgressAuction = auction;
            const auctionAgeInDays = Math.round((new Date() - auction.get('createdAt')) / DAY_IN_MILLISECONDS);

            console.log("inprogress_auction.id: " + auction.id + " age: " + auctionAgeInDays);

            // if (auctionAgeInDays >= settings.auctionNewDays + settings.auctionInprogressDays) {
            //     finilizeAuction(auction);
            // }
            if (auctionAgeInDays >= settings.auctionInprogressDays) {
                createNewAuction(settings);
            }
        }
    }


    if (newAuction) {
        const auctionAgeInDays = Math.round((new Date() - newAuction.get('createdAt')) / DAY_IN_MILLISECONDS);
        if (auctionAgeInDays >= settings.auctionNewDays) {
            makeAuctionInProgress(newAuction);
            if (inProgressAuction) {
                finilizeAuction(inProgressAuction);
                inProgressAuction = newAuction;
            }
        }
    }

    if (!newAuction && !inProgressAuction) {
        console.log("initialize schedule");
        createNewAuction(settings);
    }

    updateParkPlaces(inProgressAuction, settings);
});


Parse.Cloud.beforeSave("Offer", async (request) => {
    // if(!request.user) {
    //     throw 'برای ثبت پیشنهاد باید وارد شده باشید.';
    // }


    const offer = request.object;

    // a user can only make one offer.
    const lock = await redlock.lock('offer:' + request.user.id, 1000);

    if (!offer.get("auction")) {
        const query = new Parse.Query("Auction");
        query.equalTo('status', 'new');
        const auction = await query.first({useMasterKey: true});
        if (!auction) {
            throw 'مزائده‌ی بازی برای شرکت وجود ندارد.';
        }
        offer.set('auction', auction);
    }

    if (offer.get("price") < offer.get("auction").get('minimumPrice')) {
        throw 'حداقل مقدار پیشنهاد باید ' + offer.get("auction").get('minimumPrice') + 'تومان باشد.';
    }

    if(request.user) {
        offer.set('user', request.user);

        const acl = new Parse.ACL();
        acl.setPublicReadAccess(false);
        acl.setPublicWriteAccess(false);
        acl.setReadAccess("Admin", true);
        acl.setWriteAccess("Admin", true);
        acl.setReadAccess(request.user, true);
        offer.setACL(acl);

    }


    await lock.unlock();
}, {
    requireUser: true,
});


Parse.Cloud.define('isAdmin', async (request) => {
    if (!request.user) {
        throw 'باید لاگین باشید.';
    }
    const query = new Parse.Query(Parse.Role);
    query.equalTo('users', request.user);
    query.equalTo('name', 'Admin');
    return await query.count();
});

Parse.Cloud.define('myParkPlace', async (request) => {
    const query = new Parse.Query("ParkPlace");
    query.equalTo('owner', request.user);
    query.equalTo('isActive', true);
    const parkPlace = await query.first({useMasterKey: true});
    return parkPlace;
}, {
    requireUser: true,
});

Parse.Cloud.define('unReserveParkPlace', async (request) => {
    const query = new Parse.Query("ParkPlace");
    query.equalTo('owner', request.user);
    query.equalTo('isActive', true);
    const parkPlace = await query.first({useMasterKey: true});
    if(!parkPlace) {
        throw 'شما پارکینگی را رزرو ندارید.';
    }
    const lock = await redlock.lock('park:' + parkPlace.get('number'), 5000);
    parkPlace.set("owner", null);
    parkPlace.save(null, {useMasterKey: true});
    await lock.unlock();
    return 'ok';
}, {
    requireUser: true,
});

Parse.Cloud.define('reserveParkPlace', async (request) => {
    const number = request.params.number;
    const lock = await redlock.lock('park:' + number, 5000);
    const query = new Parse.Query("ParkPlace");
    query.equalTo('owner', null);
    query.equalTo('number', number);
    query.equalTo('isActive', true);
    const parkPlace = await query.first({useMasterKey: true});
    if(!parkPlace) {
        throw 'شخصی پیش از شما اینجا را رزرو کرده است.';
    }
    parkPlace.set("owner", request.user);
    parkPlace.save(null, {useMasterKey: true});
    await lock.unlock();
    return 'ok';
}, {
    requireUser: true,
    fields: {
      required: true,
    }
});

Parse.Cloud.beforeLogin(async request => {
    const { object: user }  = request;
    if(!user.get('isActive')) {
        throw 'متاسفانه حساب کاربری شما غیر فعال شده است.';
    }
});