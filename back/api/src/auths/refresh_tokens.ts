import { sign } from 'jsonwebtoken';
import { load } from 'ts-dotenv';

const env = load({
    REFRESH_SECRET: String,
});

class RefreshToken {
  constructor(init?: Partial<RefreshToken>) {
    Object.assign(this, init);
  }

  id: number;
  userId: string;
  userAgent: string;
  ipAddress: string;

  sign(): string {
    return sign({ ...this }, env.REFRESH_SECRET);
  }
}

export default RefreshToken;