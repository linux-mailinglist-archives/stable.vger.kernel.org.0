Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01D2F2F00C4
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbhAIP01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 10:26:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726389AbhAIP01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 10:26:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D657023A63;
        Sat,  9 Jan 2021 15:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610205927;
        bh=XI7WZgAk8s2zhqYRupZ0xuOM0/B2xC7dYcdJgB83v5M=;
        h=From:To:Cc:Subject:Date:From;
        b=CkxtoRhF8clV3JRuG31m2jMku9upkg1on6odD/w8IWbzQFGmr1gBPwb/AJOqcRkAS
         JwBmoY1aOQ2dWaOXMA60iNMHv6Xl717NJd0RsTvXw2ZD5IZDDt/4AxcPArhVNUk1pX
         yWudeojQnSIYh28a6Dorx9+e1xTdlzmvzfNALURY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.166
Date:   Sat,  9 Jan 2021 16:26:39 +0100
Message-Id: <16102059998717@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.166 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                    |    2 +-
 drivers/dma/at_hdmac.c                      |   11 ++++++++---
 drivers/iio/imu/bmi160/bmi160_core.c        |   13 +++++++++----
 drivers/iio/magnetometer/mag3110.c          |   13 +++++++++----
 drivers/mtd/nand/spi/core.c                 |    4 ----
 drivers/net/wireless/marvell/mwifiex/join.c |    2 ++
 include/linux/kdev_t.h                      |   22 +++++++++++-----------
 7 files changed, 40 insertions(+), 27 deletions(-)

Felix Fietkau (1):
      Revert "mtd: spinand: Fix OOB read"

Greg Kroah-Hartman (1):
      Linux 4.19.166

Jonathan Cameron (2):
      iio:imu:bmi160: Fix alignment and data leak issues
      iio:magnetometer:mag3110: Fix alignment and data leak issues.

Josh Poimboeuf (1):
      kdev_t: always inline major/minor helper functions

Tudor Ambarus (1):
      dmaengine: at_hdmac: Substitute kzalloc with kmalloc

Yu Kuai (2):
      dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()
      dmaengine: at_hdmac: add missing kfree() call in at_dma_xlate()

Zhang Xiaohui (1):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

