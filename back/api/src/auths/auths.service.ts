import { Injectable } from '@nestjs/common';
import { UsersService } from '../users/users.service';
import { User } from '../users/users.model';
import RefreshToken from './refresh_tokens';
import { sign, verify } from 'jsonwebtoken';
import * as bcrypt from 'bcrypt';
import { Inject } from '@nestjs/common/decorators';
import { forwardRef } from '@nestjs/common/utils';

@Injectable()
export class AuthsService {
  //put thess in the db
  private refreshTokens: RefreshToken[] = [];

  constructor(
    @Inject(forwardRef(() => UsersService))
    private readonly userService: UsersService,
  ) {}

  private retrieveRefreshToken(
    refreshStr: string,
  ): Promise<RefreshToken | undefined> {
    try {
      const decoded = verify(refreshStr, process.env.REFRESH_SECRET);
      if (typeof decoded === 'string') {
        return undefined;
      }
      return Promise.resolve(
        this.refreshTokens.find((token) => token.id === decoded.id),
      );
    } catch (e) {
      return undefined;
    }
  }

  async refresh(refreshStr: string): Promise<string | undefined> {
    const refreshToken = await this.retrieveRefreshToken(refreshStr);
    if (!refreshToken) {
      return undefined;
    }
    const user = await this.userService.findOne(refreshToken.userId);
    if (!user) {
      return undefined;
    }
    const accessToken = { userId: refreshToken.userId };
    return sign(accessToken, process.env.ACCESS_SECRET, { expiresIn: '15m' });
  }

  async newRefreshAndAccessToken(
    user: User,
    values?: { userAgent: string; ipAddress: string },
  ): Promise<{ accessToken: string; refreshToken: string }> {
    const userId = (await this.userService.findOne(user.username)).id;
    const existingLogin = this.refreshTokens.find((r) => r.userId === userId);

    const refreshObject = new RefreshToken({
      id:
        this.refreshTokens.length === 0
          ? 0
          : !existingLogin
          ? this.refreshTokens[this.refreshTokens.length - 1].id + 1
          : existingLogin.id,
      ...values,
      userId: user.id,
    });
    if (!existingLogin) {
      this.refreshTokens.push(refreshObject);
    }
    console.log(this.refreshTokens);

    return {
      refreshToken: refreshObject.sign(),
      accessToken: sign({ userId: user.id }, process.env.ACCESS_TOKEN, {
        expiresIn: '1y',
      }),
    };
  }

  async login(
    username: string,
    password: string,
    values: { userAgent: string; ipAddress: string },
  ): Promise<{ accessToken: string; refreshToken: string } | string> {
    const user = await this.userService.findOne(username);
    if (!user) {
      return 'username does not exist';
    }
    if ((await bcrypt.compare(password, user.password)) == true) {
      const tokens = this.newRefreshAndAccessToken(user, values);
      return tokens;
    } else {
      console.error('failed to authentificate');
      return 'incorrect password';
    }
  }

  async logout(refreshStr): Promise<any> {
    const refreshToken = await this.retrieveRefreshToken(refreshStr);
    if (!refreshToken) {
      return;
    }
    // delete refreshtoken from db
    this.refreshTokens = this.refreshTokens.filter(
      (refreshToken) => refreshToken.id !== refreshToken.id,
    );
    return true;
  }
}
