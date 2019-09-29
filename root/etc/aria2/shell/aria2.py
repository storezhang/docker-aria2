#! /bin/python3
# ^_^encoding=utf-8^_^
import os
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


def get_trackers(tracker_update_urls):
    """
    从Tracker地址组合组Tracker列表
    :param tracker_update_urls: Tracker网址列表
    :return: Tacker列表
    """
    tracker_list = set()

    for tracker_update_url in tracker_update_urls.split():
        try:
            r = requests.get(tracker_update_url)
        except Exception as e:
            logger.error(
                "msg=获取Tracker列表出现问题, context=[tracker_update_url=%s, exception=%s]",
                tracker_update_url,
                str(e)
            )
            continue

        for tracker_url in r.text.split():
            tracker_list.add(tracker_url)

    return tracker_list


def parse_args():
    """
    解析参数
    :return: 参数列表
    """
    parser = argparse.ArgumentParser(description='Aria Tracker自动更新')
    parser.add_argument(
        "-c",
        "--conf-dir",
        default='/etc/aria2/',
        type=str,
        help="配置文件路径"
    )
    parser.add_argument(
        "-r",
        "--rpc-url",
        default='http://localhost',
        type=str,
        help="Aria2的RPC路径"
    )

    return parser.parse_args()


def save_trackers(aria2_client, conf, tracker_list, exclude_tracker_list):
    """
    设置Tracker列表
    :param aria2_client: Aria2客户端
    :param conf: Aria2的配置文件
    :param tracker_list: Tackers列表
    :param exclude_tracker_list: 排除的Tracker列表
    :return:
    """

    options = aria2_client.get_global_options()
    options.bt_tracker = tracker_list
    options.bt_exclude_tracker = exclude_tracker_list
    aria2_client.set_global_options(options)

    # 写入配置文件
    conf["bt-tracker"] = tracker_list
    conf["bt-exclude-tracker"] = exclude_tracker_list
    conf.write()


if __name__ == "__main__":
    args = parse_args()

    aria2_conf = ConfigObj(os.path.join(args.conf_dir, 'aria2.conf'), encoding='UTF8')
    app_conf = ConfigObj(os.path.join(args.conf_dir, 'config.conf'), encoding='UTF8')
    aria2 = aria2p.API(
        aria2p.Client(
            host=args.rpc_url,
            port=aria2_conf["rpc-listen-port"],
            secret=aria2_conf.get("rpc-secret", "")
        )
    )

    while True:
        trackers = get_trackers(app_conf["bt-tracker"]["includes"])
        exclude_trackers = get_trackers(app_conf["bt-tracker"]["excludes"])
        if trackers or exclude_trackers:
            logger.debug("msg=开始更新Tracker, context=[trackes=%s, exclude_trackers=%s]", trackers, exclude_trackers)
            save_trackers(aria2, aria2_conf, trackers, exclude_trackers)
        time.sleep(1 * 60 * 60)
