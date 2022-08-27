import os
import json
from PIL import Image
import boto3

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    
    statusCode = 200
    message = ""
    
    pre_process_bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_name = event['Records'][0]['s3']['object']['key']
    post_process_bucket_name = os.environ.get('POST_PROCESSING_BUCKET_NAME')
    
    print(f"Processing {file_name} from pre_process_bucket_name")
    
    try:
        # Get image from S3
        image_path = get_file_from_s3(pre_process_bucket_name, file_name)
    
        # Remove any meta data
        remove_metadata(image_path)
    
        # Upload processed image to post process bucket
        upload_imgae_to_s3(image_path, post_process_bucket_name, file_name)
    
        # Delete image from pre process bucket
        delete_object_from_s3(pre_process_bucket_name, file_name)
        
    except Exception as e:
        statusCode = 400
        message = f"Error occurred: {e}"
    
    return {
        'statusCode': statusCode,
        'message' : message,
    }

def upload_imgae_to_s3(image_path, dst_bucket, key):
    """
    Uploads object to S3 bucket
        image_path : path of file to upload
        dst_bucket : destination bucket
        key        : key / file name for destination bucket
    """
    print(f"Uploading {key} to {dst_bucket}")
    with open(image_path, 'rb') as data:
        print(f"Uploading {image_path} to {dst_bucket}")
        s3_client.upload_fileobj(data, dst_bucket, key)
    
def delete_object_from_s3(bucket, file):
    """
    Deletes an object from S3 bucket
        bucket : bucket to delete from
        file.  : path of object to delete in bucket
    """
    print(f"Deleting {file} from {bucket}...")
    response = s3_client.delete_object(
        Bucket = bucket,
        Key = file,
    )
    print(f"Response: {response}")

def remove_metadata(file_path):
    """
    Removes any meta data from a given 
        file_path : path to the file to remove meta data from
    """
    img = Image.open(file_path)
    
    if 'exif' in img.info: 
        print("Found EXIF data. Removing...")
        del img.info['exif']

    img.save(file_path)
    
def get_file_from_s3(bucket_name, file_name):
    """
    Downloads object from S3 bucket
        bucket_name : bucket to download from
        file_name   : file to download
    """
    file_path = f"/tmp/{file_name}"
    
    with open(file_path, 'wb') as data:
        result = s3_client.download_fileobj(bucket_name, file_name, data)
    
    return file_path