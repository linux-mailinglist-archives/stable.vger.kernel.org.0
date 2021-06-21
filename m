Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9045D3AE144
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 03:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbhFUBXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 21:23:42 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2001 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhFUBXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 21:23:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1624238487; x=1655774487;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r4qQ1DBnwaxTyifpYRp7XPW4WMROSMnkVBUAd4SQZ/k=;
  b=QsyDsENhaNKYZP/BLKCCRDxFh04SWYTnEB3nY+nLb9iirEIQgbMdoDnr
   8Fd2qB9c/DSaTJ2CyI405w8hnz5WylTuSDZtssxZXaepH4yTz+clwE06B
   gxdE6kwVT6WnPa5uViY1lzz3OT1DXxEc1JiZetR5bhKT6Gbc5s4AGkwj2
   NZFnH9uo1hf0FngKJasnZ6x45CvlBsMvrD0z7xLTmLymTFtzeU3xOuk4v
   cEgC2qdCDVW4TUe2KJc/Uc/N8sZpPxMEw19L3egr5s/5QQi6HHAnF+04u
   jRHPhIeKAPuSsNCbgOf4+DNVvYfZMjTyD9q7ZlCwtIGYYM6gyhZtZxAMq
   Q==;
IronPort-SDR: DlatUUn9ldELD+ComFjMv/FndR4Sv2B7FvN57wA6YBSKKqhO2PaQven84qB2R2DiGH0SXYsNzv
 JjDeAdjJ+p7gXK4BbiH8BsL/XfoR26p2EKZrtt5rGLxMM/kLXkjex6p10TZOCJvz1b1S9sTQx7
 qbeZqGVD2FSjkMEPZdf87cd6yu8vs9VzeAiTVZ5zDhmrZAlFRGV1IHcd6JNPOPZB5auRXVwh5D
 P8HQ7w8Syjf33tT0sKke27GNwJw9HpE4ZerNKmwsyVUUM9tqfdVQEehiTnmQq/454gqIUIri0z
 /qw=
X-IronPort-AV: E=Sophos;i="5.83,288,1616428800"; 
   d="scan'208";a="172438424"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2021 09:21:27 +0800
IronPort-SDR: g1lKHietdXp5+ZdsF310cGvHFkAf8dKu4TqOxUhWJOHV3VYfKjaYaLkfHxkjG6lv0WMrZaABTy
 +R9+/6OwRlYehUHxhGvro8wlC84xVx91SS5ckZM6C4D7pOM56GeB/UT9xGiaesKrF0xRNhdtxg
 0pg2eiEteKkDGisYQPDBi/4+C961i3WGmZL8GWKD180Em3GLuDNTg8WowfPqJgXiRVTwh1aQka
 9QriY4ajBlXw3TnHg9JhB8uhc/dajljPwAKFvfhS7vKTlmKJg+c5vAbOxRZ3QiV1HABXWKwn0s
 loiAjbK9SKiMmfDKix/DS57Q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2021 17:58:48 -0700
IronPort-SDR: NP7J8dozX1R4Bz30ZQYLgoHn9YWHvryHV9MQiEGPcVX0BUBzzZG+fNlvQUYyX1f3ZE5SwV1tmr
 Tgho2Xrm02NAmwZSCnMv7hUGzIvHE1zPN18xkwmv46+zdaLgWzpHKQT0Y+9GuSdfyowsGKzV/6
 aHmkX5JY0nKSQsmlm/iEnkeRw8+cRpAagNnUjjuMNzfVBFT7IaFEesrIOCCQglENjMm+Y4pHaa
 zwJ0C4U0d5DbMZ39QAo9KZ7VjF4/hXd5oDgMEjmzTmb6ZESFrD77hxJLKP61dBMPTXrNqL78FY
 Gqg=
WDCIronportException: Internal
Received: from 5cg0390p95.ad.shared (HELO naota-xeon.wdc.com) ([10.225.48.64])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Jun 2021 18:21:27 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] btrfs: fix unbalanced unlock in qgroup_account_snapshot()
Date:   Mon, 21 Jun 2021 10:21:14 +0900
Message-Id: <20210621012114.1884779-1-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

qgroup_account_snapshot() is trying to unlock the not taken
tree_log_mutex in a error path. Since ret != 0 in this case, we can
just return from here.

Fixes: 2a4d84c11a87 ("btrfs: move delayed ref flushing for qgroup into qgroup helper")
Cc: stable <stable@vger.kernel.org> # 5.12
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 fs/btrfs/transaction.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index f75de9f6c0ad..6aca64cf77dc 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1476,7 +1476,7 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto out;
+		return ret;
 	}
 
 	/*
-- 
2.32.0

