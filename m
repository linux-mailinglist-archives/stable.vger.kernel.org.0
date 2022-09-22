Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9A05E6691
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiIVPPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbiIVPPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:15:08 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8534E8A1F8;
        Thu, 22 Sep 2022 08:15:07 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id o99-20020a17090a0a6c00b002039c4fce53so2710852pjo.2;
        Thu, 22 Sep 2022 08:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=b8FlLJK2ARDYSYn9U9fBax1ZwPEDvob1A6FgFAjjlgs=;
        b=QDgelsy4pP1kkhIVvBtFMe2c5FUycAbW+BEWhXnAhwS7AI1S0pCZ8CFXCCgt0T5Khh
         PIl0kNNsxHpWf2Ncb/9cFBnjTzWB5UHsSQ/nMaO5ubxlMGodUDwYyCl4uY7+0/o+Itpy
         auqqMvoKZqe91LNg9j7wx0Lbup07zhoAxa35o40MZvUizo6jGPaLO9u3K7IoPIAH7I6F
         mMx5WpHBGjanb0OBDw4+EkTqRWtzDjRY/3mpImBzYpUfCT+dKUiP/CEyWB2GZ13/SWoM
         mnX0WJ33Ag45EY9fiPurnQyzmdTzl+D2FJ5qHr1pyf+uCPdSJUFuNPbnP6Phqw5bUMcC
         36YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=b8FlLJK2ARDYSYn9U9fBax1ZwPEDvob1A6FgFAjjlgs=;
        b=kVIpnxVadZLhA1DVl6GjbcorsctbrTmaxOpTtUGCue2av17gCkFvQXFrd4jgnlKeWD
         2VUv11Roy9shk6+uu5o5Ksj5D7I29PWrxrZlRXWMvd+PdXv1CVMEDqY+xh3ldGQUE6La
         5IxJCW8siQzf7cTAIfF6avbImya/K3W+7SDPnkc8a2FBDfmWYNEaoFtt7GFPuszfZkSm
         wRT9zOdbn5EMZevYs7adc1kL+SoJIrE+/GOxzmq+q6hhzFnuFUwIPWogSS5sV8372SUb
         cGXyGt9q7XHzBq+AhZmvFd3qSknZMWR4UGE3oOyL55emHlYhLSCZ74iXDeSgqbdz2tCg
         w33g==
X-Gm-Message-State: ACrzQf3Mn2NqiLHshBjoutSDAk/s+aGJWO8XjzPwMJ9c1tTzcr0jWStf
        D0u7549cBhpB6fUwIdHk4clYo2/9RfU5PQ==
X-Google-Smtp-Source: AMsMyM6W9EZa0ACyVOgTqrATOz560/kgmIV0YIb0IN13yBnwV23sMcVdHJrZknjjQHajRewUI+o1XA==
X-Received: by 2002:a17:902:cecc:b0:177:f3f4:cc90 with SMTP id d12-20020a170902cecc00b00177f3f4cc90mr3756202plg.83.1663859706402;
        Thu, 22 Sep 2022 08:15:06 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:500f:884a:5cc3:35d4])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902db0a00b001745662d568sm4226042plx.278.2022.09.22.08.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:15:05 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 5.15 v2 1/3] xfs: reorder iunlink remove operation in xfs_ifree
Date:   Thu, 22 Sep 2022 08:14:59 -0700
Message-Id: <20220922151501.2297190-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
In-Reply-To: <20220922151501.2297190-1-leah.rumancik@gmail.com>
References: <20220922151501.2297190-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 ]

The O_TMPFILE creation implementation creates a specific order of
operations for inode allocation/freeing and unlinked list
modification. Currently both are serialised by the AGI, so the order
doesn't strictly matter as long as the are both in the same
transaction.

However, if we want to move the unlinked list insertions largely out
from under the AGI lock, then we have to be concerned about the
order in which we do unlinked list modification operations.
O_TMPFILE creation tells us this order is inode allocation/free,
then unlinked list modification.

Change xfs_ifree() to use this same ordering on unlinked list
removal. This way we always guarantee that when we enter the
iunlinked list removal code from this path, we already have the AGI
locked and we don't have to worry about lock nesting AGI reads
inside unlink list locks because it's already locked and attached to
the transaction.

We can do this safely as the inode freeing and unlinked list removal
are done in the same transaction and hence are atomic operations
with respect to log recovery.

Reported-by: Frank Hofmann <fhofmann@cloudflare.com>
Fixes: 298f7bec503f ("xfs: pin inode backing buffer to the inode log item")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb7a97cdf99f..36bcdcf3bb78 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2599,14 +2599,13 @@ xfs_ifree_cluster(
 }
 
 /*
- * This is called to return an inode to the inode free list.
- * The inode should already be truncated to 0 length and have
- * no pages associated with it.  This routine also assumes that
- * the inode is already a part of the transaction.
+ * This is called to return an inode to the inode free list.  The inode should
+ * already be truncated to 0 length and have no pages associated with it.  This
+ * routine also assumes that the inode is already a part of the transaction.
  *
- * The on-disk copy of the inode will have been added to the list
- * of unlinked inodes in the AGI. We need to remove the inode from
- * that list atomically with respect to freeing it here.
+ * The on-disk copy of the inode will have been added to the list of unlinked
+ * inodes in the AGI. We need to remove the inode from that list atomically with
+ * respect to freeing it here.
  */
 int
 xfs_ifree(
@@ -2628,13 +2627,16 @@ xfs_ifree(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
 	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_iunlink_remove(tp, pag, ip);
+	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
-		goto out;
+		return error;
 
-	error = xfs_difree(tp, pag, ip->i_ino, &xic);
+	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)
 		goto out;
 
-- 
2.37.3.968.ga6b4b080e4-goog

