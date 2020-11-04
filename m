Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59A92A6346
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 12:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729735AbgKDL1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 06:27:53 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:59003 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbgKDL1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 06:27:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604489272; x=1636025272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vdi1ApCHZpH4AkXakQaMo1J97t5TbGpzpo7jqlShLQY=;
  b=DIRHeI5FpMlcjuKlvMmLQn0rc29mBX7pnodvrpFgtzuQuMWlxGCIQqVl
   br7XkFryoqnAo7+lQgE7VymPT6TRyCIX4skSRUCfBo15FhzxD5Me7M9f8
   H0aIohmS1IrUOKVGskFgmAI3Myi1AL/EfwmrP12NY+PVfncnAy171rJ4V
   aiy9bqnQ3AL+QYN0OZRlL+XHOBmc/XR+lRh3lLMP4kuNdn/2JEhTW14p3
   UvUFCGf5dFYgg92b7bBrVLV0/a/syvZQwtxBV4Riqf19SlIsBn7rhT15Y
   QZmVUTbX7rL2JETEWzfDDiMt9llyDzTGgxMMqwhI+kdeWYGq0xIYlX77/
   g==;
IronPort-SDR: MUpNWdGmTedK0/dhHbV5pc9qYCCU4inI8zLZ/oepC8hXi8xNrexX+rKwI7nN57vKtP2PCn+i9P
 rq+/7MLqLmEDknxQvoWaV/WVVQATWr55WhcTyHaYXVszcTF3cdQ+FsLhb334aw71aYVUxxCwEl
 wp2lPbcsvsGvfeytHNUmBvCGcHhvLMYQIMja8j292fdUy7NDMtJBa92ZzIN6PWoB/JOovzLSZh
 4WGDFWrqNOQKQG/3IlS1WFKVKgw1yoC53xg/G0heFvKt0F1+1yaooIpwZSNhPgCRqKp3C41l2I
 2rs=
X-IronPort-AV: E=Sophos;i="5.77,450,1596470400"; 
   d="scan'208";a="151681630"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 19:27:51 +0800
IronPort-SDR: ppcj6/ekwiH7rILo1VPaFZ2nqDGmDIIa4QSwQDosgW1HJR2AOngWN+cNKyFbooiiBwrJx88HBI
 zH8cQtbZIe2MsWm09BkXtUtPNiXJZPtnuDCvxnFd0ROYf3MYn7c/ZgTTjUKiIAUoTlQI34FAbG
 iUHO/0AxR7J+RA+nUhC4bBzIh4+JnxuFSXFTOqpe6HTefS6pEhaNZ9ZtbtcIvuBCmRVrvWCs+r
 sGqMXb2gn2skL1TDJdALLwbPsg7wZQr+OIW8Ajcaz6hP7iJBtfOFqlxauSp2zHL4Yw6kkT1uBV
 /86mkxEGNGdyKRoCNzIb5f9b
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2020 03:14:00 -0800
IronPort-SDR: cBQhpCqmEeSH4e5j5P2RqoKuIpChAlwWQlb3oONFvCWZKcWaldCcc3g4g609s2llUtoHm5Y01r
 Kx+CXfjVpvt1raIxBSkb+OjcdV+CmKn9JvOqo6GUgH6QBDvvyBrQXr1P98pFUevgUb/JHyv7Sa
 NbwrOuX3EfrDs7N5jrsDaMBZF4PFwz5D0VxPRAb3RNcvNjiA1sYeacAmrjhVZttW6gh8tWPL4F
 OpTotH3ExO1Kw0ZLfMKHYaih/QAS6Ee6UMCJJ+4eSekcDfU3vzYK9UNRLPyXSn9NWqXJ4zw6KU
 aaA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Nov 2020 03:27:51 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 2/3] null_blk: Fix zone reset all tracing
Date:   Wed,  4 Nov 2020 20:27:46 +0900
Message-Id: <20201104112747.182740-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104112747.182740-1-damien.lemoal@wdc.com>
References: <20201104095141.GA1673068@kroah.com>
 <20201104112747.182740-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f9c9104288da543cd64f186f9e2fba389f415630 upstream.

In the cae of the REQ_OP_ZONE_RESET_ALL operation, the command sector is
ignored and the operation is applied to all sequential zones. For these
commands, tracing the effect of the command using the command sector to
determine the target zone is thus incorrect.

Fix null_zone_mgmt() zone condition tracing in the case of
REQ_OP_ZONE_RESET_ALL to apply tracing to all sequential zones that are
not already empty.

Fixes: 766c3297d7e1 ("null_blk: add trace in null_blk_zoned.c")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/null_blk_zoned.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index e8d8b13aaa5a..0342696db0ce 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -230,13 +230,15 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 
 	switch (op) {
 	case REQ_OP_ZONE_RESET_ALL:
-		for (i = 0; i < dev->nr_zones; i++) {
-			if (zone[i].type == BLK_ZONE_TYPE_CONVENTIONAL)
-				continue;
-			zone[i].cond = BLK_ZONE_COND_EMPTY;
-			zone[i].wp = zone[i].start;
+		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+			zone = &dev->zones[i];
+			if (zone->cond != BLK_ZONE_COND_EMPTY) {
+				zone->cond = BLK_ZONE_COND_EMPTY;
+				zone->wp = zone->start;
+				trace_nullb_zone_op(cmd, i, zone->cond);
+			}
 		}
-		break;
+		return BLK_STS_OK;
 	case REQ_OP_ZONE_RESET:
 		if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
 			return BLK_STS_IOERR;
-- 
2.26.2

