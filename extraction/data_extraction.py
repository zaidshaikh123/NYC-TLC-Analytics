import requests
from pathlib import Path
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry


months = ["2026-01","2026-02","2026-03"]
base_url = "https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_{month}.parquet"
raw_dir = "data/raw"

def create_session() -> requests.Session:
    session = requests.Session()
    retries = Retry(
        total = 5,
        backoff_factor = 1,
        status_forcelist = [429, 500, 502, 503, 504],
        allowed_methods = ['GET']
    )

    session.mount("https://",HTTPAdapter(max_retries = retries))
    #session.headers.update({"User-Agent":"Mozilla/5.0 (compatible; data-pipeline/1.0)"})
    return session

def download_data(session: requests.Session, month:str) -> str:
    request_url = base_url.format(month = month)
    dest_path = f"{raw_dir}/yellow_tripdata_{month}.parquet"
    temp_path = dest_path + ".part"
    

    if Path(dest_path).exists():
        print(f"{month} already exists, skipping to next month")
        return dest_path
    else:
        with session.get(request_url, stream = True, timeout = 30) as response:
            response.raise_for_status()
            with open(temp_path, "wb") as file:
                for chunk in response.iter_content(chunk_size = 1024*1024):
                    if chunk:
                        file.write(chunk)
        Path(temp_path).rename(dest_path)
        return dest_path

def main():
    Path(raw_dir).mkdir(parents = True, exist_ok = True)
    get_session = create_session()
    for month in months:
        get_file_dest = download_data(get_session, month)
        print(f"{month}: {Path(get_file_dest).stat().st_size/1e6:.1f} MB")

if __name__ == "__main__":
    main()