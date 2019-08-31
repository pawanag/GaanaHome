//
//  Constant.swift
//  Gaana
//
//  Created by Pawan Agarwal on 31/08/19.
//  Copyright © 2019 Pawan. All rights reserved.
//

import Foundation

typealias GAStoryBoardConstants = GAConstants.GAStoryBoardConstants
typealias GAControllerConstants = GAConstants.GAControllerConstants
typealias GACellConstants = GAConstants.GACellConstants
typealias GAAlertConstants = GAConstants.GAAlertConstants
typealias GAImageNameConstants = GAConstants.GAImageNameConstants
//typealias JRNearByNumberConstants = JRNearByConstants.NearByNumberConstants
//typealias JRNearByErrorCode = JRNearByConstants.ErrorCode


struct GAConstants
{
    //StoryBoard Identifiers
    struct GAStoryBoardConstants
    {
        static let StoryboardIdentifier: String = "Main"
    }

    struct URL {
        static let HomePageURL = "https://demo3033278.mockable.io/gaanaDriveTest"
    }
    
    struct ModelKeys {
        static let Tracks = "tracks"
        static let Sections = "sections"
        static let Name = "name"
    }
    struct GAControllerConstants {
        static let PlaylistDetail = "GAPlaylistDetailVC"
        static let PlaylistListing = "GAPlaylistListingVC"
        static let AddToPlaylist = "GAAddToPlaylistVC"
        static let SongsListingVC = "GASongsListingVC"
    }
    
    struct GACellConstants {
        static let ListingTableViewCell = "GAListingTableViewCell"
        static let HeaderViewCell = "GAHeaderTableViewCell"
        static let AddToPlaylistTableViewCell = "GAAddToPlaylistTableViewCell"
        static let FeedTableViewCell = "GAFeedTableViewCell"
        static let FeedCollectionViewCell = "GAFeedCollectionViewCell"
    }
    
    struct GAAlertConstants {
        static let Success = "Success"
        static let Save = "Save"
        static let Cancel = "Cancel"
        static let NewPlaylistName = "New Playlist Name"
        static let EnterPlaylisName = "Enter a playlist name"
        static let PlaylistNamePlaceholder = "Playlist Name"
        static let Ok = "Ok"
        static let SureDeletePlaylist = "Do you want to delete this playlist?"
        static let Error = "Error"
        static let SongAdded = "Song Added Successfully"
        static let Oops = "Oops!"
        static let NoSongsInPlaylist = "There are no songs in this Playlist, Please select another Playlist"
    }
    
    struct GAImageNameConstants {
        static let Add = "add"
        static let CheckBoxUnSelected = "checkBoxUnSelected"
        static let CheckBoxSelected = "checkBoxSelected"
        static let AddToPlaylist = "addToPlaylist"
        static let Delete = "delete"
    }
    
}

