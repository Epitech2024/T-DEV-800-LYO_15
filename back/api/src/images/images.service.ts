import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Image } from './images.model';

@Injectable()
export class ImagesService {
  constructor(
    @InjectModel('Image') private readonly imageModel: Model<Image>,
  ) {}
  /**
   * It creates a new image document, saves it to the database, and returns the id of the new document
   * @param {string} userId - The userId of the user who uploaded the image.
   * @param {string} name - The name of the image.
   * @param {Buffer} img - Buffer - this is the image that is being uploaded.
   * @param {Date} date - Date - The date the image was uploaded
   * @returns The id of the image that was saved.
   */

  async insertImage(userId: string, name: string, img: Buffer, date: Date) {
    console.log('newImage');
    const newImage = new this.imageModel({ userId, name, img, date });

    const result = await newImage.save();
    return result.id as string;
  }
  //papa44
  async deleteImage(userId: string, id: string) {
    const image = await this.findOneById(userId, id);
    if (typeof image === 'string') {
      return image;
    } else {
      return await image.delete();
    }
  }

  async findOneByUserId(userId: string): Promise<
    (Image & {
      _id: Types.ObjectId;
    })[]
  > {
    return await this.imageModel.find({ userId });
  }
  async findOneByUserIdOnlyIds(userId: string): Promise<string[]> {
    const images = await this.imageModel.find({ userId });
    return images.map((image) => {
      return image.id;
    });
  }

  async findOneById(userId: string, id: string): Promise<Image | string> {
    const image = await this.imageModel.findById(id);
    if (image.userId === userId) {
      return image;
    } else {
      return 'not authorized';
    }
  }
}
