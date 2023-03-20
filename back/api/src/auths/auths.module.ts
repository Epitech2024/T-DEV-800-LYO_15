import { forwardRef, Module } from '@nestjs/common';
import { AuthsService } from './auths.service';
import { AuthsController } from './auths.controller';
import { UsersModule } from 'src/users/users.module';
import { JwtStrategy } from './jwt.strategy';

@Module({
  imports: [forwardRef(() => UsersModule)],
  controllers: [AuthsController],
  providers: [AuthsService, JwtStrategy],
  exports: [AuthsService],
})
export class AuthsModule {}
