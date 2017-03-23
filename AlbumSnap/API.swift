//  This file was automatically generated and should not be edited.

import Apollo

public final class AllPhotosQuery: GraphQLQuery {
  public static let operationDefinition =
    "query AllPhotos {" +
    "  photos: allPhotos {" +
    "    __typename" +
    "    id" +
    "  }" +
    "}"
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let photos: [Photo]

    public init(reader: GraphQLResultReader) throws {
      photos = try reader.list(for: Field(responseName: "photos", fieldName: "allPhotos"))
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
    "    id" +
    "    name" +
    "    photos {" +
    "      __typename" +
    "      id" +
    "      caption" +
    "    }" +
    "  }" +
    "}"
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let albums: [Album]

    public init(reader: GraphQLResultReader) throws {
      albums = try reader.list(for: Field(responseName: "albums", fieldName: "allAlbums"))
    }

    public struct Album: GraphQLMappable {
      public let __typename: String
      public let id: GraphQLID
      public let name: String?
      public let photos: [Photo]?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        id = try reader.value(for: Field(responseName: "id"))
        name = try reader.optionalValue(for: Field(responseName: "name"))
        photos = try reader.optionalList(for: Field(responseName: "photos"))
      }

      public struct Photo: GraphQLMappable {
        public let __typename: String
        public let id: GraphQLID
        public let caption: String?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
          caption = try reader.optionalValue(for: Field(responseName: "caption"))
        }
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