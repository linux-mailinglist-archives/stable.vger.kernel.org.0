Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1765E6783
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiIVPrl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiIVPrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:47:39 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4991DD4AB8;
        Thu, 22 Sep 2022 08:47:38 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id g3so16152827wrq.13;
        Thu, 22 Sep 2022 08:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=esm7WY5NBPF0ohza2iIRHTShjFzVuQEeXBALGm/uCz0=;
        b=MyLwk/SLFuOXKgvB8C5O1u2jCAY+nGX2svUIJEQkDE2zJogq1pGm4wN2wWMsQqFmw8
         9AVfevYUqvm0zsB+x6y5j9ZmJZFKwbVTfjKi8Zwtchw/Jk8y8CEtsesIdi4jkuCW5PO9
         a2Aiota+7TncWV+4tbW8MtF546Vg8Zg01nKKAa3iEoWdrs9b6jYigTGenlYaTtWbQpYs
         qUcu28+YTSNvHsPJU+gVtmeRdjyy9DKciQXif4bBYiwEFpS2Q1qLnDgKHVRMMAMpfHC8
         3GZQzQd6z98Ke7zxcHmnerk8wdVk/WCwXDvrXQCfTnBGKB2eSoS4kOkWR8iq0sp3OC1k
         nwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=esm7WY5NBPF0ohza2iIRHTShjFzVuQEeXBALGm/uCz0=;
        b=awXjA73tO+8qnCnaG75XpKP3R5uc7M9Y6aMWvqH7akLKaXj7/pnLLANno5fARppW/f
         MixWy6r/wYqw/IGMZhTFWnDI/5Xbdwtqhg15JhzbAnJk9wFt49yQYi95indap6Ls4PQa
         oQaIsR67v3A8WIV2SB4mMeN1Ij2tbrOCHYzueOfQd0kHzXebrTYiq2eHzxn9jKenF0K7
         VG8RiiBRAUxcXHrg7ozP1+oX83BTbdKYXyecdyd7P6kmBK3AWDRE0ihnUmk+sChrF/XP
         d/t0521V00leJhveXTRpa4qAwxyPT+PBkLqSO2xMoH4a5MubzxzHsPLt/zW6Mh6q0jPB
         U2Qg==
X-Gm-Message-State: ACrzQf1DofNmxheOUGROYTwnxit50o3m9nkRZ/98i0di9VOWmC4TFfVh
        fhxiA995HfxPWrU0RnKSSmU=
X-Google-Smtp-Source: AMsMyM4l3WSuMnmkT345QdBeqMLVAjYxVv7j6L2I9vAsNxcZo9Fxx9ZqY92LQWuhMbmPBh0MgnPjoA==
X-Received: by 2002:a05:6000:178e:b0:22b:451:9f63 with SMTP id e14-20020a056000178e00b0022b04519f63mr2418147wrg.521.1663861656557;
        Thu, 22 Sep 2022 08:47:36 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id z5-20020a5d6405000000b0022af9555669sm6272386wru.99.2022.09.22.08.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:47:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 1/2] xfs: reorder iunlink remove operation in xfs_ifree
Date:   Thu, 22 Sep 2022 18:47:27 +0300
Message-Id: <20220922154728.97402-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922154728.97402-1-amir73il@gmail.com>
References: <20220922154728.97402-1-amir73il@gmail.com>
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

commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.

[backport for 5.10.y]

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
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1f61e085676b..929ed3bc5619 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2669,14 +2669,13 @@ xfs_ifree_cluster(
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
@@ -2694,13 +2693,16 @@ xfs_ifree(
 	ASSERT(ip->i_d.di_nblocks == 0);
 
 	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_iunlink_remove(tp, ip);
+	error = xfs_difree(tp, ip->i_ino, &xic);
 	if (error)
 		return error;
 
-	error = xfs_difree(tp, ip->i_ino, &xic);
+	error = xfs_iunlink_remove(tp, ip);
 	if (error)
 		return error;
 
-- 
2.25.1

