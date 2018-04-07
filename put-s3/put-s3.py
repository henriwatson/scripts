import click
import boto3
import magic
import pasteboard
import sys
import os
from hashlib import blake2b

from pprint import pprint

def upload_file(filename, body, mime):
    # Let's use Amazon S3
    s3 = boto3.resource('s3')

    object = s3.Bucket('dl.lobi.to').put_object(
        Key=filename,
        Body=body,
        ContentType=mime
    )

    return object

@click.group()
def cli():
    pass

@cli.command()
@click.argument('input', type=click.File('rb'))
def file(input):
    input_buf = input.read()
    hash = blake2b(input_buf, digest_size=6).hexdigest()

    filename = hash + '/' + os.path.basename(input.name)
    mime = magic.from_buffer(input_buf, mime=True)

    object = upload_file(filename, input_buf, mime)

    pprint(object)

    print('https://dl.lobi.to/' + filename)

@cli.command()
def paste():
    pb = pasteboard.Pasteboard()
    input_buf = pb.get_contents(type=pasteboard.PNG)

    if input_buf is None:
        print('Pasteboard is empty! :c')
        sys.exit()

    hash = blake2b(input_buf, digest_size=6).hexdigest()

    filename = hash + '.png'
    mime = magic.from_buffer(input_buf, mime=True)

    object = upload_file(filename, input_buf, mime)

    pprint(object)

    print('https://dl.lobi.to/' + filename)


if __name__ == '__main__':
    cli()
