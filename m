Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC89F7BA53
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 09:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfGaHOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 03:14:11 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:30791 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfGaHOK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 03:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564557250; x=1596093250;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=lkzBGUI6nB3LWel/uaLlvIbKLUkKS064gVvO2djM8XQ=;
  b=qGUvy7MvuuDxclrp2pToOgBQrSkrtVbiu6txstau/ahAfZgvRm22pDAC
   oCBY39P9ts+ioXCKTrAMdDx9xp9EfHMkAPIOXsUC2Xlag90X6a2jbqa3I
   f1e36xH1hOtFkJOBfl1R3spf/Rb1mM7A45+Nm9hR2T6owaYEs9eewVQjf
   U=;
X-IronPort-AV: E=Sophos;i="5.64,329,1559520000"; 
   d="scan'208";a="407396707"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 31 Jul 2019 07:14:09 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id DD2E0A2969;
        Wed, 31 Jul 2019 07:14:08 +0000 (UTC)
Received: from EX13D17UWB001.ant.amazon.com (10.43.161.252) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:14:08 +0000
Received: from EX13MTAUEB001.ant.amazon.com (10.43.60.96) by
 EX13D17UWB001.ant.amazon.com (10.43.161.252) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 31 Jul 2019 07:14:08 +0000
Received: from dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (172.23.196.185)
 by mail-relay.amazon.com (10.43.60.129) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Wed, 31 Jul 2019 07:14:07 +0000
Received: by dev-dsk-luqia-2a-c7316a94.us-west-2.amazon.com (Postfix, from userid 5038314)
        id 3155D87441; Wed, 31 Jul 2019 00:14:07 -0700 (PDT)
From:   Qian Lu <luqia@amazon.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <trond.myklebust@hammerspace.com>,
        zhangliguang <zhangliguang@linux.alibaba.com>,
        Qian Lu <luqia@amazon.com>
Subject: [PATCH 4/4] NFS: Remove redundant semicolon
Date:   Wed, 31 Jul 2019 00:13:27 -0700
Message-ID: <20190731071327.28701-5-luqia@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
In-Reply-To: <20190731071327.28701-1-luqia@amazon.com>
References: <20190731071327.28701-1-luqia@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangliguang <zhangliguang@linux.alibaba.com>

commit 42f72cf368c502c435af4e206e26d651cfb7d9ad upstream.

This removes redundant semicolon for ending code.

Fixes: c7944ebb9ce9 ("NFSv4: Fix lookup revalidate of regular files")
Signed-off-by: Liguang Zhang <zhangliguang@linux.alibaba.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: Qian Lu <luqia@amazon.com>
---
 fs/nfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 85a6fdd76e20..9065db7c31eb 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1635,7 +1635,7 @@ nfs4_do_lookup_revalidate(struct inode *dir, struct dentry *dentry,
 reval_dentry:
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
-	return nfs_lookup_revalidate_dentry(dir, dentry, inode);;
+	return nfs_lookup_revalidate_dentry(dir, dentry, inode);
 
 full_reval:
 	return nfs_do_lookup_revalidate(dir, dentry, flags);
-- 
2.15.3.AMZN

