# Film Streamer - Application Android

Application Android avec blocage de publicités pour regarder des films en streaming.

## Fonctionnalités

- 🎬 Interface WebView optimisée pour le streaming
- 🚫 Blocage de publicités intégré
- 📱 Interface plein écran
- ⬅️ Navigation arrière avec le bouton retour
- 🔄 Barre de progression de chargement

## Prérequis

- Android Studio Arctic Fox ou supérieur
- JDK 8 ou supérieur
- Android SDK API 21+ (Android 5.0 Lollipop minimum)

## Installation rapide

### 📦 APK Pré-compilé (Recommandé)

Un APK pré-compilé est disponible : **Film-Streamer.apk** (22 KB)

1. Téléchargez `Film-Streamer.apk` depuis ce repository
2. Transférez-le sur votre téléphone Android
3. Activez "Sources inconnues" dans Paramètres > Sécurité
4. Installez l'APK

### 🔨 Compiler vous-même

#### Méthode 1 : Script de build manuel (Sans internet requis)

```bash
# Script de build qui utilise les outils Android en ligne de commande
./build-apk.sh

# L'APK sera généré dans :
# build-manual/app-debug.apk
```

**Prérequis pour build-apk.sh :**
- Android SDK installé (`/usr/lib/android-sdk` ou définir `SDK_PATH`)
- Java JDK 8+
- Build tools (aapt, dx/dalvik-exchange, apksigner)

#### Méthode 2 : Avec Android Studio

1. Clonez le repository
2. Ouvrez le projet dans Android Studio
3. Laissez Gradle synchroniser le projet
4. Connectez un appareil Android ou lancez un émulateur
5. Cliquez sur "Run" (Shift + F10)

#### Méthode 3 : Ligne de commande avec Gradle

```bash
# Compiler le projet (nécessite connexion internet)
./gradlew assembleDebug

# L'APK sera généré dans :
# app/build/outputs/apk/debug/app-debug.apk

# Pour une version release :
./gradlew assembleRelease
```

## Installation de l'APK sur Android

1. Transférez le fichier APK sur votre téléphone
2. Activez l'installation depuis des sources inconnues dans les paramètres
3. Ouvrez le fichier APK et installez

## Blocage de publicités

L'application bloque automatiquement :
- Réseaux publicitaires (Google Ads, Facebook Ads, etc.)
- Popups et popunders
- Trackers analytiques
- Publicités vidéo

## Configuration

Pour changer l'URL par défaut, modifiez la constante `HOME_URL` dans :
```
app/src/main/java/com/filmstreamer/MainActivity.java
```

## Avertissement

Cette application est fournie à des fins éducatives uniquement. Assurez-vous de respecter les lois sur le droit d'auteur de votre pays.

## Licence

MIT License
