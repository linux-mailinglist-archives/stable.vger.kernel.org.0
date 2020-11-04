Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE1C2A5DE2
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 06:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbgKDF3S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 00:29:18 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:58833 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgKDF3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 00:29:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604467756; x=1636003756;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DejHE429z9eWDGx3yXqKuJIvmXLZ70CJHmBbvNQ0/Xw=;
  b=PvPkM16o2xvEMdv/0yWwEbSH74KSIENWBUM1J7ItmSeqB1wpf/Rn0Sb8
   qZ+3uwxI+tJ73ZPQehkaZ2lg8hd8WaURVzjWezWSOMmFSgc5kx0BhqmG3
   /w67j/lBWtuYa7W3TmRnYwqVDz6IXXY3PwLMbWut6H51LV1GtvUyClumJ
   WqBkWPFRli6giQwCdjt0Dc6XFZIZmmnQUDMdPUhxhPWqm0Ikx9JChHiGE
   53FaG9V/sVbgV6nOfdSPu1vKbPFF2t3WKpC20uTk/kFu4pl0AULwMLCn9
   fuHOZbbBbi+FioqW0KYnsDv4lOSm+U+npAt/kBAbIPce7Xw7s+a6/HTdZ
   g==;
IronPort-SDR: LSINSg/F14KfpCYtyCOxI0vAIjdRsCw0TpVWL0/kNLqay1mFnZ5CkR1lB50hwcnGTGItoDpeGl
 DPND3WJd0k1yyHjOleHsLU3/TIYXSkSQjDDiJCht2qfv66ntI8z4G1o1dp2IyswhDtykzgnGGr
 rBnaqkfvrrIVkBXEHQJP9EouQtHcjNzuVA6uX0z1K/KlTY7vA/NNyvhOLCH3l8Fhky4FN0sYHK
 F5hoqXmJGUlri94b/H9lwN/vFEGwHwo2UlTYR42DH0iAT1u33sWjB40SAYAfdyJBvFlucSqV4O
 Jtg=
X-IronPort-AV: E=Sophos;i="5.77,450,1596470400"; 
   d="scan'208";a="151659163"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Nov 2020 13:29:16 +0800
IronPort-SDR: AV+gmQBHYxnbYXgszviOTS1WhiMI+AROmAFrZ60fDPJa/K8NXl/0vV2k7nBpZs80wabASQxYMO
 GNOYHbhijNIurfPzGwjdYdZe7w+G1laaIHCabLvbT4LwWa38J3DKuGWpRz0O4/SgAPP0eMu536
 VLn8OkQMIFNAdEGstX/kc2QGkyDUKjaXc41NipI8eh6ojQ3VG1J5qpJIpyrFRilnu8bStZpgZP
 etCiTNa3SjsRKZcuurabBnQWMkpz5F1L1lOhn1tHqhfG1ODKP0WKEBKuxcDqufvtQHo4ztzEYi
 asj3xhpOh2c9LnL/zR+Z28Jz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2020 21:15:25 -0800
IronPort-SDR: JMGJ+I/37AdpA5fUDrX/bYK0T97Jjy58z/QGu3efJFHebIBZCCd0vRERKw34k4xCp05ld2YdaE
 CQQsOv/mZIARNmRA2k3ficfEs/+cKUeKwbjaXD4BtYSlAFTfplFPf+ytra2qGc3FjkcXW11sG7
 lh22thrS6DFgtMCj2lj4j4iGZvan2g45H6lKX1PEhBindMOtFAxq0tBgHX9cmxjeesLtkQwjkH
 bGvGy+VcC/Z6D9cC/JpmKx/T3TCRFBMQ/CtrNTgtswa44N04uYFj2qil33agTuCNmooUfDb6FI
 Muw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 03 Nov 2020 21:29:16 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] null_blk: Fix zone reset all tracing
Date:   Wed,  4 Nov 2020 14:29:14 +0900
Message-Id: <20201104052914.156163-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <16044134474538@kroah.com>
References: <16044134474538@kroah.com>
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
index 3d25c9ad2383..fcbbe2e4ef2d 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -226,13 +226,15 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 
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

