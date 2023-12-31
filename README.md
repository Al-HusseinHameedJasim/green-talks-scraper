# Green Talks Scraper

This repository is aimed at scraping conference schedule URLs and extracting talk titles that contain specific keywords via a script. 
The script compiles a list of talks presented (or to be) at [KubeCon + CloudNativeCon](https://KubeCon.io), Open Source Summit, and their Co-Located events, where at least one of the following keywords is mentioned in the title: carbon, climate, energy, green, kepler, sustainability, or sustainable.

These talks focus on topics such as energy efficiency, environmental sustainability, and green computing within the cloud native ecosystem.
The repository also includes a GitHub Actions workflow that automates the scraping process and publishes the extracted talk titles to a [markdown file](talks.md).

## Getting Started

### Prerequisites

- Bash
- cURL

### Usage

To get started, fork and clone this repository to your local machine and run the script:

```bash
git clone https://github.com/YOUR-USERNAME/green-talks-scraper.git
cd green-talks-scraper
chmod +x scraper.sh
./scraper.sh
```

You can also modify the `scraper.sh` script to add other keywords you want to search for or exclude within the talk titles.

### Output
The script outputs a list of talks that contain the keywords specified.

## Contributing
Contributions are welcome! If you find any issues or want to enhance the project, feel free to open pull requests or report issues in the GitHub repository.

## License
This project is licensed under the MIT License.
