# Pixel Renderer

An autoload designed to allow pixel-perfect rendering while working on high resolutions. This allows for the game to achieve a pixel-perfect look on a dedicated viewport with a low resolution while still being able to render on high resolutions outside this viewport, as well as zooming in and out on this viewport while maintaining pixel size consistency. The way this works is by rendering scenes on a dedicated viewport with a preset resolution and displaying them as a viewport texture, which allows a camera working on a higher resolution to be used to display those scenes. 

The max_resolution property is the maximum amount of pixels that can be rendered at the same time, limiting the zoom out capacity. The base_resolution property is the resolution that will be scaled up to be rendered in the project's resolution. For instance, the demo project has a default resolution of 1920x1080, with a base_resolution of 320x180 and a max resolution of 480x270. This means that when the project is opened, a 320x180 pixel perfect viewport will be scaled to fit the screen, and that it can be zoomed in or out to any resolution below 480x270.

Assets used in the demo project are under CC0 and were made by Buch @ http://blog-buch.rhcloud.com

Copyright/attribution is not required, though appreciated. Credit me as Moraguma and link to https://moraguma.itch.io/