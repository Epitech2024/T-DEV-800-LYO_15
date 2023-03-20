import { Body, Controller, Delete, Ip, Post, Req } from '@nestjs/common';
import { AuthsService } from './auths.service';
import RefreshTokenDto from './dto/refresh-token.dto';
import { LoginDto } from './dto/login.dto';
import { Request } from 'express';

@Controller('auths')
export class AuthsController {
  constructor(private readonly authService: AuthsService) {}

  @Post('login')
  async login(
    @Req() request: Request,
    @Ip() ip: string,
    @Body() body: LoginDto,
  ) {
    const tokens = await this.authService.login(body.username, body.password, {
      ipAddress: ip,
      userAgent: request.headers['user-agent'],
    });
    return tokens;
  }

  @Post('refresh')
  async refreshToken(@Body() body: RefreshTokenDto) {
    return this.authService.refresh(body.refreshToken);
  }

  @Delete('logout')
  async logout(@Body() body: RefreshTokenDto) {
    return this.authService.logout(body.refreshToken);
  }
}
