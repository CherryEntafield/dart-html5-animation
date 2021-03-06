#import('dart:html');
#import('../../include/utilslib.dart', prefix:'utilslib');
#source('../classes/ball.dart');
#source('../classes/bound.dart');
#source('point.dart');

class billiard4 {

  billiard4() {
  }

  void run() {
    CanvasElement canvas = document.query('#canvas');
    var context = canvas.getContext('2d');
    var ball0 = new Ball.withRadius(80);
    var ball1 = new Ball.withRadius(40);
    var bounce = -1.0;
    
    ball0.mass = 2;
    ball0.x = canvas.width - 200;
    ball0.y = canvas.height - 200;
    ball0.vx = Math.random() * 10 - 5;
    ball0.vy = Math.random() * 10 - 5;
    
    ball1.mass = 1;
    ball1.x = 100;
    ball1.y = 100;
    ball1.vx = Math.random() * 10 - 5;
    ball1.vy = Math.random() * 10 - 5;

    
    rotate (var x, var y, var sin, var cos, var reverse) {
      return new point(
        (reverse) ? (x * cos + y * sin) : (x * cos - y * sin),
        (reverse) ? (y * cos - x * sin) : (y * cos + x * sin)
      );
    };
    
    checkCollision() {
      var dx = ball1.x - ball0.x,
      dy = ball1.y - ball0.y,
      dist = Math.sqrt(dx * dx + dy * dy);
      //collision handling code here
      if (dist < ball0.radius + ball1.radius) {
        //calculate angle, sine, and cosine
        var angle = Math.atan2(dy, dx),
            sin = Math.sin(angle),
            cos = Math.cos(angle),
            //rotate ball0's position
            pos0 = new point(0,0), // point
            //rotate ball1's position
            pos1 = rotate(dx, dy, sin, cos, true),
            //rotate ball0's velocity
            vel0 = rotate(ball0.vx, ball0.vy, sin, cos, true),
            //rotate ball1's velocity
            vel1 = rotate(ball1.vx, ball1.vy, sin, cos, true),
            //collision reaction
            vxTotal = vel0.x - vel1.x;
        vel0.x = ((ball0.mass - ball1.mass) * vel0.x + 2 * ball1.mass * vel1.x) /
                 (ball0.mass + ball1.mass);
        vel1.x = vxTotal + vel0.x;
        //update position
        pos0.x += vel0.x;
        pos1.x += vel1.x;
        //rotate positions back
        var pos0F = rotate(pos0.x, pos0.y, sin, cos, false),
            pos1F = rotate(pos1.x, pos1.y, sin, cos, false);
        //adjust positions to actual screen positions
        ball1.x = ball0.x + pos1F.x;
        ball1.y = ball0.y + pos1F.y;
        ball0.x = ball0.x + pos0F.x;
        ball0.y = ball0.y + pos0F.y;
        //rotate velocities back
        var vel0F = rotate(vel0.x, vel0.y, sin, cos, false),
            vel1F = rotate(vel1.x, vel1.y, sin, cos, false);
        ball0.vx = vel0F.x;
        ball0.vy = vel0F.y;
        ball1.vx = vel1F.x;
        ball1.vy = vel1F.y;
      }
    };
    
    checkWalls(var ball) {
      if (ball.x + ball.radius > canvas.width) {
        ball.x = canvas.width - ball.radius;
        ball.vx *= bounce;
      } else if (ball.x - ball.radius < 0) {
        ball.x = ball.radius;
        ball.vx *= bounce;
      }
      if (ball.y + ball.radius > canvas.height) {
        ball.y = canvas.height - ball.radius;
        ball.vy *= bounce;
      } else if (ball.y - ball.radius < 0) {
        ball.y = ball.radius;
        ball.vy *= bounce;
      }
    };
    
    drawFrame(int t) {
      document.window.webkitRequestAnimationFrame(drawFrame, canvas);
      context.clearRect(0, 0, canvas.width, canvas.height);
      
      ball0.x += ball0.vx;
      ball0.y += ball0.vy;
      ball1.x += ball1.vx;
      ball1.y += ball1.vy;
      checkCollision();
      checkWalls(ball0);
      checkWalls(ball1);
      ball0.draw(context);
      ball1.draw(context);
    };
    drawFrame(0);
  }
}

void main() {
  new billiard4().run();
}
