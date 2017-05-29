#!/usr/bin/env python
"""
Quick script to add lat/long to metadata
"""
import pandas as pd
import os
import argparse
import urllib.request
import zipfile

def get_centroids():
    '''
    Grab Centroids CSV if it doesn't exist and parse into
    a dataframe

    Returns
    -------

    centroids: pd.DataFrame
        DataFrame of parsed centroids data
    '''
    centroids_fp = 'country_centroids_primary.csv'
    if not os.path.exists(centroids_fp):
        url = 'http://gothos.info/resource_files/country_centroids.zip'
        urllib.request.urlretrieve(url, 'country_centroids.zip')
        with zipfile.ZipFile('country_centroids.zip') as fh_z:
            fh_z.extract(centroids_fp)
        os.unlink('country_centroids.zip')

    centroids = pd.read_csv(centroids_fp, sep='\t')
    return centroids


if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Add lat and long to metadata')
    parser.add_argument('metadata', help='Path to metadata CSV')
    parser.add_argument('field', help='Field in metadata CSV with sampling loc',
                        type=int)
    args = parser.parse_args()

    centroids = get_centroids()

    with open(args.metadata) as fh:

        # write header
        header = next(fh).strip()

        for line in fh:
            line = line.strip().split(',')
            country = line[args.field]
            print(country)
            data = centroids[centroids['SHORT_NAME'] == country]
            if len(data) == 1:
                line.append(str(data['LAT'].item()))
                line.append(str(data['LONG'].item()))
            else:
                raise ValueError('Country not found: {}'.format(country))
            print(",".join(line))

