## Projeto 2 - Jogo reativo em Lua + Löve

### Para jogar:
```
love snake/
```
 ou

 acesse [https://snakonline.herokuapp.com](Snakonline)

### Para "compilar" o jogo Lua para web:

Acessar a pasta ```love.ls/release-compatibility``` e rodar:
```
python ../emscripten/tools/file_packager.py game.data --preload ../../snake/@/ --js-output=game.js
```