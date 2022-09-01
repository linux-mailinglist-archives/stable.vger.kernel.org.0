Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 130E95A990E
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbiIANgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiIANfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:35:42 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B78EDB6;
        Thu,  1 Sep 2022 06:34:06 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id k9so22433666wri.0;
        Thu, 01 Sep 2022 06:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=6yyRgULoHRta/eb3LyurLgmxqUUvQOMkvOIjaPH3158=;
        b=Sc2XuBLdQaFWHfKco2e5NBK6WsVvh1nSyCM5PUfflM3qsq8rCP1IKVyV2XAIWubo6U
         /3GSboqR51u8Ip3kd/RRLc0nK8cCHPzncgjz2mXet7Sa2OHxvk/X3G3uebFUeDOfgT5E
         TzAZkyHh5PaGLQ6JoUC/Ggmn7xyi8O69QMsMxYFMRi6e6AwOSadMbRYXzOytU+WYxz2b
         LkvB19v7zYe/pgJe+JM2LNWZcDawWRoaeq6larc2UVF8kaMkuLS1PvodM5aHVHBeLmH2
         olcvtkMLDuECMWg3oKWiyx1P+a8n8gibKhgeTFvtM+d1+PipAMITrjP5v1e/+qKDMdSS
         8p9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=6yyRgULoHRta/eb3LyurLgmxqUUvQOMkvOIjaPH3158=;
        b=YvohwGaHE2mZONlykCFQ2uV2G3DdN5zCJ6MBblD/91ucko+tb/4OrzHQ84O22MnNSD
         gMKm09YbXAOIyJ9oLWc19KpxB+wPIU25XrGvbdcIi/4CuzJBc6tVaOG0QPNRc/EQ9Dx0
         RBCRpAXwrnXK7LslIL90RVwlI5ynqR5micjF6lRq9t56ZU+RZNPJRT3LQSJmTl9kOF6e
         1inN4WYuO2kUbpV3VXgy+byzFO+FQOtCXy+Whu5k+Cgt2LXi8C8uc/iQnPsSJnAiJicb
         V5WcFznurGGTF4GIOCv9Ucp2PL8vCBT9RFfdPtUoezib51pDbo2IDvxL/RTKmZVxB7ml
         ZqWg==
X-Gm-Message-State: ACgBeo2Qja/Gj2BTAO+i/or/SLVR6xXvGHj0s+AJvsBwdWx4LssTYmh5
        dBGONbvsNRV0AB6NoUE2n6o=
X-Google-Smtp-Source: AA6agR5Yf/y0ob8AtApCxI9+cgACE7mv51qI0KXxbcCSs8lHqHQjtAVEFrOG/CvCxCU82DSUA7M2Mg==
X-Received: by 2002:a05:6000:1563:b0:222:c827:1a19 with SMTP id 3-20020a056000156300b00222c8271a19mr14337146wrz.705.1662039244776;
        Thu, 01 Sep 2022 06:34:04 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b0022529d3e911sm15516390wrb.109.2022.09.01.06.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:34:04 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 5.10 v3 1/5] xfs: remove infinite loop when reserving free block pool
Date:   Thu,  1 Sep 2022 16:33:52 +0300
Message-Id: <20220901133356.2473299-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901133356.2473299-1-amir73il@gmail.com>
References: <20220901133356.2473299-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 15f04fdc75aaaa1cccb0b8b3af1be290e118a7bc upstream.

[Added wrapper xfs_fdblocks_unavailable() for 5.10.y backport]

Infinite loops in kernel code are scary.  Calls to xfs_reserve_blocks
should be rare (people should just use the defaults!) so we really don't
need to try so hard.  Simplify the logic here by removing the infinite
loop.

Cc: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 52 +++++++++++++++++++---------------------------
 fs/xfs/xfs_mount.h |  8 +++++++
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index ef1d5bb88b93..6d4f4271e7be 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -376,46 +376,36 @@ xfs_reserve_blocks(
 	 * If the request is larger than the current reservation, reserve the
 	 * blocks before we update the reserve counters. Sample m_fdblocks and
 	 * perform a partial reservation if the request exceeds free space.
+	 *
+	 * The code below estimates how many blocks it can request from
+	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
+	 * race since fdblocks updates are not always coordinated via
+	 * m_sb_lock.
 	 */
-	error = -ENOSPC;
-	do {
-		free = percpu_counter_sum(&mp->m_fdblocks) -
-						mp->m_alloc_set_aside;
-		if (free <= 0)
-			break;
-
-		delta = request - mp->m_resblks;
-		lcounter = free - delta;
-		if (lcounter < 0)
-			/* We can't satisfy the request, just get what we can */
-			fdblks_delta = free;
-		else
-			fdblks_delta = delta;
-
+	free = percpu_counter_sum(&mp->m_fdblocks) -
+						xfs_fdblocks_unavailable(mp);
+	delta = request - mp->m_resblks;
+	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
-		 * count or we'll get an ENOSPC. If we get a ENOSPC, it means
-		 * things changed while we were calculating fdblks_delta and so
-		 * we should try again to see if there is anything left to
-		 * reserve.
-		 *
-		 * Don't set the reserved flag here - we don't want to reserve
-		 * the extra reserve blocks from the reserve.....
+		 * count or we'll get an ENOSPC.  Don't set the reserved flag
+		 * here - we don't want to reserve the extra reserve blocks
+		 * from the reserve.
 		 */
+		fdblks_delta = min(free, delta);
 		spin_unlock(&mp->m_sb_lock);
 		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
 		spin_lock(&mp->m_sb_lock);
-	} while (error == -ENOSPC);
 
-	/*
-	 * Update the reserve counters if blocks have been successfully
-	 * allocated.
-	 */
-	if (!error && fdblks_delta) {
-		mp->m_resblks += fdblks_delta;
-		mp->m_resblks_avail += fdblks_delta;
+		/*
+		 * Update the reserve counters if blocks have been successfully
+		 * allocated.
+		 */
+		if (!error) {
+			mp->m_resblks += fdblks_delta;
+			mp->m_resblks_avail += fdblks_delta;
+		}
 	}
-
 out:
 	if (outval) {
 		outval->resblks = mp->m_resblks;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index dfa429b77ee2..3a6bc9dc11b5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -406,6 +406,14 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
 				     xfs_agnumber_t *maxagi);
 extern void	xfs_unmountfs(xfs_mount_t *);
 
+/* Accessor added for 5.10.y backport */
+static inline uint64_t
+xfs_fdblocks_unavailable(
+	struct xfs_mount	*mp)
+{
+	return mp->m_alloc_set_aside;
+}
+
 extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
 				 bool reserved);
 extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
-- 
2.25.1

