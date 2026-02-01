Минимальный Flutter-мессенджер (клиент)

Кратко:
- Flutter-клиент с поддержкой регистрации по email, входа и реального времени через Firebase (Firestore).
- Чаты привязаны к двум пользователям; сообщения хранятся в подколлекции `messages`.
- Используется `uid` Firebase как уникальный `userID` (можно расширить до пользовательского handle).

Что есть в репо:
- `pubspec.yaml` — зависимости
- `lib/` — исходники приложения
- `firestore.rules` — примеры правил безопасности Firestore

Требования перед сборкой:
1) Установите Flutter (stable) и Android SDK.
2) Инициализируйте Flutter-проект нативные платформы (если нужно):

```bash
flutter create .
flutter pub get
```

3) Создайте проект в Firebase, добавьте Android-приложение, скачайте `google-services.json` и положите в `android/app/`.
4) В консоли Firebase включите Email/Password в Authentication и создайте Firestore (режим тестирования для первого запуска).
5) Примените правила из `firestore.rules` (в README показаны).

Сборка APK:

```bash
flutter build apk --release
```

Запуск в debug:

```bash
flutter run
```

Безопасность и проверка доступа:
- В `firestore.rules` показаны правила, блокирующие доступ к чатам/сообщениям не-участников.

Если хотите — могу автоматически сгенерировать Android-папку, подготовить `google-services.json` пример и помочь с деплоем Firebase.
# Mymyshka
Easy
