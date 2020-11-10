Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3988F2AD086
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 08:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgKJHgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 02:36:08 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:56150 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgKJHgH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 02:36:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604993767; x=1636529767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cLUiK/5JQNEEzHyKXjSQWjRXn4o98uVXPumIygujNJQ=;
  b=CdFloBw4qmEGFBAWKwHsUS8R8TSq6DRS07Fu0DONWeafSVYFt8HbCY5c
   +UrvoqsUgUQfzSo57Xcldq6zUWcx6KD9wzp11A5dMEZESBpwscWjMLlrj
   Cy2PIyq/eO+pToxx2xmv4n1znmnePq/Vq3ps+Gsm9nLyLrBYSx8p+dB3Z
   JB39Ga4SJVNSVNciAZgeTcK+56BzERGiV8yqM5Kd/fkhlS3kPZBz0jw9K
   FMOA0aaolDyw4IXiix9yK8fL/bvMSsffgbLcUxuPa5jmWnmgVgrHXelkx
   A69n+f7BIAr/nSfKOGmq6/aUwj/OqVleCtYzxYDeaNuhznVfD25Qt95BY
   g==;
IronPort-SDR: o1283SDf8jPzkU7odapj/Ayatz736gkzY9P/xH2gwyzoJxcREjljd2BCtHshSwW8DMhSkJGYpk
 tsn+9t26mFEwamoaF7dM30127KKTuuU//rP0ft7n7MthuF2Nsjbw1LLw8sIcSawipwMFd+oLbe
 rXE8T2foF7A3MBzDJNHo2buGEH7bXNjBbhw0T9PbgpdEWKNjdfa7DSkThDnD7Pwt5+SHMxKz7/
 FLS48qG5cjoAtV6KVITsocNpk8d3dM+iVGNJoqGNLW/BIG9LSyu+zQtwPCqOAs08r4jVYabvid
 +gQ=
X-IronPort-AV: E=Sophos;i="5.77,465,1596470400"; 
   d="scan'208";a="153458918"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2020 15:36:07 +0800
IronPort-SDR: FRWzrE6CsvcG2iGrkaWdg7wrGYtUIlzwLc1doiu21424lc/vccKTd0siVR9CO7AgRhhq2amBdl
 M8tgJJjZAYGpJfLSs1E4zsQ8ZL/gCc1ccAlOk2iKN9DgBFhea9R/JIyOUf82agBONQOYpk+O0S
 H/fC3cc/ZYFTMRe6SzMfcHy1b102GuDEAs711A2yC0DhQJFeAkz5HoRcg8pNLjKjTiN4zJlCUv
 Il7uI5p+U0OZemn5EFdNGmvlb6ubPM4byBdkdGMba+kgXYCjPOYzgit2rJk5VEZUPcPO9JanmR
 EvSWPEdX0wHuEZM8zQhPfbct
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 23:22:08 -0800
IronPort-SDR: 7ZPbkXttShJWst54X+8ZfP6+yqYxzJaIk3uGKkiTA0qouAGrbsBTBH8AG+GN5Jk56/hSAbq9bm
 utBzMgUjJ3kp8RBWkYojRmyvmClRWxiV4yEdlJMK8bsJkZPILt9QTUKFGb7m06YY0BjAq5fFa+
 qx7XwvsqLwXPCC+UtaNS//qvkhndFYwERkFVOdPe7yE1WLkaCBysZvaOud6bi9CVmHilHxt/d/
 bI5KoVNpkUtUV4vVSXbSMdCLHlozaJtig7AiU4mR+7K1188K/H0E0OjpByW2dh9D8hByBdkrym
 I1o=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Nov 2020 23:36:06 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] null_blk: Fix scheduling in atomic with zoned mode
Date:   Tue, 10 Nov 2020 16:36:05 +0900
Message-Id: <20201110073605.296624-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <160491753798199@kroah.com>
References: <160491753798199@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit e1777d099728a76a8f8090f89649aac961e7e530 upstream.

Commit aa1c09cb65e2 ("null_blk: Fix locking in zoned mode") changed
zone locking to using the potentially sleeping wait_on_bit_io()
function. This is acceptable when memory backing is enabled as the
device queue is in that case marked as blocking, but this triggers a
scheduling while in atomic context with memory backing disabled.

Fix this by relying solely on the device zone spinlock for zone
information protection without temporarily releasing this lock around
null_process_cmd() execution in null_zone_write(). This is OK to do
since when memory backing is disabled, command processing does not
block and the memory backing lock nullb->lock is unused. This solution
avoids the overhead of having to mark a zoned null_blk device queue as
blocking when memory backing is unused.

This patch also adds comments to the zone locking code to explain the
unusual locking scheme.

Fixes: aa1c09cb65e2 ("null_blk: Fix locking in zoned mode")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/null_blk.h       |  1 +
 drivers/block/null_blk_zoned.c | 31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index 206309ecc7e4..7562cd6cd681 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -44,6 +44,7 @@ struct nullb_device {
 	unsigned int nr_zones;
 	struct blk_zone *zones;
 	sector_t zone_size_sects;
+	spinlock_t zone_lock;
 	unsigned long *zone_locks;
 
 	unsigned long size; /* device size in MB */
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 495713d6c989..d9102327357c 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -46,10 +46,20 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	if (!dev->zones)
 		return -ENOMEM;
 
-	dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
-	if (!dev->zone_locks) {
-		kvfree(dev->zones);
-		return -ENOMEM;
+	/*
+	 * With memory backing, the zone_lock spinlock needs to be temporarily
+	 * released to avoid scheduling in atomic context. To guarantee zone
+	 * information protection, use a bitmap to lock zones with
+	 * wait_on_bit_lock_io(). Sleeping on the lock is OK as memory backing
+	 * implies that the queue is marked with BLK_MQ_F_BLOCKING.
+	 */
+	spin_lock_init(&dev->zone_lock);
+	if (dev->memory_backed) {
+		dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
+		if (!dev->zone_locks) {
+			kvfree(dev->zones);
+			return -ENOMEM;
+		}
 	}
 
 	if (dev->zone_nr_conv >= dev->nr_zones) {
@@ -118,12 +128,16 @@ void null_free_zoned_dev(struct nullb_device *dev)
 
 static inline void null_lock_zone(struct nullb_device *dev, unsigned int zno)
 {
-	wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
+	if (dev->memory_backed)
+		wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
+	spin_lock_irq(&dev->zone_lock);
 }
 
 static inline void null_unlock_zone(struct nullb_device *dev, unsigned int zno)
 {
-	clear_and_wake_up_bit(zno, dev->zone_locks);
+	spin_unlock_irq(&dev->zone_lock);
+	if (dev->memory_backed)
+		clear_and_wake_up_bit(zno, dev->zone_locks);
 }
 
 int null_report_zones(struct gendisk *disk, sector_t sector,
@@ -233,7 +247,12 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 		if (zone->cond != BLK_ZONE_COND_EXP_OPEN)
 			zone->cond = BLK_ZONE_COND_IMP_OPEN;
 
+		if (dev->memory_backed)
+			spin_unlock_irq(&dev->zone_lock);
 		ret = null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
+		if (dev->memory_backed)
+			spin_lock_irq(&dev->zone_lock);
+
 		if (ret != BLK_STS_OK)
 			break;
 
-- 
2.26.2

