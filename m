Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2CF3696F85
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbjBNV1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbjBNV1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:10 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D57305C4;
        Tue, 14 Feb 2023 13:26:33 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so103068pjq.0;
        Tue, 14 Feb 2023 13:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydJINgiUXERcprOBsrfHGHvS8ULlgWZrSeh+RZ3+t00=;
        b=LK1+2Ivzq+WSDw+yIgo/16wGfl5rqUyC6ROPI601hK0UURkqXlc6fBgl6O7jPj0lOp
         qmgwdlWQIVTZRwWmsM/AMiLolCB31WFwtJbGyxqBnK5Y9NZCtGPwGY4OK5lCGa5+/A4m
         gq5c+mTFF4qmdyMogqn3ymL9eGNBWTLP5+BzFagUvmHJOnA4oAMeStAy08Rdt6oBDheY
         DP4XsNG0yu8PPLI8hgUIi+psf9a3/lq96+iM85o0lGEyWQW9Bqin9cFCG/W0VY6K6O26
         V4e7mYeLJmYocSayW0YXM4Ld68j7w9cQExLo5nZDxBVMXUQKD4UOBbbWAKxavWkoYocQ
         ry4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydJINgiUXERcprOBsrfHGHvS8ULlgWZrSeh+RZ3+t00=;
        b=UXcyPeLB+crPUDwpaPhDYES7IYZn6liRdBXvN00FiujhaLvhBdX3tt/u+6Rboab16o
         1rQT/hfw93Rx4sI7KXG8IURZJ8r7ByAacpvBs53bA2eIvtOJPGHLMn0LbGC8CE1mIPhI
         MkVBzBYG91cLawwCEoUwweDYvx30Q+KgcG4Y/kJmZOPAiBsCwEFvxaZs6N0pA727pxxu
         2iXT00JRD55Y8PDTLdlGC1vzv4sYEQz/AHKw6ecTgm4MZ5qmkQKt30lNLzyZFkFSmrYR
         ErSWdP6jUFZTa3Cq59rYGZ9NA9kz4h5xgbQ69se71P1Jx2K/1cL4rrn0608BNFBZokG3
         g69A==
X-Gm-Message-State: AO0yUKXKcALTjVWUhoJrgZkgK4mRrMJ8vOgoRtLQkNwBZCuikueiCdGY
        TBwXhjeJif94jlOgxSQq0VqesqgpwA/5hQ==
X-Google-Smtp-Source: AK7set/qa5S/bcbJH4e0MhNvMUM+1qfZoDm2V33bcRfoDlM9nsMNLBNiuaCpiqV4YMnOWut2nvSj5w==
X-Received: by 2002:a17:903:18d:b0:199:1996:71ec with SMTP id z13-20020a170903018d00b00199199671ecmr103090plg.16.1676409970766;
        Tue, 14 Feb 2023 13:26:10 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:10 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 05/10] xfs: validate v5 feature fields
Date:   Tue, 14 Feb 2023 13:25:29 -0800
Message-Id: <20230214212534.1420323-6-leah.rumancik@gmail.com>
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

[ Upstream commit f0f5f658065a5af09126ec892e4c383540a1c77f ]

We don't check that the v4 feature flags taht v5 requires to be set
are actually set anywhere. Do this check when we see that the
filesystem is a v5 filesystem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 68 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 72c05485c870..04e2a57313fa 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -30,6 +30,47 @@
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
  */
 
+/*
+ * Check that all the V4 feature bits that the V5 filesystem format requires are
+ * correctly set.
+ */
+static bool
+xfs_sb_validate_v5_features(
+	struct xfs_sb	*sbp)
+{
+	/* We must not have any unknown V4 feature bits set */
+	if (sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS)
+		return false;
+
+	/*
+	 * The CRC bit is considered an invalid V4 flag, so we have to add it
+	 * manually to the OKBITS mask.
+	 */
+	if (sbp->sb_features2 & ~(XFS_SB_VERSION2_OKBITS |
+				  XFS_SB_VERSION2_CRCBIT))
+		return false;
+
+	/* Now check all the required V4 feature flags are set. */
+
+#define V5_VERS_FLAGS	(XFS_SB_VERSION_NLINKBIT	| \
+			XFS_SB_VERSION_ALIGNBIT		| \
+			XFS_SB_VERSION_LOGV2BIT		| \
+			XFS_SB_VERSION_EXTFLGBIT	| \
+			XFS_SB_VERSION_DIRV2BIT		| \
+			XFS_SB_VERSION_MOREBITSBIT)
+
+#define V5_FEAT_FLAGS	(XFS_SB_VERSION2_LAZYSBCOUNTBIT	| \
+			XFS_SB_VERSION2_ATTR2BIT	| \
+			XFS_SB_VERSION2_PROJID32BIT	| \
+			XFS_SB_VERSION2_CRCBIT)
+
+	if ((sbp->sb_versionnum & V5_VERS_FLAGS) != V5_VERS_FLAGS)
+		return false;
+	if ((sbp->sb_features2 & V5_FEAT_FLAGS) != V5_FEAT_FLAGS)
+		return false;
+	return true;
+}
+
 /*
  * We support all XFS versions newer than a v4 superblock with V2 directories.
  */
@@ -37,9 +78,19 @@ bool
 xfs_sb_good_version(
 	struct xfs_sb	*sbp)
 {
-	/* all v5 filesystems are supported */
+	/*
+	 * All v5 filesystems are supported, but we must check that all the
+	 * required v4 feature flags are enabled correctly as the code checks
+	 * those flags and not for v5 support.
+	 */
 	if (xfs_sb_is_v5(sbp))
-		return true;
+		return xfs_sb_validate_v5_features(sbp);
+
+	/* We must not have any unknown v4 feature bits set */
+	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
+	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
+	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
+		return false;
 
 	/* versions prior to v4 are not supported */
 	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
@@ -51,12 +102,6 @@ xfs_sb_good_version(
 	if (!(sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT))
 		return false;
 
-	/* And must not have any unknown v4 feature bits set */
-	if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
-	    ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
-	     (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
-		return false;
-
 	/* It's a supported v4 filesystem */
 	return true;
 }
@@ -264,12 +309,15 @@ xfs_validate_sb_common(
 	bool			has_dalign;
 
 	if (!xfs_verify_magic(bp, dsb->sb_magicnum)) {
-		xfs_warn(mp, "bad magic number");
+		xfs_warn(mp,
+"Superblock has bad magic number 0x%x. Not an XFS filesystem?",
+			be32_to_cpu(dsb->sb_magicnum));
 		return -EWRONGFS;
 	}
 
 	if (!xfs_sb_good_version(sbp)) {
-		xfs_warn(mp, "bad version");
+		xfs_warn(mp,
+"Superblock has unknown features enabled or corrupted feature masks.");
 		return -EWRONGFS;
 	}
 
-- 
2.39.1.581.gbfd45094c4-goog

