#include "raylib.h"
#ifdef __EMSCRIPTEN__
    #include <emscripten.h>
#endif


#define XBOX_ALIAS_1 "xbox"
#define XBOX_ALIAS_2 "x-box"
#define PS_ALIAS_1   "playstation"
#define PS_ALIAS_2   "sony"

struct Game
{
	int player_score = 0;
	int cpu_score = 0;
	int gamepad = 0;
	const float leftStickDeadzoneX = 0.1f;
	const float leftStickDeadzoneY = 0.1f;
	const float rightStickDeadzoneX = 0.1f;
	const float rightStickDeadzoneY = 0.1f;
	const float leftTriggerDeadzone = -0.9f;
	const float rightTriggerDeadzone = -0.9f;

	struct Ball
	{
		int x, y;
		int speed_x, speed_y;
		float radius;
		float vibrationTimer;

		void Draw() const
		{
			DrawCircle(x, y, radius, WHITE);
		}

		void Update()
		{
			x += speed_x;
			y += speed_y;
		}
	};

	struct Paddle
	{
		int x, y;
		int width, height;
		int speed;

		void Draw() const
		{
			DrawRectangle(x, y, width, height, WHITE);
		}

		void Update()
		{
			if (IsKeyDown(KEY_UP) || IsGamepadButtonDown(0, GAMEPAD_BUTTON_LEFT_FACE_UP))
			{
				y -= speed;
			}
			if (IsKeyDown(KEY_DOWN) || IsGamepadButtonDown(0, GAMEPAD_BUTTON_LEFT_FACE_DOWN))
			{
				y += speed;
			}
			LimitMovement();
		}

		void LimitMovement()
		{
			if (y <= 10)
			{
				y = 5;
			}
			if (y + height >= GetScreenHeight())
			{
				y = GetScreenHeight() - height - 5;
			}
			// Clamp to valid range
			if (y < 0)
			{	
				y = 0;
			}
			if (y + height > GetScreenHeight())
			{
				y = GetScreenHeight() - height;
			}
		}
	};

	struct CpuPaddle : Paddle
	{
		void Update(int ball_y)
		{
			if (y + height / 2 > ball_y)
			{
				y -= speed;
			}
			if (y + height / 2 < ball_y)
			{
				y += speed;
			}
			LimitMovement();
		}
	};

	struct Sounds
	{
		Sound paddleSound;
		Sound wallSound;
		Sound scoreSound;
		Sounds(){
		#ifndef __EMSCRIPTEN__
			InitAudioDevice();
		#endif
			paddleSound = {0};
			wallSound = {0};
			scoreSound = {0};

		}

		~Sounds(){
			UnloadSound(paddleSound);
			UnloadSound(wallSound);
			UnloadSound(scoreSound);
		}

		void LoadMySounds()
		{
			paddleSound = LoadSound("sounds/paddle.wav");
			wallSound = LoadSound("sounds/wall.wav");
			scoreSound = LoadSound("sounds/score.wav");
		}
	};

	Sounds sounds{};
	Ball ball{};
	Paddle player{};
	CpuPaddle cpuPaddle{};

	void Init(int screen_width, int screen_height)
	{
		ball.radius = 20;
		Reset();

		player.width = 25;
		player.height = 120;
		player.x = screen_width - player.width - 10;
		player.y = screen_height / 2 - player.height / 2;
		player.speed = 6;

		cpuPaddle.width = 25;
		cpuPaddle.height = 120;
		cpuPaddle.x = 10;
		cpuPaddle.y = screen_height / 2 - cpuPaddle.height / 2;
		cpuPaddle.speed = 6;
	}

	void OnBallPlayerCollision()
	{
		// Push ball out of player paddle to prevent sticking
		ball.x = player.x - (int)ball.radius;
		ball.speed_x *= -1;
		PlaySound(sounds.paddleSound);
	}

	void OnBallCpuCollision()
	{
		// Push ball out of cpu paddle to prevent sticking
		ball.x = cpuPaddle.x + cpuPaddle.width + (int)ball.radius;
		ball.speed_x *= -1;
		PlaySound(sounds.paddleSound);
	}

	void Update()
	{
		ball.Update();
		player.Update();
		cpuPaddle.Update(ball.y);

		if (IsKeyPressed(KEY_LEFT) && gamepad > 0)
		{
			gamepad--;
		}
		if (CheckCollisionCircleRec(Vector2{(float)ball.x, (float)ball.y}, ball.radius, Rectangle{(float)player.x, (float)player.y, (float)player.width, (float)player.height}))
		{
			OnBallPlayerCollision();
		}
		if (CheckCollisionCircleRec(Vector2{(float)ball.x, (float)ball.y}, ball.radius, Rectangle{(float)cpuPaddle.x, (float)cpuPaddle.y, (float)cpuPaddle.width, (float)cpuPaddle.height}))
		{
			OnBallCpuCollision();
		}

		// Wall Collisions
		if (ball.y + ball.radius >= GetScreenHeight() || ball.y - ball.radius <= 0)
		{
			ball.speed_y *= -1;
			PlaySound(sounds.wallSound);
		}
		if (ball.x + ball.radius >= GetScreenWidth())
		{
			cpu_score++;
			ball.vibrationTimer = 0.3;
			PlaySound(sounds.scoreSound);
			Reset();
		}

		if (ball.x - ball.radius <= 0)
		{
			player_score++;
			ball.vibrationTimer = 0.3;
			PlaySound(sounds.scoreSound);
			Reset();
		}

		if (ball.vibrationTimer > 0)
		{
			SetGamepadVibration(0, 1.0, 1.0, ball.vibrationTimer);
			ball.vibrationTimer -= GetFrameTime();
		}
	}


	void Reset()
	{
		ball.x = GetScreenWidth() / 2;
		ball.y = GetScreenHeight() / 2;
		ball.speed_x = 7 * ((GetRandomValue(0, 1) == 0) ? -1 : 1);
		ball.speed_y = 7 * ((GetRandomValue(0, 1) == 0) ? -1 : 1);
	}

	void Draw(int screen_width, int screen_height) const
	{
		ClearBackground(BLACK);
		DrawLine(screen_width / 2, 0, screen_width / 2, screen_height, WHITE);
		ball.Draw();
		player.Draw();
		cpuPaddle.Draw();
		DrawText(TextFormat("%i", cpu_score), screen_width / 4 - 20, 20, 80, WHITE);
		DrawText(TextFormat("%i", player_score), 3 * screen_width / 4 - 20, 20, 80, WHITE);
	}
};

Game game;

bool audioStarted = false;

#ifdef __EMSCRIPTEN__
void UpdateDrawFrame(void)
{
	if (!audioStarted && (IsMouseButtonPressed(MOUSE_LEFT_BUTTON) || IsKeyPressed(KEY_SPACE)))
	{
		InitAudioDevice();
		game.sounds.LoadMySounds();
		audioStarted = true;
	}
	if (!audioStarted)
	{
		// Mostra mensagem pedindo interação
		BeginDrawing();
		ClearBackground(BLACK);
		DrawText("Click or press Space to start", GetScreenWidth() / 2 - 140, GetScreenHeight() / 2 - 10, 20, WHITE);
		EndDrawing();
		return;
	}

	game.Update();
	BeginDrawing();
	game.Draw(GetScreenWidth(), GetScreenHeight());
	EndDrawing();
}
#endif

int main()
{
	const int screen_width = 1280;
	const int screen_height = 800;
	SetConfigFlags(FLAG_MSAA_4X_HINT);
	InitWindow(screen_width, screen_height, "Pong Raylib Game");
	game.sounds.LoadMySounds();
	SetTargetFPS(60);

	game.Init(screen_width, screen_height);

#ifdef __EMSCRIPTEN__
    // 0 = browser native FPS, true = simulate infinite loop
    emscripten_set_main_loop(UpdateDrawFrame, 0, 1);
#else

	while (!WindowShouldClose())
	{

		game.Update();

		BeginDrawing();
		game.Draw(screen_width, screen_height);
		EndDrawing();
	}

#endif

	CloseWindow();
	return 0;
}
