Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DADAC29D589
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbgJ1WEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:04:50 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20568 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728159AbgJ1WBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:01:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603923387; x=1635459387;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t9BTLL/KaYlKTWTt9H9j8nSxLtfePywSdxGReXSUWXk=;
  b=C2yEWrBpASLk4VnPSVFNZ4X6eKIGzwHE5U4an1Ds/gQ2qSG486vBPuFn
   l9IKKMv0GcX++q5T/uf4wKpzshqlLs5zWBc58FR96FL+pWSW6Krc9GQJS
   ech6fGkq85A4V8adBrjzbU0Np/FNts94hoVJd4LByazSqp/jyXWaOrDSt
   A0kz84E4s17OzpsEC9kwzPZoE1xnXur3d5wrTBtFG8r9fZVP04+CS2JiP
   wq6btIE6OZnUMTMu6EUN7CodlB7UAMQl3/EHSLl9JO4hltsMaWev2HiqX
   HdzRrlVZE9N6kT+ff+hdF2bKALmrVygHOdSLeAwjb5ZVLcEvYW1e68tp6
   A==;
IronPort-SDR: rSLdlvAay43jdPx2tB14JuMFB1Erh2Nba+pcYQVL9mqpIxKkqt2BL03heipRo/pq5Kq09XKVH/
 rk3mpgjQEBggXWs4A9INzlCKBFlR1EcRt+uN01jISSMPSwGxwdGnvlrMliYKxllcJ/3frYdfAJ
 d1nhIOibry8ZC2EfOWvRbT1hR1mmHdgr5MCA1i566dajrAHkSIukxhVlXtzoEzanaY2dXny2/I
 T2hbJON3QLB227ymCLm2s5aE8mvkiEY3kKXcl0N1i0f6O/1X61IPbqzTrnbRneuIbBOwJ7x8PZ
 wn8=
X-IronPort-AV: E=Sophos;i="5.77,425,1596470400"; 
   d="scan'208";a="254622937"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2020 15:39:06 +0800
IronPort-SDR: CO/Y+PBqnXeBsRbtajN9qN5D35CCkXhzIaCziM8Mxj8ON+GEIHWWKWR353VJKxcvrzYD3d7BtR
 u6DzOCp+9p2lM2i3zgbtX2eoS8lGe/NFsMS4UPurHM1/Z66vaYyb7rDv9NgSvm9lVWl40xFP9s
 mtWTG+htrTyvtfzZXpRgflrLzi3ZG0Am8bg5Umx+7I8wWOd1vtPCNUYbjTff1BYFYHfdEnwnkI
 rdWBibEePbkArlBVvV2yDgC3rl2xj4xOO8VlrOv4tjuWkH+t86hFvqqRCn3huehHOezmR104c7
 nmYPv+RhSAM5oHZAF5LGdEnf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2020 00:10:51 -0700
IronPort-SDR: 3ilwfNzJlC+b7quw8/GVFka+o07dRt2HgVGIcAmcYf6tlTaK0OJTb1PTc94Wzj7GmUFiETc8jd
 xxUvdirPD4GniobgTn6z0YvWcClcEfh1tMPT0CdGEkkxM5LERGEZGgOl/rSqm5+6jOjKDeOs1j
 0R5qBSooSqOwoi+pI+NfQxERxF5o9EqahftQCUuVYtW8wiG2w34uJfBi4eibmFMJxZJGCXI9sC
 g3XMi2q54TinVFDHmk+XvzcTZvv/2gXi+pAwaxefaD+iF06BpMfMNb1umtabzoDSeWpstkOPlY
 dmE=
WDCIronportException: Internal
Received: from naota.dhcp.fujisawa.hgst.com ([10.149.52.155])
  by uls-op-cesaip02.wdc.com with ESMTP; 28 Oct 2020 00:25:40 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     axboe@kernel.dk, linux-block@vger.kernel.org
Cc:     johannes.thumshirn@wdc.com, Damien.LeMoal@wdc.com,
        Naohiro Aota <naohiro.aota@wdc.com>, stable@vger.kernel.org
Subject: [PATCH] block: advance iov_iter on bio_add_hw_page failure
Date:   Wed, 28 Oct 2020 16:25:36 +0900
Message-Id: <7e91d39fccbd06efdee40ad119833dbfeafd2fb7.1603868801.git.naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the bio's size reaches max_append_sectors, bio_add_hw_page returns
0 then __bio_iov_append_get_pages returns -EINVAL. This is an expected
result of building a small enough bio not to be split in the IO path.
However, iov_iter is not advanced in this case, causing the same pages
are filled for the bio again and again.

Fix the case by properly advancing the iov_iter for already processed
pages.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Cc: stable@vger.kernel.org # 5.8+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 block/bio.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index e0d41ccc4e90..2dfe40be4d6b 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1082,6 +1082,7 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 	ssize_t size, left;
 	unsigned len, i;
 	size_t offset;
+	int ret = 0;
 
 	if (WARN_ON_ONCE(!max_append_sectors))
 		return 0;
@@ -1104,15 +1105,17 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
 		if (bio_add_hw_page(q, bio, page, len, offset,
-				max_append_sectors, &same_page) != len)
-			return -EINVAL;
+				max_append_sectors, &same_page) != len) {
+			ret = -EINVAL;
+			break;
+		}
 		if (same_page)
 			put_page(page);
 		offset = 0;
 	}
 
-	iov_iter_advance(iter, size);
-	return 0;
+	iov_iter_advance(iter, size - left);
+	return ret;
 }
 
 /**
-- 
2.27.0

