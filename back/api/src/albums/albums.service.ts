import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { ImagesService } from 'src/images/images.service';
import { Album } from './albums.model';

@Injectable()
export class AlbumsService {
  constructor(
    @InjectModel('Album') private readonly AlbumModel: Model<Album>,
    private imageService: ImagesService,
  ) {}

  /**
   * It creates a new album, saves it to the database, and returns the id of the new album
   * @param {string} userId - the id of the user who created the album
   * @param {string} name - string, imgs: string[], date: Date
   * @param {string[]} imgs - string[]
   * @param {Date} date - Date
   * @returns The id of the album that was created.
   */
  async createAlbum(userId: string, name: string, imgs: string[], date: Date) {
    const checkAlbum = await this.AlbumModel.findOne({ name: name });
    if (checkAlbum) {
      return "album's name already exists";
    } else {
      const newAlbum = new this.AlbumModel({ userId, name, imgs, date });
      console.log(newAlbum);

      const result = await newAlbum.save();
      return result.id as string;
    }
  }
  /**
   * It finds all albums that belong to a user, and then for each album, it finds all the images that
   * belong to that album
   * @param {string} userId - string
   * @returns An array of Albums with the images property added to each album.
   */

  async findOneByUserId(userId: string): Promise<
    (Album & {
      _id: Types.ObjectId;
    })[]
  > {
    const Albums = await this.AlbumModel.find({ userId });
    for (const album of Albums) {
      album.toObject();
      const images = await Promise.all(
        album.imgs.map(async (img: string) => {
          return await this.imageService.findOneById(img);
        }),
      );
      Object.defineProperty(album, 'images', { value: images });
    }
    return Albums;
  }
  /**
   * It takes an album id and a new name, finds the album by id, sets the name, saves the album, and
   * returns the id
   * @param {string} id - The id of the album to rename
   * @param {string} name - The name of the album
   * @returns The id of the album that was renamed.
   */
  async renameAlbum(id: string, name: string) {
    const Album = await this.AlbumModel.findById(id);
    Album.name = name;
    const result = await Album.save();
    return result.id as string;
  }

  /**
   * It adds an image to an album.
   * @param {string} id - the id of the album
   * @param {string} img - string - the image to add to the album
   * @returns The id of the album that was updated.
   */
  async addImageToAlbum(id: string, img: string) {
    const Album = await this.AlbumModel.findById(id);
    Album.imgs.push(img);
    const result = await Album.save();
    return result.id as string;
  }

  /**
   * It removes an image from an album.
   * @param {string} id - the id of the album
   * @param {string} imageId - the id of the image you want to remove from the album
   * @returns The id of the album that was updated.
   */
  async removeImageFromAlbum(id: string, imageId: string) {
    const Album = await this.AlbumModel.findById(id);
    const imageArrayId = Album.imgs.findIndex((v) => v === imageId);
    if (imageArrayId >= 0) {
      Album.imgs.splice(imageArrayId, 1);
    }
    console.log(Album.imgs);
    const result = await Album.save();
    return result.id as string;
  }
  /**
   * It finds all the albums, then for each album, it finds the index of the image in the album's images
   * array, then it removes the image from the album's images array
   * @param {string} imageId - the id of the image to be deleted
   */
  async deleteImageFromAllAlbums(imageId: string) {
    const albums = await this.AlbumModel.find();
    albums.forEach((Album) => {
      const imageArrayId = Album.imgs.findIndex((v) => v === imageId);
      if (imageArrayId >= 0) {
        Album.imgs.splice(imageArrayId, 1);
      }
      console.log(Album.imgs);
    });
  }
  /**
   * It finds an album by its id and deletes it
   * @param {string} id - string - The id of the album to delete.
   * @returns The deleted album
   */

  async deleteAlbum(id: string) {
    const Album = await this.AlbumModel.findByIdAndDelete(id);
    console.log(Album);

    return Album;
  }
}
