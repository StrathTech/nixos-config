{- pxl.hs

Name shamelessly stolen from https://github.com/ichinaski/pxl because I'm
completely uncreative. Sorry!

Dumbly converts an image for display on a 256-colour terminal, assuming
xterm-compatible sequences.

Key differences from ichinaski/pxl:

 - Does not require a terminal: the escape sequences will be written to standard
   output, even if it's a file (main reason why I wrote this)
 - Less complexity, doesn't require a terminal library
 - No scaling. Use imagemagick or something.
 - Yay Haskell

Copyright (C) 2017 Linus Heckemann

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
-}
import System.Environment
import Text.Printf
import Data.List
import Data.Word
import Codec.Picture (readImage, Image, PixelRGBA8 (..), pixelAt, imageWidth, imageHeight, convertRGBA8)

approximate :: PixelRGBA8 -> Word8
approximate (PixelRGBA8 r g b a) = ((small r) * 36 + (small g) * 6 + small b) + 16 where
    small x = floor $ fromIntegral ((fromIntegral x * 5)) / fromIntegral 255

convert :: Image PixelRGBA8 -> String
convert im =
    concatMap row [y | y <- [0..imageHeight im - 1]]
    where
        row y = concatMap (\pix -> setbg pix ++ "  ") [pixelAt im x y | x <- [0..imageWidth im - 1]] ++ "\ESC[m\n"
        setbg     (PixelRGBA8 _ _ _ 0) = "\ESC[m" -- Rudimentary transparency support
        setbg pix@(PixelRGBA8 _ _ _ a) = "\ESC[48;5;" ++ (show $ approximate pix) ++ "m"

main :: IO ()
main = do
    im:_ <- getArgs
    image_ <- readImage im
    case image_ of
      Left err -> putStrLn err
      Right image -> putStrLn $ convert $ convertRGBA8 image
