#!/bin/bash

cwd=${name:-${PWD##*/}}

echo;

read -p "👉 Project name for package.json [${cwd}]: " name;

name=${name:-${cwd}}

sed -i '' "s/init-es6/${name}/" package.json;
printf "✨ Project name is ${name}\n";

skipquestions="no"

if [[ $1 == "-y" || $1 == "--yes" ]]; then
  skipquestions="yes"
fi;

if [ ! -d "src" ]; then mkdir src; fi;
printf "✨ New \`src\` dir created\n";

if [ ! -d "flow" ]; then mkdir flow; fi;
printf "✨ New \`flow\` dir created\n";

if [ ! -d "flow-typed" ]; then mkdir flow-typed; fi;
printf "✨ New \`flow-typed\` dir created\n";

if [ ! -d "dist" ]; then mkdir dist; fi;
printf "✨ New \`dist\` dir created\n\n";

printf "👉 ESLint\n";

if [[ $skipquestions == "no" ]]; then
  read -n 1 -p "Pick (A)ttitude or (E)SNext config, [a]/e: " eslint && echo;
fi;

eslint=${eslint:-a}

if [[ -z $eslint || $eslint == "a" || $eslint == "A" ]]; then
  if [ -e "attitude/.eslintrc" ]; then
    mv attitude/.eslintrc .eslintrc;

    yarn add eslint-config-with-attitude --dev;
    yarn eslint-config-with-attitude-linker link;
  fi;

  printf "✅ ESLint with Attitude Config\n\n";
else
  if [ -e "default/.eslintrc" ]; then
    mv default/.eslintrc .eslintrc;

    yarn add eslint eslint-config-esnext --dev;
  fi;

  printf "✅ ESLint ESNext Config\n\n";
fi;

printf "👉 Browserlist\n";

if [[ $skipquestions == "no" ]]; then
  read -n 1 -p "Pick (A)ttitude or (D)efault browserslist config, [a]/d: " browserslist && echo;
fi;

browserslist=${browserslist:-a}

yarn add eslint-plugin-compat;

if [[ -z $browserslist || $browserslist == "a" || $browserslist == "A" ]]; then
  if [ -e attitude/.browserslistrc ]; then
    mv attitude/.browserslistrc .browserslistrc
  fi;

  printf "✅ Browserslist config set to Attitude\n\n";
else
  printf "✅ Browserslist config set to Default\n\n";
fi;

printf "👉 Babel...\n"

yarn add @babel/core \
         @babel/cli \
         @babel/preset-env \
         --dev;

echo;

printf "👉 Flpw\n";

if [[ $skipquestions == "no" ]]; then
  read -n 1 -p "Use Flow types? [y]/n: " useflow && echo;
fi;

useflow=${useflow:-y}

if [[ $useflow != "y" ]]; then
  touch src/index.js;
  printf "👎 No Flow\n\n";
else
  if [ -e attitude/.flowconfig ]; then
    mv attitude/.flowconfig .flowconfig;
    sed -i '' "s/\/\/\ *\(\"@babel\/preset-flow\".*\)/\1/" .babelrc
    yarn add flow-bin @babel/preset-flow --dev;
  fi;

  if [ ! -e "src/index.js" ];
    then printf "// @flow\n" > src/index.js;
  fi;

  printf "✅ Flow is now set up\n\n";
fi;

printf "👉 Licence\n";

if [[ $skipquestions == "no" ]]; then
  read -n 1 -p "Keep the MIT licence?: [y]/n: " mit && echo;
fi;

mit=${mit:-y}

if [[ $mit == "n" ]]; then
  unlink LICENSE;
  printf "🧹 LICENCE file removed\n";
else
  printf "📌 Keeping the MIT license\n";
fi;

rm -rf attitude
printf "\n🧹 attitude/ removed\n";
rm -rf default
printf "🧹 default/ removed\n\n";

printf "👉 Readme\n";

if [[ $skipquestions == "no" ]]; then
  read -n 1 -p "Init a new blank README.md?: [y]/n: " blankreadme && echo;
fi;

blankreadme=${blankreadme:-y}

if [[ $blankreadme == "y" ]]; then
  prinf "# ${name}\n" > README.md;
  printf "📖 New README.md created\n";
else
  unlink README.md;
  printf "🧹 README.md removed\n";
fi;

unlink initES6.sh
printf "🧹 init.sh removed itself\n";

echo;

printf "\n🚨 Resetting the Git for your new project...\n";
rm -rf .git;
printf "🧹 .git/ removed\n";

echo;

git init && git checkout -b main && git add --all && git commit -m "Initial commit";
printf "\n✨ New empty repository initiated..\n\n";

printf "👉 Add remote Git origin\n";

read -p "Remote origin [enter to skip]: " remote;

if [[ ! -z $remote ]]; then
  git remote add origin $remote;
  git remote -v;
  printf "🔗 Remote origin is set\n\n";
fi;

printf "🚀 You can now type \`$ yarn start\`\n\n";
printf "🎉 Done\n\n";
