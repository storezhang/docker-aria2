#! /bin/python3
# ^_^encoding=utf-8^_^

from os import system
import sys
import time
import logging
import requests
import argparse
import aria2p


logger = logging.getLogger("tracker")
logger.setLevel(logging.DEBUG)
ch = logging.StreamHandler(sys.stdout)
ch.setLevel(logging.DEBUG)
formatter = logging.Formatter("%(asctime)s;%(levelname)s;%(message)s", "%Y-%m-%d %H:%M:%S")
ch.setFormatter(formatter)
logger.addHandler(ch)


def tracker_list(tracker_urls):
    """
    从Tracker地址组合组Tracker列表
    :param tracker_urls: Tracker网址列表
    :return: Tacker列表
    """
    trackers = set()

    urls = tracker_urls.split()
    for url in urls:
        r = requests.get(url)
        trackers.add(r.content.split())

    return trackers


def parse_args():
    """
    解析参数
    :return: 参数列表
    """
    parser = argparse.ArgumentParser(description='Aria Tracker自动更新')
    parser.add_argument(
        "tracker_urls",
        "-u",
        "--tracker-urls",
        default='https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt',
        type=str,
        help="存放Tracker的地址"
    )
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    aria2 = aria2p.API(
        aria2p.Client(
            host="http://localhost",
            port=6800,
            secret=""
        )
    )
    while True:
        tackers = tracker_list(args.tracker_urls)
        time.sleep(2 * 60 * 60)
