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
    const newImage = new this.imageModel({ userId, name, img, date });
    const result = await newImage.save();
    return result.id as string;
  }
  //papa44
  async deleteImage(id: string) {
    // this.albumService.
    return await this.imageModel.findByIdAndDelete(id);
  }

  async findOneByUserId(userId: string): Promise<
    (Image & {
      _id: Types.ObjectId;
    })[]
  > {
    return await this.imageModel.find({ userId });
  }

  async findOneById(id: string): Promise<Image> {
    return await this.imageModel.findById(id);
  }
}
