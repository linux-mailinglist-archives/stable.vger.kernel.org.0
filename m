Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C15415E6785
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 17:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiIVPrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 11:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiIVPrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 11:47:40 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE72FD62C9;
        Thu, 22 Sep 2022 08:47:39 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x18so10201751wrm.7;
        Thu, 22 Sep 2022 08:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=M3jAT3YQCl4NufeW6oCkMl9aVNOp6TjzxP0+mQ9Dows=;
        b=jbN4VNQS1GLIDFf5MK+GytMiPVDyIaatKirmfHc7QwA0Biqs4fJGYOWXWvMd24xUHn
         qklGBwV2/K4RU03rVfTrb5CWE6X61d9FwhGBTVOfMfEf4DlOUKQsUUItjs23/LzTdJsx
         r/WA5Vl83DWF3vUAmErPKFcsSjehiSw5wIdlkBSL8A3S4xzOPk4r9EbyTsGvUTUm4wCA
         8AunZsZTmLE+ya+akHY4n0fgEaSj+XUj1vtn+Ht6UmEcLiw1JwFa40gQAdhN9CD/woN8
         xFtDKwdBDEzSY5pNfgi2L9XNoJ+yOx4SrZrm5zlkXVAISPtb4SO8GmAue2TZKlH4XZC5
         LbDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=M3jAT3YQCl4NufeW6oCkMl9aVNOp6TjzxP0+mQ9Dows=;
        b=IYR6s63yGw4AOYPql5f1F06YGhgw0nI1qt9G0ClV7/6GKM/nqHD7eiKQG7bhNI8XsN
         LJ/L30zhKzXuKNLt/HadUjRBwflZZSWv4vbHs6qqkWPJ4VEEChhZ16w9TmXJsBrYivA6
         ZN3nT1awS34UdXaDn1yNRwUyS9n6sEcRxmI1sRM48Z6Se+iNoqGIqAWuqXPqK3riC0xO
         Pe6tzup8dbvLlXoZ2ZIW9uiheJRsBs/HSTOGUNXcEmuAecyYC/jFC/IDKMSEVQ0shZAt
         4YoHkBluSNJPrTFov55ellpfZMi3CHknEe3y9No/aTMJLrSrukDwGqKGGtcKLH+wq0iM
         iUlQ==
X-Gm-Message-State: ACrzQf18gI30Zf0GqjaRxETFvZevtcTcN5SbkU86RkzA0L7dWJIt62JH
        QEKMnME9KEME3vBfE8REiLI=
X-Google-Smtp-Source: AMsMyM4YHhvTkXol4aB/0ol8N1rHVk04QRHWTntg+wOMynfpirRltShpG7OgNP+23cQ/HAwhET5KLw==
X-Received: by 2002:a5d:64ab:0:b0:226:d997:ad5c with SMTP id m11-20020a5d64ab000000b00226d997ad5cmr2432690wrp.602.1663861658164;
        Thu, 22 Sep 2022 08:47:38 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id z5-20020a5d6405000000b0022af9555669sm6272386wru.99.2022.09.22.08.47.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:47:37 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 2/2] xfs: validate inode fork size against fork format
Date:   Thu, 22 Sep 2022 18:47:28 +0300
Message-Id: <20220922154728.97402-3-amir73il@gmail.com>
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

commit 1eb70f54c445fcbb25817841e774adb3d912f3e8 upstream.

[backport for 5.10.y]

xfs_repair catches fork size/format mismatches, but the in-kernel
verifier doesn't, leading to null pointer failures when attempting
to perform operations on the fork. This can occur in the
xfs_dir_is_empty() where the in-memory fork format does not match
the size and so the fork data pointer is accessed incorrectly.

Note: this causes new failures in xfs/348 which is testing mode vs
ftype mismatches. We now detect a regular file that has been changed
to a directory or symlink mode as being corrupt because the data
fork is for a symlink or directory should be in local form when
there are only 3 bytes of data in the data fork. Hence the inode
verify for the regular file now fires w/ -EFSCORRUPTED because
the inode fork format does not match the format the corrupted mode
says it should be in.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index c667c63f2cb0..fa8aefe6b7ec 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -358,19 +358,36 @@ xfs_dinode_verify_fork(
 	int			whichfork)
 {
 	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
+	mode_t			mode = be16_to_cpu(dip->di_mode);
+	uint32_t		fork_size = XFS_DFORK_SIZE(dip, mp, whichfork);
+	uint32_t		fork_format = XFS_DFORK_FORMAT(dip, whichfork);
 
-	switch (XFS_DFORK_FORMAT(dip, whichfork)) {
+	/*
+	 * For fork types that can contain local data, check that the fork
+	 * format matches the size of local data contained within the fork.
+	 *
+	 * For all types, check that when the size says the should be in extent
+	 * or btree format, the inode isn't claiming it is in local format.
+	 */
+	if (whichfork == XFS_DATA_FORK) {
+		if (S_ISDIR(mode) || S_ISLNK(mode)) {
+			if (be64_to_cpu(dip->di_size) <= fork_size &&
+			    fork_format != XFS_DINODE_FMT_LOCAL)
+				return __this_address;
+		}
+
+		if (be64_to_cpu(dip->di_size) > fork_size &&
+		    fork_format == XFS_DINODE_FMT_LOCAL)
+			return __this_address;
+	}
+
+	switch (fork_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		/*
-		 * no local regular files yet
+		 * No local regular files yet.
 		 */
-		if (whichfork == XFS_DATA_FORK) {
-			if (S_ISREG(be16_to_cpu(dip->di_mode)))
-				return __this_address;
-			if (be64_to_cpu(dip->di_size) >
-					XFS_DFORK_SIZE(dip, mp, whichfork))
-				return __this_address;
-		}
+		if (S_ISREG(mode) && whichfork == XFS_DATA_FORK)
+			return __this_address;
 		if (di_nextents)
 			return __this_address;
 		break;
-- 
2.25.1

