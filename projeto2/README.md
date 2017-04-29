# Projeto 2 - Jogo reativo em Lua + Löve

## Para jogar:
```
love snake/
```
 ou

 acesse [Snakonline](https://snakonline.herokuapp.com)

## Para "compilar" o jogo Lua para web:

Acessar a pasta ```love.js/release-compatibility``` e rodar:
```
python ../emscripten/tools/file_packager.py game.data --preload ../../snake/@/ --js-output=game.js
```

### Referência:
- https://github.com/TannerRogalsky/love.js/