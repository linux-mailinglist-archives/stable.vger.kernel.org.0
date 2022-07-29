Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E55A58534F
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 18:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbiG2QQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 12:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbiG2QQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 12:16:27 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE7288770;
        Fri, 29 Jul 2022 09:16:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id os14so9378763ejb.4;
        Fri, 29 Jul 2022 09:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=1vza0IbNNeG9wagk1sAm/hz/5mjlvuw6L1//Kt2omTI=;
        b=BXJVJQis9nd5aAe3R8KuMxFrC7QuMGbgkynxgIzIscoJsT93LfUB4qGE3rrLHj//ya
         dXmmo7PD2qs+8jdcgo+LpNadhP+UiopN9LZE/+6gRtFPuaxZOrLZ84OwtpXNHYLe+spl
         CqjXL/z/kzXfJHxVPnEAWiRIPULIUtJSbryut/WuXKzBTd7oV/gzZpiGFOFqH/Qcbgws
         EIoEED8o1Dok9qpMxyQ2rgnBGJo+LmO2i09fVKukRo4Ii8rjn1NsSXRzcUT0bugh50ZL
         yTnbzhPqJBMJWpelyzLledwNBQEAbU33adP4CdG3zDfrPggC0q+o6aLjO12HPo9kHrX5
         XkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=1vza0IbNNeG9wagk1sAm/hz/5mjlvuw6L1//Kt2omTI=;
        b=J0TRJL3hfSvWHoeUeGXZ993A0cdLf1k3ZrygTp7kyUO/15gvlmFRZ3E3l1A+a/QYWY
         GLW0z9wlejaxX7DOouU2F5kaTyXmqKBKGWLeHND/WO4xT0DKvKOKErSyRqKCMWKyyl8u
         x/0SLy4DhGJ5vRywdNJa90tnCOAr/jxUCyjuOXIK7RYmM1qHdrMrP61JCT4GUGVVGhO9
         oqf0D23t7HT61F4RvGtCuRwecfAWSL975PlRrWU/MT2o/eCftQRl8ayrUezm75Ju34J6
         OTUr4kcAc3Ikpms8Xses38FtYBoQRUdWcQVgS0vEsUyfhilzxC8l3BYkbn1JgnpgBsOa
         EPNA==
X-Gm-Message-State: AJIora+dHtZYMVR3G3wE7z5VqElGYNbjpEWAYdIHpwvrcNlLEKQWDawu
        rynQDgAMWSazYbj/BGBYHKk=
X-Google-Smtp-Source: AGRyM1uTXuA4Y/eywy9OyE8n7fsK3B3QqbCePBric9sDCw/8blyPg4zU5GJ9q8t6PdQnIa5marOByA==
X-Received: by 2002:a17:907:8a16:b0:72b:9196:f029 with SMTP id sc22-20020a1709078a1600b0072b9196f029mr3481397ejc.359.1659111385530;
        Fri, 29 Jul 2022 09:16:25 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan (4.196.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.196.4])
        by smtp.gmail.com with ESMTPSA id fm15-20020a1709072acf00b0072b14836087sm1870116ejc.103.2022.07.29.09.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:16:24 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 v2 7/9] xfs: remove dead stale buf unpin handling code
Date:   Fri, 29 Jul 2022 18:16:07 +0200
Message-Id: <20220729161609.4071252-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220729161609.4071252-1-amir73il@gmail.com>
References: <20220729161609.4071252-1-amir73il@gmail.com>
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

From: Brian Foster <bfoster@redhat.com>

commit e53d3aa0b605c49d780e1b2fd0b49dba4154f32b upstream.

This code goes back to a time when transaction commits wrote
directly to iclogs. The associated log items were pinned, written to
the log, and then "uncommitted" if some part of the log write had
failed. This uncommit sequence called an ->iop_unpin_remove()
handler that was eventually folded into ->iop_unpin() via the remove
parameter. The log subsystem has since changed significantly in that
transactions commit to the CIL instead of direct to iclogs, though
log items must still be aborted in the event of an eventual log I/O
error. However, the context for a log item abort is now asynchronous
from transaction commit, which means the committing transaction has
been freed by this point in time and the transaction uncommit
sequence of events is no longer relevant.

Further, since stale buffers remain locked at transaction commit
through unpin, we can be certain that the buffer is not associated
with any transaction when the unpin callback executes. Remove this
unused hunk of code and replace it with an assertion that the buffer
is disassociated from transaction context.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 452af57731ed..a3d5ecccfc2c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -435,28 +435,11 @@ xfs_buf_item_unpin(
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_flags & XBF_STALE);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(list_empty(&lip->li_trans));
+		ASSERT(!bp->b_transp);
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
-		if (remove) {
-			/*
-			 * If we are in a transaction context, we have to
-			 * remove the log item from the transaction as we are
-			 * about to release our reference to the buffer.  If we
-			 * don't, the unlock that occurs later in
-			 * xfs_trans_uncommit() will try to reference the
-			 * buffer which we no longer have a hold on.
-			 */
-			if (!list_empty(&lip->li_trans))
-				xfs_trans_del_item(lip);
-
-			/*
-			 * Since the transaction no longer refers to the buffer,
-			 * the buffer should no longer refer to the transaction.
-			 */
-			bp->b_transp = NULL;
-		}
-
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
-- 
2.25.1

