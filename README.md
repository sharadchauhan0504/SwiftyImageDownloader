# SwiftyImageDownloader

Download image by creating your own downloader.

## Usage
1. Subclass your imageView:
`@IBOutlet weak var yourImageView: SwiftyImageDownloader!`

2. Start download:
`yourImageView.downloadImageFrom(url: imageUrl)`

## Enhancements
- Create custom directory to save your images, add remove single image and remove all images from downloaded images.
