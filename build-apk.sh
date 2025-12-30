#!/bin/bash

# Configuration
SDK_PATH=/usr/lib/android-sdk
BUILD_TOOLS=$SDK_PATH/build-tools/29.0.3
PLATFORM=$SDK_PATH/platforms/android-23
PROJECT_DIR=$(pwd)
BUILD_DIR=$PROJECT_DIR/build-manual
APP_SRC=$PROJECT_DIR/app/src/main

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "========================================="
echo "  Build APK Manuel - Film Streamer"
echo "========================================="

# Nettoyer et créer les répertoires
echo -e "${GREEN}[1/8]${NC} Nettoyage..."
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR/{gen,obj,apk}

# Générer R.java avec aapt
echo -e "${GREEN}[2/8]${NC} Génération de R.java..."
$BUILD_TOOLS/aapt package -f -m \
    -J $BUILD_DIR/gen \
    -M $APP_SRC/AndroidManifest.xml \
    -S $APP_SRC/res \
    -I $PLATFORM/android.jar

if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de la génération de R.java${NC}"
    exit 1
fi

# Compiler les sources Java
echo -e "${GREEN}[3/8]${NC} Compilation des sources Java..."
javac -source 1.8 -target 1.8 \
    -d $BUILD_DIR/obj \
    -classpath $PLATFORM/android.jar \
    -sourcepath $APP_SRC/java \
    -bootclasspath $PLATFORM/android.jar \
    $BUILD_DIR/gen/com/filmstreamer/R.java \
    $APP_SRC/java/com/filmstreamer/*.java

if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de la compilation Java${NC}"
    exit 1
fi

# Convertir en DEX
echo -e "${GREEN}[4/8]${NC} Conversion en DEX..."
if [ -f "$BUILD_TOOLS/d8" ]; then
    $BUILD_TOOLS/d8 --lib $PLATFORM/android.jar \
        --output $BUILD_DIR/apk \
        $BUILD_DIR/obj/com/filmstreamer/*.class
else
    # Fallback sur dx si d8 n'existe pas
    dx --dex --output=$BUILD_DIR/apk/classes.dex $BUILD_DIR/obj
fi

if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors de la conversion en DEX${NC}"
    exit 1
fi

# Créer l'APK non signé
echo -e "${GREEN}[5/8]${NC} Packaging de l'APK..."
$BUILD_TOOLS/aapt package -f \
    -M $APP_SRC/AndroidManifest.xml \
    -S $APP_SRC/res \
    -I $PLATFORM/android.jar \
    -F $BUILD_DIR/app-unsigned.apk \
    $BUILD_DIR/apk

if [ $? -ne 0 ]; then
    echo -e "${RED}Erreur lors du packaging${NC}"
    exit 1
fi

# Ajouter les classes DEX
echo -e "${GREEN}[6/8]${NC} Ajout des classes DEX..."
cd $BUILD_DIR/apk
aapt add ../app-unsigned.apk classes.dex
cd $PROJECT_DIR

# Aligner l'APK
echo -e "${GREEN}[7/8]${NC} Alignement de l'APK..."
$BUILD_TOOLS/zipalign -f 4 \
    $BUILD_DIR/app-unsigned.apk \
    $BUILD_DIR/app-unsigned-aligned.apk

# Signer l'APK avec debug key
echo -e "${GREEN}[8/8]${NC} Signature de l'APK..."

# Créer une clé de debug si elle n'existe pas
if [ ! -f "$HOME/.android/debug.keystore" ]; then
    mkdir -p $HOME/.android
    keytool -genkey -v \
        -keystore $HOME/.android/debug.keystore \
        -storepass android \
        -alias androiddebugkey \
        -keypass android \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -dname "CN=Android Debug,O=Android,C=US"
fi

# Signer avec apksigner
$BUILD_TOOLS/apksigner sign \
    --ks $HOME/.android/debug.keystore \
    --ks-key-alias androiddebugkey \
    --ks-pass pass:android \
    --key-pass pass:android \
    --out $BUILD_DIR/app-debug.apk \
    $BUILD_DIR/app-unsigned-aligned.apk

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}=========================================${NC}"
    echo -e "${GREEN}  APK créé avec succès !${NC}"
    echo -e "${GREEN}=========================================${NC}"
    echo -e "\nFichier : ${GREEN}$BUILD_DIR/app-debug.apk${NC}"
    ls -lh $BUILD_DIR/app-debug.apk
else
    echo -e "${RED}Erreur lors de la signature${NC}"
    exit 1
fi
