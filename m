Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590232A6345
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbgKDL1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:27:52 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:58999 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729136AbgKDL1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 06:27:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604489271; x=1636025271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pAociI85QaQTZ5012L/mrJvqpJBoaoBlo4ZrSDtbG+k=;
  b=miGHnNBhCCMEFowXXnCbJGc+bfWFYbSq1h1/pSkacByr+7qfqvLj/67L
   2PsNtgSUAxPONWKEbNf3jH4d5hIC03Of6ToAXaIsU3r9ZQrFTvvAvVOEQ
   bhr1Ax70Z+pixmdummhklA0/eTnWBi6ZWDRDf2sNrgdZws1ixG+fLWe2v
   2hPMM2lhXhf2u3G57upM7NAOw2NYhS2tiuGKhG4uzCyU3o5XcqPG4E2ia
   vj+4ZQ3SBGfWBgbs1EpEngl6Z8yyFpl/kqqGySXGZadALeSWzyT63dCjr
   J+Afmd9kQRNp872HxN/LvdQe5dX4u9QWselEDssk0gxJYaF5iObjT9Obe
   A==;
IronPort-SDR: b2iZcfp1BJy87NW2TUjY/rYq674x9UKGqEpYhfNkVk7aADRWCWCMsRrHxSAMNu34Wa3rgO2QZk
 atKw0zY7HLKjviMu2M0MpvBYQJMukHb+CXuwZN6SUTNXs8l6qBAJpwvxOj9f7rYKqC3P+wCOxt
 E6hKcOy2Vs++ECA+xxggrxW2wBjr0AyR7La6Q1PyLFNPkrZkkTGAugT3yS0utTTDPVfadwOb8a
 XxryHj7cw54e7CJf/AmEiGmbPQbIMU4NsQkBWMRxoTkqB+Tv/Sbx1CHlQMemXlCkVn/Rdvdi/2
 j98=
X-IronPort-AV: E=Sophos;i="5.77,450,1596470400"; 
   d="scan'208";a="151681623"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 19:27:50 +0800
IronPort-SDR: QxZxRClgtoQ/N0/Dttd/7yon/WLWdFBT8A7i4nhK2zDQbes/w5V51PT+nALv0HZbYqFEr+LvLB
 MOQZQn6vJulx25gfLes+EdacApGZ5FVNGLauociD4tqO9agFCMzNApS73dTRYKRo85IodNltYa
 UzKuw4pm10oEwLN9joH94S33cGUhhWs1slR6j7u6pBAgIaEoxu0zSADBRnpW6Oxs7tStzQgO8U
 qM2C4eTsd0ci7gY/f7RWF2xA/AsCiDwWdMa0d6uYiPQuW+5oGOpgtDztUlGt54Ea5CIP/eLE05
 fxMopJ97c5waBvGsm3HnMkyH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 03:13:59 -0800
IronPort-SDR: dphbW4dfOd5bCQq1cn/7fEYQgKPon6x237Ar4kuebqdbCjIcpiqKJf+ngSc489X1fZ65qfNKPQ
 TwPXFq22vbeGwPPw3vXRd8S5NfZbtzdhZoU6zjfyWSsT+LZXwzgSySfDdDkvl1wWzKYVFB16EE
 zWN5BYeHssqzfCAbAyi47SjEUGTg6AHnC5Q/gTC0f8LBjUuR91qkcLaECWn4VrT/0x+KeUP8Nb
 eK+Munl5alswpKMFgqq2R+O5fmh2hF2ctviFpVuxG4nseMXa2QZt+QDKt+xnqhpE+k0+eocm+Z
 g8A=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Nov 2020 03:27:50 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 1/3] null_blk: synchronization fix for zoned device
Date:   Wed,  4 Nov 2020 20:27:45 +0900
Message-Id: <20201104112747.182740-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104112747.182740-1-damien.lemoal@wdc.com>
References: <20201104095141.GA1673068@kroah.com>
 <20201104112747.182740-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kanchan Joshi <joshi.k@samsung.com>

commit 35bc10b2eafbb701064b94f283b77c54d3304842 upstream.

Parallel write,read,zone-mgmt operations accessing/altering zone state
and write-pointer may get into race. Avoid the situation by using a new
spinlock for zoned device.
Concurrent zone-appends (on a zone) returning same write-pointer issue
is also avoided using this lock.

Cc: stable@vger.kernel.org
Fixes: e0489ed5daeb ("null_blk: Support REQ_OP_ZONE_APPEND")
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/null_blk.h       |  1 +
 drivers/block/null_blk_zoned.c | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index daed4a9c3436..28099be50395 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -44,6 +44,7 @@ struct nullb_device {
 	unsigned int nr_zones;
 	struct blk_zone *zones;
 	sector_t zone_size_sects;
+	spinlock_t zone_lock;
 
 	unsigned long size; /* device size in MB */
 	unsigned long completion_nsec; /* time in ns to complete a request */
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 3d25c9ad2383..e8d8b13aaa5a 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -45,6 +45,7 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	if (!dev->zones)
 		return -ENOMEM;
 
+	spin_lock_init(&dev->zone_lock);
 	if (dev->zone_nr_conv >= dev->nr_zones) {
 		dev->zone_nr_conv = dev->nr_zones - 1;
 		pr_info("changed the number of conventional zones to %u",
@@ -131,8 +132,11 @@ int null_report_zones(struct gendisk *disk, sector_t sector,
 		 * So use a local copy to avoid corruption of the device zone
 		 * array.
 		 */
+		spin_lock_irq(&dev->zone_lock);
 		memcpy(&zone, &dev->zones[first_zone + i],
 		       sizeof(struct blk_zone));
+		spin_unlock_irq(&dev->zone_lock);
+
 		error = cb(&zone, i, data);
 		if (error)
 			return error;
@@ -277,18 +281,28 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf op,
 				    sector_t sector, sector_t nr_sectors)
 {
+	blk_status_t sts;
+	struct nullb_device *dev = cmd->nq->dev;
+
+	spin_lock_irq(&dev->zone_lock);
 	switch (op) {
 	case REQ_OP_WRITE:
-		return null_zone_write(cmd, sector, nr_sectors, false);
+		sts = null_zone_write(cmd, sector, nr_sectors, false);
+		break;
 	case REQ_OP_ZONE_APPEND:
-		return null_zone_write(cmd, sector, nr_sectors, true);
+		sts = null_zone_write(cmd, sector, nr_sectors, true);
+		break;
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
-		return null_zone_mgmt(cmd, op, sector);
+		sts = null_zone_mgmt(cmd, op, sector);
+		break;
 	default:
-		return null_process_cmd(cmd, op, sector, nr_sectors);
+		sts = null_process_cmd(cmd, op, sector, nr_sectors);
 	}
+	spin_unlock_irq(&dev->zone_lock);
+
+	return sts;
 }
-- 
2.26.2

