import { Module } from '@nestjs/common';
import { AuthsService } from './auths.service';
import { AuthsController } from './auths.controller';
import { UsersModule } from 'src/users/users.module';
import { JwtStrategy } from './jwt.strategy';

@Module({
  controllers: [AuthsController],
  providers: [AuthsService, JwtStrategy],
  imports: [UsersModule]
})
export class AuthsModule {}
