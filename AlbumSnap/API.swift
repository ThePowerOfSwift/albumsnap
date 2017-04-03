//  This file was automatically generated and should not be edited.

import Apollo

public final class CreatePhotoMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreatePhoto($albumId: ID!) {" +
    "  photo: createPhoto(albumId: $albumId) {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"

  public let albumId: GraphQLID

  public init(albumId: GraphQLID) {
    self.albumId = albumId
  }

  public var variables: GraphQLMap? {
    return ["albumId": albumId]
  }

  public struct Data: GraphQLMappable {
    public let photo: Photo?

    public init(reader: GraphQLResultReader) throws {
      photo = try reader.optionalValue(for: Field(responseName: "photo", fieldName: "createPhoto", arguments: ["albumId": reader.variables["albumId"]]))
    }

    public struct Photo: GraphQLMappable {
      public let __typename: String
      public let id: GraphQLID

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        id = try reader.value(for: Field(responseName: "id"))
      }
    }
  }
}

public final class SetPhotoFileMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation SetPhotoFile($fileId: ID!, $photoId: ID!) {" +
    "  payload: setPhotoFile(fileFileId: $fileId, photoPhotoId: $photoId) {" +
    "    __typename" +
    "    photo: photoPhoto {" +
    "      __typename" +
    "      id" +
    "    }" +
    "    file: fileFile {" +
    "      __typename" +
    "      id" +
    "      url" +
    "    }" +
    "  }" +
    "}"

  public let fileId: GraphQLID
  public let photoId: GraphQLID

  public init(fileId: GraphQLID, photoId: GraphQLID) {
    self.fileId = fileId
    self.photoId = photoId
  }

  public var variables: GraphQLMap? {
    return ["fileId": fileId, "photoId": photoId]
  }

  public struct Data: GraphQLMappable {
    public let payload: Payload?

    public init(reader: GraphQLResultReader) throws {
      payload = try reader.optionalValue(for: Field(responseName: "payload", fieldName: "setPhotoFile", arguments: ["fileFileId": reader.variables["fileId"], "photoPhotoId": reader.variables["photoId"]]))
    }

    public struct Payload: GraphQLMappable {
      public let __typename: String
      public let photo: Photo?
      public let file: File?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        photo = try reader.optionalValue(for: Field(responseName: "photo", fieldName: "photoPhoto"))
        file = try reader.optionalValue(for: Field(responseName: "file", fieldName: "fileFile"))
      }

      public struct Photo: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
        }
      }

      public struct File: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID
        public let url: String

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
          url = try reader.value(for: Field(responseName: "url"))
        }
      }
    }
  }
}

public final class AllAlbumsQuery: GraphQLQuery {
  public static let operationDefinition =
    "query AllAlbums {" +
    "  albums: allAlbums {" +
    "    __typename" +
    "    ...AlbumDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(AlbumDetails.fragmentDefinition).appending(PhotoDetails.fragmentDefinition)
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let albums: [Album]

    public init(reader: GraphQLResultReader) throws {
      albums = try reader.list(for: Field(responseName: "albums", fieldName: "allAlbums"))
    }

    public struct Album: GraphQLMappable {
      public let __typename: String

      public let fragments: Fragments

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))

        let albumDetails = try AlbumDetails(reader: reader)
        fragments = Fragments(albumDetails: albumDetails)
      }

      public struct Fragments {
        public let albumDetails: AlbumDetails
      }
    }
  }
}

public final class CreateAlbumMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateAlbum($name: String!) {" +
    "  album: createAlbum(name: $name) {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"

  public let name: String

  public init(name: String) {
    self.name = name
  }

  public var variables: GraphQLMap? {
    return ["name": name]
  }

  public struct Data: GraphQLMappable {
    public let album: Album?

    public init(reader: GraphQLResultReader) throws {
      album = try reader.optionalValue(for: Field(responseName: "album", fieldName: "createAlbum", arguments: ["name": reader.variables["name"]]))
    }

    public struct Album: GraphQLMappable {
      public let __typename: String
      public let id: GraphQLID

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        id = try reader.value(for: Field(responseName: "id"))
      }
    }
  }
}

public final class DeleteAlbumMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation DeleteAlbum($id: ID!) {" +
    "  album: deleteAlbum(id: $id) {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"

  public let id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLMappable {
    public let album: Album?

    public init(reader: GraphQLResultReader) throws {
      album = try reader.optionalValue(for: Field(responseName: "album", fieldName: "deleteAlbum", arguments: ["id": reader.variables["id"]]))
    }

    public struct Album: GraphQLMappable {
      public let __typename: String
      public let id: GraphQLID

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        id = try reader.value(for: Field(responseName: "id"))
      }
    }
  }
}

public final class AddPhotoToAlbumMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation AddPhotoToAlbum($photoId: ID!, $albumId: ID!) {" +
    "  payload: addToAlbumPhotos(photosPhotoId: $photoId, albumAlbumId: $albumId) {" +
    "    __typename" +
    "    album: albumAlbum {" +
    "      __typename" +
    "      id" +
    "    }" +
    "    photo: photosPhoto {" +
    "      __typename" +
    "      id" +
    "    }" +
    "  }" +
    "}"

  public let photoId: GraphQLID
  public let albumId: GraphQLID

  public init(photoId: GraphQLID, albumId: GraphQLID) {
    self.photoId = photoId
    self.albumId = albumId
  }

  public var variables: GraphQLMap? {
    return ["photoId": photoId, "albumId": albumId]
  }

  public struct Data: GraphQLMappable {
    public let payload: Payload?

    public init(reader: GraphQLResultReader) throws {
      payload = try reader.optionalValue(for: Field(responseName: "payload", fieldName: "addToAlbumPhotos", arguments: ["photosPhotoId": reader.variables["photoId"], "albumAlbumId": reader.variables["albumId"]]))
    }

    public struct Payload: GraphQLMappable {
      public let __typename: String
      public let album: Album?
      public let photo: Photo?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        album = try reader.optionalValue(for: Field(responseName: "album", fieldName: "albumAlbum"))
        photo = try reader.optionalValue(for: Field(responseName: "photo", fieldName: "photosPhoto"))
      }

      public struct Album: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
        }
      }

      public struct Photo: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
        }
      }
    }
  }
}

public final class RemovePhotoFromAlbumMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation RemovePhotoFromAlbum($photoId: ID!, $albumId: ID!) {" +
    "  payload: removeFromAlbumPhotos(photosPhotoId: $photoId, albumAlbumId: $albumId) {" +
    "    __typename" +
    "    album: albumAlbum {" +
    "      __typename" +
    "      id" +
    "    }" +
    "    photo: photosPhoto {" +
    "      __typename" +
    "      id" +
    "    }" +
    "  }" +
    "}"

  public let photoId: GraphQLID
  public let albumId: GraphQLID

  public init(photoId: GraphQLID, albumId: GraphQLID) {
    self.photoId = photoId
    self.albumId = albumId
  }

  public var variables: GraphQLMap? {
    return ["photoId": photoId, "albumId": albumId]
  }

  public struct Data: GraphQLMappable {
    public let payload: Payload?

    public init(reader: GraphQLResultReader) throws {
      payload = try reader.optionalValue(for: Field(responseName: "payload", fieldName: "removeFromAlbumPhotos", arguments: ["photosPhotoId": reader.variables["photoId"], "albumAlbumId": reader.variables["albumId"]]))
    }

    public struct Payload: GraphQLMappable {
      public let __typename: String
      public let album: Album?
      public let photo: Photo?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        album = try reader.optionalValue(for: Field(responseName: "album", fieldName: "albumAlbum"))
        photo = try reader.optionalValue(for: Field(responseName: "photo", fieldName: "photosPhoto"))
      }

      public struct Album: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
        }
      }

      public struct Photo: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
        }
      }
    }
  }
}

public final class CreateUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateUser($name: String!, $email: String!, $password: String!) {" +
    "  createUser(name: $name, authProvider: {email: {email: $email, password: $password}}) {" +
    "    __typename" +
    "    ...UserDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(UserDetails.fragmentDefinition)

  public let name: String
  public let email: String
  public let password: String

  public init(name: String, email: String, password: String) {
    self.name = name
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["name": name, "email": email, "password": password]
  }

  public struct Data: GraphQLMappable {
    public let createUser: CreateUser?

    public init(reader: GraphQLResultReader) throws {
      createUser = try reader.optionalValue(for: Field(responseName: "createUser", arguments: ["name": reader.variables["name"], "authProvider": ["email": ["email": reader.variables["email"], "password": reader.variables["password"]]]]))
    }

    public struct CreateUser: GraphQLMappable {
      public let __typename: String

      public let fragments: Fragments

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))

        let userDetails = try UserDetails(reader: reader)
        fragments = Fragments(userDetails: userDetails)
      }

      public struct Fragments {
        public let userDetails: UserDetails
      }
    }
  }
}

public final class SignInUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation SignInUser($email: String!, $password: String!) {" +
    "  signinUser(email: {email: $email, password: $password}) {" +
    "    __typename" +
    "    token" +
    "    user {" +
    "      __typename" +
    "      ...UserDetails" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(UserDetails.fragmentDefinition)

  public let email: String
  public let password: String

  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password]
  }

  public struct Data: GraphQLMappable {
    public let signinUser: SigninUser

    public init(reader: GraphQLResultReader) throws {
      signinUser = try reader.value(for: Field(responseName: "signinUser", arguments: ["email": ["email": reader.variables["email"], "password": reader.variables["password"]]]))
    }

    public struct SigninUser: GraphQLMappable {
      public let __typename: String
      public let token: String?
      public let user: User?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        token = try reader.optionalValue(for: Field(responseName: "token"))
        user = try reader.optionalValue(for: Field(responseName: "user"))
      }

      public struct User: GraphQLMappable {
        public let __typename: String

        public let fragments: Fragments

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))

          let userDetails = try UserDetails(reader: reader)
          fragments = Fragments(userDetails: userDetails)
        }

        public struct Fragments {
          public let userDetails: UserDetails
        }
      }
    }
  }
}

public final class AllPhotosQuery: GraphQLQuery {
  public static let operationDefinition =
    "query AllPhotos($last: Int) {" +
    "  photos: allPhotos(last: $last) {" +
    "    __typename" +
    "    ...PhotoDetails" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(PhotoDetails.fragmentDefinition)

  public let last: Int?

  public init(last: Int? = nil) {
    self.last = last
  }

  public var variables: GraphQLMap? {
    return ["last": last]
  }

  public struct Data: GraphQLMappable {
    public let photos: [Photo]

    public init(reader: GraphQLResultReader) throws {
      photos = try reader.list(for: Field(responseName: "photos", fieldName: "allPhotos", arguments: ["last": reader.variables["last"]]))
    }

    public struct Photo: GraphQLMappable {
      public let __typename: String

      public let fragments: Fragments

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))

        let photoDetails = try PhotoDetails(reader: reader)
        fragments = Fragments(photoDetails: photoDetails)
      }

      public struct Fragments {
        public let photoDetails: PhotoDetails
      }
    }
  }
}

public struct AlbumDetails: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment AlbumDetails on Album {" +
    "  __typename" +
    "  id" +
    "  name" +
    "  descript" +
    "  createdAt" +
    "  photos {" +
    "    __typename" +
    "    ...PhotoDetails" +
    "  }" +
    "}"

  public static let possibleTypes = ["Album"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String?
  public let descript: String?
  public let createdAt: String?
  public let photos: [Photo]?

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.optionalValue(for: Field(responseName: "name"))
    descript = try reader.optionalValue(for: Field(responseName: "descript"))
    createdAt = try reader.optionalValue(for: Field(responseName: "createdAt"))
    photos = try reader.optionalList(for: Field(responseName: "photos"))
  }

  public struct Photo: GraphQLMappable {
    public let __typename: String

    public let fragments: Fragments

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))

      let photoDetails = try PhotoDetails(reader: reader)
      fragments = Fragments(photoDetails: photoDetails)
    }

    public struct Fragments {
      public let photoDetails: PhotoDetails
    }
  }
}

public struct UserDetails: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment UserDetails on User {" +
    "  __typename" +
    "  id" +
    "  email" +
    "  name" +
    "  createdAt" +
    "  albums {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"

  public static let possibleTypes = ["User"]

  public let __typename: String
  public let id: GraphQLID
  public let email: String?
  public let name: String
  public let createdAt: String?
  public let albums: [Album]?

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    email = try reader.optionalValue(for: Field(responseName: "email"))
    name = try reader.value(for: Field(responseName: "name"))
    createdAt = try reader.optionalValue(for: Field(responseName: "createdAt"))
    albums = try reader.optionalList(for: Field(responseName: "albums"))
  }

  public struct Album: GraphQLMappable {
    public let __typename: String
    public let id: GraphQLID

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))
      id = try reader.value(for: Field(responseName: "id"))
    }
  }
}

public struct PhotoDetails: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment PhotoDetails on Photo {" +
    "  __typename" +
    "  id" +
    "  name" +
    "  caption" +
    "  createdAt" +
    "  file {" +
    "    __typename" +
    "    id" +
    "    url" +
    "  }" +
    "  album {" +
    "    __typename" +
    "    id" +
    "    name" +
    "  }" +
    "}"

  public static let possibleTypes = ["Photo"]

  public let __typename: String
  public let id: GraphQLID
  public let name: String?
  public let caption: String?
  public let createdAt: String
  public let file: File?
  public let album: Album?

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    name = try reader.optionalValue(for: Field(responseName: "name"))
    caption = try reader.optionalValue(for: Field(responseName: "caption"))
    createdAt = try reader.value(for: Field(responseName: "createdAt"))
    file = try reader.optionalValue(for: Field(responseName: "file"))
    album = try reader.optionalValue(for: Field(responseName: "album"))
  }

  public struct File: GraphQLMappable {
    public let __typename: String
    public let id: GraphQLID
    public let url: String

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))
      id = try reader.value(for: Field(responseName: "id"))
      url = try reader.value(for: Field(responseName: "url"))
    }
  }

  public struct Album: GraphQLMappable {
    public let __typename: String
    public let id: GraphQLID
    public let name: String?

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))
      id = try reader.value(for: Field(responseName: "id"))
      name = try reader.optionalValue(for: Field(responseName: "name"))
    }
  }
}