Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23692E9496
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbhADMMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:12:55 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbhADMMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 07:12:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609762374; x=1641298374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WOkVvBlAolqBYc0Fe+jndW0JCMpg6L8cuudIqLxQWc4=;
  b=rF7qn6ulGDR0rHPBx+TrrE1V2Fg1A0M2Jqw+7zRV/aTqfL377hRfYAkr
   wPYMY7PggSiYmgjOVjagK+wPZt3jA4Z/t8sk3GwvDrpbAmiGRmWm1UNOX
   i71rBeXVKid30EizQ+L1nGAyOUp8AW33t2990dmizKpVN/VT81PT+4L7O
   S8b67TIi0RWq62xvyvBvSoR4+Ma5YjunaoaGQVYids6ZBts0cQ3s7sO6p
   DnCU7Y179ChOStHfKIY+gx5JDN0NpwgtK4yBBL8ONzIegzGu3LZvggm97
   qjKdF/iaiER4SHWPYucQs8SzojxXUMSQkOrW7yDVR+qIWeuN01UINohUL
   Q==;
IronPort-SDR: 0IYQrsQ0mrj1EXHnh3eYtIw5AAtQFUEtVhs31ZjmdrfqxmSnuLHNEtE7IxPvd3NW4hZtBk5ThU
 S9cj4NSlRphbay3QqDnkf+x/wdZdWa2hq7LqX7akdxVUShqG9Yv1aC7jWnhtsARMYTtw5dycRN
 ziVjwwqqllQjQKpaGJsaF2bewqlg2acauO2dT4T3qUAEb9AtyY0d4IFs9k7JXwEDRDcQH0VAlq
 DPeLujnVLLtGl3vksmvrqhZYz8n6So/muHp3V3ee347omWxSpiRi7zjaKPXc6OkxdkIDAf6XHt
 Lz8=
X-IronPort-AV: E=Sophos;i="5.78,473,1599494400"; 
   d="scan'208";a="157680953"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 20:11:49 +0800
IronPort-SDR: M5BhRiNThPp9TOqSqSUwBaKV1eS7+8cd812rDQoJNfbEVnEKOfQiH0z3IppWzSm9TymZkp1oge
 fWqb9LNgNN/36R0oZjtxwSDii74VP6J9i8pR28kaFCAdxS/1nTuFyZSMZZMeoP7CtGUpk9y6Y9
 6wo84er5yhkuJrsAbm1D++0MFYaVF6zijyBP7HJ3LcBCk6TlrK9UCthJVh1ljwk0j67S8Bvioa
 xPf2KoKu1wEUjkCs01gYOUqVGGsKIcUyO/IjKN/D4/1fhFyfn4Ht3TqKia3K6jAwEr6p4URzTz
 hUxJLeWJTk1+ngtr15R4cJvL
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 03:54:58 -0800
IronPort-SDR: duFkP3M7AoZWwGC0+wagz71mCVtVdBQ4KDqVBTG0vRL9/p7J0z7sL1SWcHBY1yWsr1cyOxTRMU
 ZvkW8fh2IFtOhugYOWPUeZSixuZWq0rOi3FL4Wsf+Vnx1a8aNm9CN/9mnYzPtkYMJqkw1d8VHF
 GMmDlwH7+jY7/BeIOWF2lpILcSQ0qAZkINAd7I+JHo9luv5E0ay57SmH22s3XjhKZzvpSIRrsW
 q/+cgD4Yq450O9ARsAG7hvlrtDwfEof5qjzaEJfjq5VUihi2ObmcsjmKiOsj+NHyPhs/MQLVzX
 KA8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 04 Jan 2021 04:11:48 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] null_blk: Fix zone size initialization
Date:   Mon,  4 Jan 2021 21:11:47 +0900
Message-Id: <20210104121147.809755-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <X/LzaLYN3k0JFJw3@kroah.com>
References: <X/LzaLYN3k0JFJw3@kroah.com>
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
 drivers/block/null_blk_zoned.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index d1725ac636c0..079ed33fd806 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -1,9 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/vmalloc.h>
+#include <linux/sizes.h>
 #include "null_blk.h"
 
-/* zone_size in MBs to sectors. */
-#define ZONE_SIZE_SHIFT		11
+#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
@@ -12,7 +12,7 @@ static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 
 int null_zone_init(struct nullb_device *dev)
 {
-	sector_t dev_size = (sector_t)dev->size * 1024 * 1024;
+	sector_t dev_capacity_sects;
 	sector_t sector = 0;
 	unsigned int i;
 
@@ -25,9 +25,12 @@ int null_zone_init(struct nullb_device *dev)
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
@@ -37,7 +40,10 @@ int null_zone_init(struct nullb_device *dev)
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

