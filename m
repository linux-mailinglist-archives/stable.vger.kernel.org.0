Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35202E905C
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 07:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbhADGMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 01:12:45 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:34021 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADGMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 01:12:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1609740764; x=1641276764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ckx/H2KwqS9qvZo0XEOVN0N6iAMu2trO/IVWPqvsM7A=;
  b=GAvbYp839APJHhsPg8WLeJpapAaRhD0pIyB7amT/xfZTTT1iYT1K8gqG
   ww7HCl85gGF3Npu4ropOatgvBUDHipZoKXbhnKnL4/c7bD9kWLzDdh9jL
   mBoWCBH56PItZPGCmIDiCnUVUttLSQjuJlwJMMYQyhoO5iMH5uWTqJFTy
   CufylrgogUk7hR9Gv7DfBxkBxyCwDQb7OIMFbCUj4ce5V/pvgPMeJEd0D
   QZKyFNDmfriWihXjl9OSLmAKJhu8yTxE6k/SwjeURpstW7gVHKYjqmB+D
   34MLMygMRLS7E5e3nqU+4AEhvyZ0cx1yvdKe+Aq7/rjVsGKFx6KOe8EEP
   g==;
IronPort-SDR: xqoal+QvNyuYNK/s8nEOyGa7lDL2x6d7PTp8CBUBW8ziZ8s2nBg5gWhCFmMHR8I4AL5g/1pMiU
 KqPhri+vOTVDm15hrCgWsak0YA238ubvBvSG2QXUatdtauyrjySfea7DKgejyVy6DlnNTITOfu
 /0RvqoMdXWXO4Edkflk1TxaeNW9zTsUaSBVW/5UlDUmiTwjAFuLZQGYANh3V6OIqx5IJIHQLiZ
 H7RuXkmriJiqi5xQGALDgg/ABp+IEGdvF5hxgmA8ls2DUG5bYZ046zbxijLEMHoMUuLz3g3xfV
 nBI=
X-IronPort-AV: E=Sophos;i="5.78,473,1599494400"; 
   d="scan'208";a="160881170"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2021 14:11:39 +0800
IronPort-SDR: zlJfdcKWxraypUk8oe4jWHLniDfiIqbGTQqO+NDtbJj09Xd9O0oiUn4fPv2/3lLVswi1oHsgf0
 H87VVvAahSxy341YZGBB5lw7OfOE2fZjqeKO6l6qiiPIvVa3F1C6gvG15PwvwpOPAgz8JirwOS
 LfsLgFvvsD9wx+5mhUXuoXc7Ec3ggNZaDs1ZExO7CJGnAFbnkuOVxq95sC/Qc5wbZnCZv21EqC
 +hT4+YvQXAXdplsFmcslaCgJrf7bQAyLrCNq0f0rRua3Cb4gLIqe2708A9sK6qtluhF8HDxCYT
 ImXjFZqpVsP5l2eyYHlVC+h5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2021 21:56:34 -0800
IronPort-SDR: UibZOxb/eqzfeXl39pcwPqmMINrRaopBzpvYSi/xNb2bXrxV1Bc0m+7H+ATlSlozcr2ufHR/dC
 vldntPFM0NrD83QBNrVtgbFkwCu9FwJNtaKydgPol/+hylrh8Pf8LkXXXrXHyi4F+GpzPawKgK
 u6/yEw5Y8Mu3corw7g5H4k2vtyWDHEEJipnuvRdvOTsOG1wemQgTVxT2PRp5v/qm0swhnuf1yY
 OgBr/RQrxoHhqmMdB13DXoYIADIF4Dfp409ZZn8ZyQw87m8wylF2owFXmhGN3n5UrttdrX2F50
 VrQ=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Jan 2021 22:11:39 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] null_blk: Fix zone size initialization
Date:   Mon,  4 Jan 2021 15:11:37 +0900
Message-Id: <20210104061137.664543-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <160915617556175@kroah.com>
References: <160915617556175@kroah.com>
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

