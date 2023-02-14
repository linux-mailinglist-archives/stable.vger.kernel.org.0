Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8607A696F7E
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbjBNV1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbjBNV1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:09 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1187A305CF;
        Tue, 14 Feb 2023 13:26:31 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id i18so9933453pli.3;
        Tue, 14 Feb 2023 13:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJ7rmQaa+5eKP3H4nq3epkc5bH6eIMkkoMiaG58I7BU=;
        b=LfdNyZUfbIp/Y2KzJEK35pQynmoURN0t3OVUZg7n44Ei69l2XO7kYBzIDVN8bhRtid
         SqZ+OPEwNnSTBH3zvhFaGvltR71G1jaA62tpn+T/Hp/NyPgJ8j4rMSkIQem0/ag+QFIb
         LF8+WbokN2jmC1TwSIrinhufpA2VAJX6qUQhP2I4g3bncukZ1MywapXS0WHz1CxWDTrd
         bZqFY8GdAlUQhAOLRUwp4aj0bhQN0OvEXehLf89LTes34ckwNwg/Y80oD5FvyrIVJ1fe
         +ngptMjhD34nsNoiMKIvQLt/zMsLtjXvytsOWVyMO23Ti/lc5WfUU7841UsqyPz3U4Ie
         GCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJ7rmQaa+5eKP3H4nq3epkc5bH6eIMkkoMiaG58I7BU=;
        b=XFVzX4kGOYHCxjrIXcWxfzjgugWt7GY3FPLyCmjd1EeM6K6pfSGPJq4MdKPHwNj1HW
         FxsobbYj0Q/pIYk2hOgpOMS22LY/MCxgcF0BPXKRkekto1VBICIpd8dpBt7klqJHjDJr
         T43d34Rm425jcGZi/LjrVM9K4MUcVPchX1KTK6ud+Tlhdrlv4JuUM38a0EOpRYsArHEr
         BIfhr+ZaJlsuscOjcsfRy0dT/xqni8+BpZtz2+pRf0oCqn//I6ANW+R0YBSQE+FZEi+L
         amI4MgVIyQWm4C6uHiFNgUX+D3bzd0OPS0VmAAFaQEqPrU+vbTmeb5mhw4TQux0Ov1jE
         Zq7w==
X-Gm-Message-State: AO0yUKUCsEZujbpsU5NofALVsGV4bvLBBP8EaCoefW2qXVr/dz4Il3cc
        lGzhOUCJm4p0wiIcAvCXaDwmAXQhUEZF4w==
X-Google-Smtp-Source: AK7set9u9fVZiukUqUAgto9uU7tioNQvgu/wMqYd0YhYTvcDqgLTStlz6zrfHOfuYMqRbPIBunXWhA==
X-Received: by 2002:a17:903:88f:b0:19a:9b87:e73f with SMTP id kt15-20020a170903088f00b0019a9b87e73fmr163026plb.1.1676409968602;
        Tue, 14 Feb 2023 13:26:08 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:07 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 03/10] xfs: detect self referencing btree sibling pointers
Date:   Tue, 14 Feb 2023 13:25:27 -0800
Message-Id: <20230214212534.1420323-4-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
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

[ Upstream commit dc04db2aa7c9307e740d6d0e173085301c173b1a ]

To catch the obvious graph cycle problem and hence potential endless
looping.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c | 140 ++++++++++++++++++++++++++++----------
 1 file changed, 105 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 298395481713..5bec048343b0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -51,6 +51,52 @@ xfs_btree_magic(
 	return magic;
 }
 
+static xfs_failaddr_t
+xfs_btree_check_lblock_siblings(
+	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	xfs_fsblock_t		fsb,
+	xfs_fsblock_t		sibling)
+{
+	if (sibling == NULLFSBLOCK)
+		return NULL;
+	if (sibling == fsb)
+		return __this_address;
+	if (level >= 0) {
+		if (!xfs_btree_check_lptr(cur, sibling, level + 1))
+			return __this_address;
+	} else {
+		if (!xfs_verify_fsbno(mp, sibling))
+			return __this_address;
+	}
+
+	return NULL;
+}
+
+static xfs_failaddr_t
+xfs_btree_check_sblock_siblings(
+	struct xfs_mount	*mp,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		sibling)
+{
+	if (sibling == NULLAGBLOCK)
+		return NULL;
+	if (sibling == agbno)
+		return __this_address;
+	if (level >= 0) {
+		if (!xfs_btree_check_sptr(cur, sibling, level + 1))
+			return __this_address;
+	} else {
+		if (!xfs_verify_agbno(mp, agno, sibling))
+			return __this_address;
+	}
+	return NULL;
+}
+
 /*
  * Check a long btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
@@ -65,6 +111,8 @@ __xfs_btree_check_lblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
+	xfs_failaddr_t		fa;
+	xfs_fsblock_t		fsb = NULLFSBLOCK;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -83,16 +131,16 @@ __xfs_btree_check_lblock(
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
-	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_leftsib),
-			level + 1))
-		return __this_address;
-	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_btree_check_lptr(cur, be64_to_cpu(block->bb_u.l.bb_rightsib),
-			level + 1))
-		return __this_address;
 
-	return NULL;
+	if (bp)
+		fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+
+	fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+			be64_to_cpu(block->bb_u.l.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_lblock_siblings(mp, cur, level, fsb,
+				be64_to_cpu(block->bb_u.l.bb_rightsib));
+	return fa;
 }
 
 /* Check a long btree block header. */
@@ -130,6 +178,9 @@ __xfs_btree_check_sblock(
 	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_btnum_t		btnum = cur->bc_btnum;
 	int			crc = xfs_has_crc(mp);
+	xfs_failaddr_t		fa;
+	xfs_agblock_t		agbno = NULLAGBLOCK;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
 
 	if (crc) {
 		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -146,16 +197,18 @@ __xfs_btree_check_sblock(
 	if (be16_to_cpu(block->bb_numrecs) >
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
-	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_leftsib),
-			level + 1))
-		return __this_address;
-	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_btree_check_sptr(cur, be32_to_cpu(block->bb_u.s.bb_rightsib),
-			level + 1))
-		return __this_address;
 
-	return NULL;
+	if (bp) {
+		agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+		agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
+	}
+
+	fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno, agbno,
+			be32_to_cpu(block->bb_u.s.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_sblock_siblings(mp, cur, level, agno,
+				 agbno, be32_to_cpu(block->bb_u.s.bb_rightsib));
+	return fa;
 }
 
 /* Check a short btree block header. */
@@ -4265,6 +4318,21 @@ xfs_btree_visit_block(
 	if (xfs_btree_ptr_is_null(cur, &rptr))
 		return -ENOENT;
 
+	/*
+	 * We only visit blocks once in this walk, so we have to avoid the
+	 * internal xfs_btree_lookup_get_block() optimisation where it will
+	 * return the same block without checking if the right sibling points
+	 * back to us and creates a cyclic reference in the btree.
+	 */
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+		if (be64_to_cpu(rptr.l) == XFS_DADDR_TO_FSB(cur->bc_mp,
+							xfs_buf_daddr(bp)))
+			return -EFSCORRUPTED;
+	} else {
+		if (be32_to_cpu(rptr.s) == xfs_daddr_to_agbno(cur->bc_mp,
+							xfs_buf_daddr(bp)))
+			return -EFSCORRUPTED;
+	}
 	return xfs_btree_lookup_get_block(cur, level, &rptr, &block);
 }
 
@@ -4439,20 +4507,21 @@ xfs_btree_lblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	xfs_fsblock_t		fsb;
+	xfs_failaddr_t		fa;
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
 		return __this_address;
 
 	/* sibling pointer verification */
-	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib)))
-		return __this_address;
-	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib)))
-		return __this_address;
-
-	return NULL;
+	fsb = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
+	fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+			be64_to_cpu(block->bb_u.l.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_lblock_siblings(mp, NULL, -1, fsb,
+				be64_to_cpu(block->bb_u.l.bb_rightsib));
+	return fa;
 }
 
 /**
@@ -4493,7 +4562,9 @@ xfs_btree_sblock_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	xfs_agblock_t		agno;
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_failaddr_t		fa;
 
 	/* numrecs verification */
 	if (be16_to_cpu(block->bb_numrecs) > max_recs)
@@ -4501,14 +4572,13 @@ xfs_btree_sblock_verify(
 
 	/* sibling pointer verification */
 	agno = xfs_daddr_to_agno(mp, xfs_buf_daddr(bp));
-	if (block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_leftsib)))
-		return __this_address;
-	if (block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK) &&
-	    !xfs_verify_agbno(mp, agno, be32_to_cpu(block->bb_u.s.bb_rightsib)))
-		return __this_address;
-
-	return NULL;
+	agbno = xfs_daddr_to_agbno(mp, xfs_buf_daddr(bp));
+	fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+			be32_to_cpu(block->bb_u.s.bb_leftsib));
+	if (!fa)
+		fa = xfs_btree_check_sblock_siblings(mp, NULL, -1, agno, agbno,
+				be32_to_cpu(block->bb_u.s.bb_rightsib));
+	return fa;
 }
 
 /*
-- 
2.39.1.581.gbfd45094c4-goog

