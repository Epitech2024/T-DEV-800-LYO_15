import * as mongoose from 'mongoose';

export const ImageSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  name: { type: String, required: true },
  date: { type: Date, required: true },
  img: {
    type: Buffer,
    required: true,
  },
});

export interface Image extends mongoose.Document {
  id: string;
  userId: string;
  name: string;
  date: Date;
  img: Buffer;
}
