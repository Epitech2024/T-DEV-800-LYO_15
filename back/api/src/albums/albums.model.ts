import * as mongoose from 'mongoose';

export const AlbumSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  name: { type: String, required: true },
  date: { type: Date, required: true },
  imgs: {
    type: Array,
    of: String,
    required: false,
  },
});

export interface Album extends mongoose.Document {
  id: string;
  userId: string;
  name: string;
  date: Date;
  imgs: string[];
}
