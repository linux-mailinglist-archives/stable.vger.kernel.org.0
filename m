Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B44392485
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 03:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhE0BtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 21:49:06 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:45757 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbhE0BtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 21:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1622080055; x=1653616055;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=HaM5JYpxLW34XflOtbRQ30ZmtPvxd/wGJE9c46OBKxg=;
  b=BXmfv3U1Ai/o6iLfVDHCOYtdRoFwcXTsfeJqIyA0zEjOkUGseX5x9FL3
   VBBLuMHrViB+uK9IP/LL/dsBOGRUPIO8/nu7ruaH86vUjrgUOeEQsBX7u
   fltlioWqiCo3DP3nJs+9v3nszbr7fJwVmCfFE16FgRadt6C1aTKWlv/dD
   CoErhSUsDEeBinU9ZkIPZj533hS1+viDyR51ceNywzRRrZoyW2vMlJY+M
   0jqX0RdVlp99USvHKk0Z4TuGnbbp6X1iq9vbUy839uGBbIVKIjRHCqvsN
   iczRAOaKi8aPjgstojUe2SHwF8HuZHvsNXoYRXN+oyA4jJngxFxc0Bj56
   Q==;
IronPort-SDR: HZE+aTe2Iv0TrdKXmwOs7Kj2aiVDtOtqcnYFK/uT+UOa2B/6T4gnnOWvBjVUimsMCdHUgGfoU3
 in610+AAVm61cJVmG8nimnoFQ09Nve37PzUuwSJ7mEZpA6pNHNlvyqNJj8C77MBjsvZGIhK12u
 cDuGa0zkExsrz4aPc0mOYustR82rKqOPI1R4DE4SkzIcDERwfXQ8c+2EPTnbc/zXJoTkCsT9zJ
 loX2Ez21efxk6zK2e6fb3ol5whEDqX0bKXzICJLPpp8P4jCWuCgybVHrNOd1Gl2igQKW7y/U35
 XL0=
X-IronPort-AV: E=Sophos;i="5.82,333,1613404800"; 
   d="scan'208";a="170109809"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 May 2021 09:47:34 +0800
IronPort-SDR: j6YQUac5Hp4pTQ/BqNb6xvTj2d+j/TQm2BMqto6xGA4jMFBueN4cnGsOt3eyCJnEXFNA0S7dt1
 4+KwKCtqZDisUdK3CqA1+nzXuzohaEJVLoiVgNjvVML5DuqiZ7nkK9O5U1j7H6xbO/OUoNTjO7
 PjAvxTH/4gkPQMcphvNrv3dNLljj7yd1JG+rWJuBOSvTScEGFjuLbd2X7XjtEm+4MwPP1yEYMB
 LsmmKWGXTIolJNvVg4fKMGr7lA8Fx/zDg+7lDVtoXleOyW5qTImLW3KZrxTRPcZQ5ejyE5itz+
 UCoU/7U1VPJVgyrkvNc+IfoR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2021 18:25:39 -0700
IronPort-SDR: YwBRf9CMszyi+oSiUO61wy1zVPGHC5sStD2ly8c+EYODTIKitjedBhjA1DDEgFq7v0OPGuPSTv
 rLZPL9SJ1aRY/a49+JpncOm6U+kpcOvI1mVNghZnutP4Bxs937h5n57FXlmheDWTCQeH85/Ri+
 LUjdVrbUhkCYQS1RjcNW5ZGZZlm9SzBTZ0nx2kA8tfTo+DDnyCU4CnpwmcEpSuhB1FyedWBYoI
 y/5SwwOL/xZqFoX36TgG9GXgN5N4q1UVR09eRnxR5JijpAsBfnDllPVfYWJ24xY06P1fCSekjE
 4VI=
WDCIronportException: Internal
Received: from wdmnc1592.ad.shared (HELO naota-xeon.wdc.com) ([10.225.51.161])
  by uls-op-cesaip02.wdc.com with ESMTP; 26 May 2021 18:47:32 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: [PATCH] btrfs: zoned: fix zone number to sector/physical calculation
Date:   Thu, 27 May 2021 10:46:59 +0900
Message-Id: <20210527014659.2222813-1-naohiro.aota@wdc.com>
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
index 5feb76bdfc06..a7f77f0a5a86 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -153,6 +153,19 @@ static inline u32 sb_zone_number(int shift, int mirror)
 	return (u32)zone;
 }
 
+static inline sector_t zone_start_sector(u32 zone_number, struct block_device *bdev)
+{
+	sector_t zone_sectors = bdev_zone_sectors(bdev);
+
+	return (sector_t)zone_number << ilog2(zone_sectors);
+}
+
+static inline u64 zone_start_physical(u32 zone_number,
+			   struct btrfs_zoned_device_info *zone_info)
+{
+	return (u64)zone_number << zone_info->zone_size_shift;
+}
+
 /*
  * Emulate blkdev_report_zones() for a non-zoned device. It slices up the block
  * device into static sized chunks and fake a conventional zone on each of
@@ -408,8 +421,7 @@ int btrfs_get_dev_zone_info(struct btrfs_device *device)
 		if (sb_zone + 1 >= zone_info->nr_zones)
 			continue;
 
-		sector = sb_zone << (zone_info->zone_size_shift - SECTOR_SHIFT);
-		ret = btrfs_get_dev_zones(device, sector << SECTOR_SHIFT,
+		ret = btrfs_get_dev_zones(device, zone_start_physical(sb_zone, zone_info),
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
+				pos = zone_start_physical(sb_zone + BTRFS_NR_SB_LOG_ZONES,
+					       zinfo);
 				break;
 			}
 
-- 
2.31.1

