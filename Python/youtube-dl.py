import pytube

# Capture the target video URL from user input
link = input('Youtube Video URL')

# Initialize the YouTube object with the provided URL to fetch video metadata
yt = pytube.Youtube(link)

# Access the first available stream (typically the highest resolution) and initiate download
yt.streams.first().download()

# Confirm completion to the user
print('Video Downloaded', link)
