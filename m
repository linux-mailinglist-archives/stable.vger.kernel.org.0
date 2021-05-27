Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA94239279E
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 08:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbhE0G3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 02:29:50 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:46371 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbhE0G3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 02:29:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622096862; x=1653632862;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kM+s85hOf4Ufi9mwkpWDP42MGnpGskVDFC51eMYIx1Q=;
  b=IGpXAuOkw21B2enGdXvNkBjm4p7e1Qv7D20VJNFoEvJkvKIfS4PVB2Nu
   07o+YbvzmRKfRKjs/z7F/ASbEqFnbbfKuamwPgRTib82kkW/2H7CNcmrN
   mhkFIJ7Tt/0iJg//BLK4JHpywv8LXcoPVw2UxaDcN44ufBUaf7K6j+z6A
   mX0p4pb8sJQELAriLxkUjpmQSN/Likct5yduFR4T1+J/H2OkbbaZYQg2x
   81AoQmdNafzgVS0L3mkOmyZXFtANjVDHR+fcREuuaf6XRfVPp+YTpkJGe
   hGlbYlB32SmW6Hgl/Gn05Tg7HuqYNWCqU2+wPO8vh7llDVPBV+KIftihh
   w==;
IronPort-SDR: ukIqrRSJP5YbqAStbxyEV0RmWhAH3Lg0xt+vW06kIgqTmzoY2jqPfW/o5DedcE0ekKuj5x7cNW
 E4eWk5UawKCcwDhEJkFcWIBO15O3ZjiU396TW3lFuxCHvKAbxhqocH26oUvR1QlqMt+k3tbLXb
 QHnOZ/f0VsEdSEXpC59G/icUAJ6hTP0ri4UdTsOhMbkfmxsRnP6ZpaucvJbdJn/xvd28+/xNFu
 oOPl4NUsuP7zYFKpzDR1wVt/llAK8C7AVOEsajuWzNhjo4j5wybJHqu0Wo5yzAMnfdUAYvBrPR
 Vj4=
X-IronPort-AV: E=Sophos;i="5.82,334,1613404800"; 
   d="scan'208";a="273520070"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2021 14:27:40 +0800
IronPort-SDR: z1W8m5x9gt0pnvEqjlsqyxW7fwlJ8nKbXJm0MpDIBs1II4XvY3w3dG/6vOu2Wo5EG5R+Wd2hsC
 T+5D4JgQ3ZXP2Ux622la4oHIBVbRhTqjF1jodlOz3gq47iUyjAsHpjjYp2Sy2D3JDzCp3+KHwF
 TLlUy9kLKWHrPTg2yS9BjpO+PuqhkIpumAzpIa9KXRiUx+1gd+OfoSz6UkgpO+HX3Twk1q1jei
 e1muUcqYE2IYmWYJtLYzEk4+sff9Snm8EiIfdv8dbBH5FCDkjn4RPlvItnfAvoSClgifD9E+A0
 yI2fDfDOdijWP6I9pJ3RCdGj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 23:07:04 -0700
IronPort-SDR: y01yQ4R33B+74TYavoAUcG2giUWlQWfv+c5sPqHQ0EjkWCyw38eWX0JHb9JY3xBC8WjqXGo6xF
 +cm1P55xxpK2l7GbfgSg/B4eOZaJF7vBQBNeUL1bV7mwM6rdKfcDdod36gN9g6aHrTrtCFKd/v
 Zg7azLcQfTIIaGOsM/j9xVxIkCWIqXc6VIGp1Pc5So6t28HEInhb5HwhKWBhlgVuOL2+XEP3Ej
 0pkKfx7CyzhFJYFnuHosvomb3q6L/dUBsGcbxKEGLqhbMLC71T+qri1h7RxRfXSS4vNivNAgw/
 M8k=
WDCIronportException: Internal
Received: from wdmnc1592.ad.shared (HELO naota-xeon.wdc.com) ([10.225.51.161])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 May 2021 23:27:37 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: [PATCH v2] btrfs: zoned: fix zone number to sector/physical calculation
Date:   Thu, 27 May 2021 15:27:32 +0900
Message-Id: <20210527062732.2683788-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In btrfs_get_dev_zone_info(), we have "u32 sb_zone" and calculate "sector_t
sector" by shifting it. But, this "sector" is calculated in 32bit, leading
it to be 0 for the 2nd superblock copy.

Since zone number is u32, shifting it to sector (sector_t) or physical
address (u64) can easily trigger a missing cast bug like this.

This commit introduces helpers to convert zone number to sector/LBA, so we
won't fall into the same pitfall again.

Fixes: 12659251ca5d ("btrfs: implement log-structured superblock for ZONED mode")
Cc: stable@vger.kernel.org # 5.11+
Reported-by: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/zoned.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 5feb76bdfc06..adada8ca53f9 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -153,6 +153,18 @@ static inline u32 sb_zone_number(int shift, int mirror)
 	return (u32)zone;
 }
 
+static inline sector_t zone_start_sector(u32 zone_number,
+					 struct block_device *bdev)
+{
+	return (sector_t)zone_number << ilog2(bdev_zone_sectors(bdev));
+}
+
+static inline u64 zone_start_physical(u32 zone_number,
+				      struct btrfs_zoned_device_info *zone_info)
+{
+	return (u64)zone_number << zone_info->zone_size_shift;
+}
+
 /*
  * Emulate blkdev_report_zones() for a non-zoned device. It slices up the block
  * device into static sized chunks and fake a conventional zone on each of
@@ -408,8 +420,8 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 		if (sb_zone + 1 >= zone_info->nr_zones)
 			continue;
 
-		sector = sb_zone << (zone_info->zone_size_shift - SECTOR_SHIFT);
-		ret = btrfs_get_dev_zones(device, sector << SECTOR_SHIFT,
+		ret = btrfs_get_dev_zones(device,
+					  zone_start_physical(sb_zone, zone_info),
 					  &zone_info->sb_zones[sb_pos],
 					  &nr_zones);
 		if (ret)
@@ -736,7 +748,7 @@ int btrfs_sb_log_location_bdev(struct block_device *bdev, int mirror, int rw,
 	if (sb_zone + 1 >= nr_zones)
 		return -ENOENT;
 
-	ret = blkdev_report_zones(bdev, sb_zone << zone_sectors_shift,
+	ret = blkdev_report_zones(bdev, zone_start_sector(sb_zone, bdev),
 				  BTRFS_NR_SB_LOG_ZONES, copy_zone_info_cb,
 				  zones);
 	if (ret < 0)
@@ -841,7 +853,7 @@ int btrfs_reset_sb_log_zones(struct block_device *bdev, int mirror)
 		return -ENOENT;
 
 	return blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
-				sb_zone << zone_sectors_shift,
+				zone_start_sector(sb_zone, bdev),
 				zone_sectors * BTRFS_NR_SB_LOG_ZONES, GFP_NOFS);
 }
 
@@ -893,7 +905,8 @@ u64 btrfs_find_allocatable_zones(struct btrfs_device *device, u64 hole_start,
 			if (!(end <= sb_zone ||
 			      sb_zone + BTRFS_NR_SB_LOG_ZONES <= begin)) {
 				have_sb = true;
-				pos = ((u64)sb_zone + BTRFS_NR_SB_LOG_ZONES) << shift;
+				pos = zone_start_physical(
+					sb_zone + BTRFS_NR_SB_LOG_ZONES, zinfo);
 				break;
 			}
 
-- 
2.31.1

