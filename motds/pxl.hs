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
import Data.Char
import Data.List
import Data.Maybe
import Data.Word
import Codec.Picture (readImage, Image, PixelRGBA8 (..), pixelAt, imageWidth, imageHeight, convertRGBA8)

approximate :: PixelRGBA8 -> Word8
approximate (PixelRGBA8 r g b a) = ((small r) * 36 + (small g) * 6 + small b) + 16 where
    small x = floor $ fromIntegral ((fromIntegral x * 5)) / fromIntegral 255

isTransparent (PixelRGBA8 _ _ _ 0) = True
isTransparent _ = False

data BG = Transparent | BG Word8 deriving Eq
data FG = FG Word8 deriving Eq

class Settable t where
    set :: t -> String

instance Settable BG where
    set Transparent = "\ESC[49m"
    set (BG n) = "\ESC[48;5;" ++ show n ++ "m"

instance Settable FG where
    set (FG n) = "\ESC[38;5;" ++ show n ++ "m"

doPixel :: PixelRGBA8 -> PixelRGBA8 -> (Maybe BG, Maybe FG, Char)
doPixel top bot
    | isTransparent top && isTransparent bot = (Just Transparent, Nothing, ' ')
    | isTransparent bot                      = (Just Transparent, Just (FG (approximate top)), '▀')
    | isTransparent top                      = (Just Transparent, Just (FG (approximate bot)), '▄')
    | otherwise                              = (Just (BG (approximate top)), Just (FG (approximate bot)), '▄')

setFrom :: (Settable t, Eq t) => t -> Maybe t -> String
setFrom old = maybe "" (\new -> if new == old then "" else set new)

nextPixel :: ((BG, FG), String) -> (PixelRGBA8, PixelRGBA8) -> ((BG, FG), String)
nextPixel ((oldb, oldf), soFar) (top, bot) = ((fromMaybe oldb newb, fromMaybe oldf newf), soFar ++ setFrom oldb newb ++ setFrom oldf newf ++ [char])
    where (newb, newf, char) = doPixel top bot

convert :: Image PixelRGBA8 -> String
convert im =
    concatMap row [y | y <- [0,2..imageHeight im - 1]]
        where
            row y = (snd (foldl nextPixel ((Transparent, FG 7), "") $ pixelRows y)) ++ "\ESC[m\n"

            pixelRows y = [(at x y, at x (y+1)) | x <- [0..imageWidth im - 1]]

            at x y | y == imageHeight im = PixelRGBA8 0 0 0 0
                   | otherwise           = pixelAt im x y


main :: IO ()
main = do
    im:_ <- getArgs
    image_ <- readImage im
    case image_ of
      Left err -> putStrLn err
      Right image -> putStr $ convert $ convertRGBA8 image
