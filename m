Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE722E905B
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 07:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbhADGLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 01:11:52 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22803 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADGLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 01:11:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609740711; x=1641276711;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ckx/H2KwqS9qvZo0XEOVN0N6iAMu2trO/IVWPqvsM7A=;
  b=S/Z/BPHv8e2JwbQnRp9eS2Htydz4Vj8CRTe3KErD8HqwwPA63v+1olSX
   uk8W0Il17/5NocWY5to2vMfDijRm2A44VKAt+AajITPIJ+vovgf+EQve1
   zEB1RC2EUrZVIzfNJUGp21rouNyu5SJcYE0N9RILc5vwjsD6STGwDimx2
   PkMQjt120X8IfBT0Or4ummEJWfgGw5+5tCWUhscrXuX+sBZyARj2oREz9
   8SIhc6qhvFvkTIf+dXGZZvxjPgQGNBw12Fb2Xz9de91nIIiOMOHMY+Lur
   nHx9vjHPfPdjPCT07EUt/vlLiwYnbxTX+Y2s1IDF9pp9bYjJ7aNRDMG39
   g==;
IronPort-SDR: mQ+XqGdW9gwNEGkLMMLiPCx1T6IbH2A3f2VoK/7I5Wz51AYb6POkFf5eVqL+mbRTj8AESq91yQ
 ndN+UFo1Wq5pZGfXli6+tcjETo0DnpjGsczYsjG3IE3GmAOlW9yDiEUq2IDIMfhj/XrMJSpMyP
 IePKA6v2oLvo53Bj89F+x9xiGs/baqrN6XXwocUV4pF7O7GxuMrL2nQ25xrr7cQ2mDf8tLQcpN
 4ktMfrdYaB5rLKHux0MoeYNvLt/SREwuTZYRj/uyX1jH/y5+c4+0l7g7ub81VY7lQVrzCM47n7
 kzs=
X-IronPort-AV: E=Sophos;i="5.78,473,1599494400"; 
   d="scan'208";a="156438089"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 14:10:45 +0800
IronPort-SDR: 4M+qKabh6Mf4wgmDMDFBKukbjDWV+maEvqIX6Wsc5kzZJs8NmapKuume2KPKlOpv9/9lpbQBk7
 KeSwYG1FtY2VTWORKUxf0lJdnbIgXs2SdJ5q6myopezCk/MhdttMYBNL6c26q6K02V4R9r4g3k
 /5xKH1avkxmR4N4J/Ft50qY44hETVB1tZjsqx9ZlS9dNKZAsLpHGSO8FACnwrCqG810h3CDeaL
 65BBIYhRf2BrRAqCOcSFaY88KczKtm1ftbVtUFEQ1DVkciPm9jz1i0BGWd9psaXEJv0wp5XMb6
 Lpmr7uegsigWPnJd0xEqRC0h
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2021 21:55:40 -0800
IronPort-SDR: dLULgnkDoEfPpcGIu/1UAKB08AXk6w+fimAnH+hguFlGZY8sFk4UGNh+rTAqqyR5jgLvy/jDnG
 LKCuMjTpCEIu4k0Ld0KAaZEQQQ54kujuQXfyY7zGBsqY8mPk0u5BrWbjr0ks3ZpjEf77geJx/z
 rOSyA/JDCcYxEpJi2qzLjYFRzJm36tXZ3SI4JJF8fEyV/ke0MMggCnuiKG3yTPtts3liszCn9o
 GSf8ge6dfCp0p8dlkfLseWnjuolrlJGPQNrMZdVRRwtPShUuOX5hNoioemUVxb7BcIPeiExw2o
 BP4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Jan 2021 22:10:46 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] null_blk: Fix zone size initialization
Date:   Mon,  4 Jan 2021 15:10:44 +0900
Message-Id: <20210104061044.664481-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <160915617623242@kroah.com>
References: <160915617623242@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0ebcdd702f49aeb0ad2e2d894f8c124a0acc6e23 upstream.

For a null_blk device with zoned mode enabled is currently initialized
with a number of zones equal to the device capacity divided by the zone
size, without considering if the device capacity is a multiple of the
zone size. If the zone size is not a divisor of the capacity, the zones
end up not covering the entire capacity, potentially resulting is out
of bounds accesses to the zone array.

Fix this by adding one last smaller zone with a size equal to the
remainder of the disk capacity divided by the zone size if the capacity
is not a multiple of the zone size. For such smaller last zone, the zone
capacity is also checked so that it does not exceed the smaller zone
size.

Reported-by: Naohiro Aota <naohiro.aota@wdc.com>
Fixes: ca4b2a011948 ("null_blk: add zone support")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/null_blk_zoned.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 2553e05e0725..5f1376578ea3 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -2,8 +2,7 @@
 #include <linux/vmalloc.h>
 #include "null_blk.h"
 
-/* zone_size in MBs to sectors. */
-#define ZONE_SIZE_SHIFT		11
+#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
@@ -12,7 +11,7 @@ static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 
 int null_zone_init(struct nullb_device *dev)
 {
-	sector_t dev_size = (sector_t)dev->size * 1024 * 1024;
+	sector_t dev_capacity_sects;
 	sector_t sector = 0;
 	unsigned int i;
 
@@ -25,9 +24,12 @@ int null_zone_init(struct nullb_device *dev)
 		return -EINVAL;
 	}
 
-	dev->zone_size_sects = dev->zone_size << ZONE_SIZE_SHIFT;
-	dev->nr_zones = dev_size >>
-				(SECTOR_SHIFT + ilog2(dev->zone_size_sects));
+	dev_capacity_sects = MB_TO_SECTS(dev->size);
+	dev->zone_size_sects = MB_TO_SECTS(dev->zone_size);
+	dev->nr_zones = dev_capacity_sects >> ilog2(dev->zone_size_sects);
+	if (dev_capacity_sects & (dev->zone_size_sects - 1))
+		dev->nr_zones++;
+
 	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct blk_zone),
 			GFP_KERNEL | __GFP_ZERO);
 	if (!dev->zones)
@@ -55,7 +57,10 @@ int null_zone_init(struct nullb_device *dev)
 		struct blk_zone *zone = &dev->zones[i];
 
 		zone->start = zone->wp = sector;
-		zone->len = dev->zone_size_sects;
+		if (zone->start + dev->zone_size_sects > dev_capacity_sects)
+			zone->len = dev_capacity_sects - zone->start;
+		else
+			zone->len = dev->zone_size_sects;
 		zone->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
 		zone->cond = BLK_ZONE_COND_EMPTY;
 
-- 
2.29.2

