#! /bin/python3
# ^_^encoding=utf-8^_^

from os import system
import sys
import time
import logging
import requests
import argparse
import aria2p
from configobj import ConfigObj


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
    parser.add_argument(
        "conf_path",
        "-c",
        "--conf-path",
        default='/etc/aria2/aria2.conf',
        type=str,
        help="Aria2的配置文件路径"
    )
    parser.add_argument(
        "rpc_url",
        "-r",
        "--rpc-url",
        default='http://localhost',
        type=str,
        help="Aria2的RPC路径"
    )

    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()

    conf = ConfigObj(args.conf_path, encoding='UTF8')
    aria2 = aria2p.API(
        aria2p.Client(
            host=args.rpc_url,
            port=conf["rpc-listen-port"],
            secret=conf["rpc-secret"]
        )
    )
    while True:
        tackers = tracker_list(args.tracker_urls)
        time.sleep(2 * 60 * 60)
