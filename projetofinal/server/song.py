class AudioHandler(object):

    def __init__(self, song_path, chunk_size=1024):
        self.song_path = song_path
        self.chunk_size = chunk_size
    

    def get_chunks(self):
        with open(self.song_path, "rb") as f:
            chunk = f.read(self.chunk_size)

            while chunk != b"":
                yield chunk
                chunk = f.read(self.chunk_size)


if __name__ == '__main__':
    
    ah = AudioHandler("songs/jump_8k.u8")

    for chunk in ah.get_chunks():
        print chunk
        print


            