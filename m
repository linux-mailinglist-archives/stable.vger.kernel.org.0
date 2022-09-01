Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75C05A8D9E
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 07:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233203AbiIAFtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 01:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiIAFtd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 01:49:33 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C8F1166E7;
        Wed, 31 Aug 2022 22:49:18 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k17so8425547wmr.2;
        Wed, 31 Aug 2022 22:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=pbhYhCVy+vOkWyvQ7AmT+FzIvJlqjatuYMTY3L/HslY=;
        b=awdXfoYpXIAfEtRAqa38uaehlbxB2VqdXmQn98llkOb0kOa+7liVeAGKTXn8RPUscI
         CUNjO1d/lIMCfa5PzBexSKs9QprjWuh9EDqfveiwmns3Q7Q4yOjKWQnrdrIoO6oLrtKI
         /Rqs/rjVLKSin36nP1blaOisw1NtgDKkKvR2Fh/bcdHjT7EuKDZE2w7A47PZYHmoWDs3
         ilNEJl5GkRwjdZpdx0ihnxHi2kjGlgNwwqQPYFvp+Ebm2WTcZ4lNpqrdRhcM/opH3TQ9
         uv0esPkf4OSWxsC0fWbRBkHy3lIBdLMaKki29jrbDi0KPYWdUK0gUMUqdqTfv5i0b/dg
         4w5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pbhYhCVy+vOkWyvQ7AmT+FzIvJlqjatuYMTY3L/HslY=;
        b=uZYyQzEkegxwgf8dZ4Zr7R1lf0mjuJi5yKHkvrxN6JaK1Y5LqWCnKv1yrSC6XQBRxn
         ktd6dPcHDr+IXJApTTJxsji+bj9Ead3YsFE0nnShmPUxll6ZamcIQ3Zdvbau19LeBjP9
         B/f32h5sXuJebgS8nplhW//S08juGkzmf9kPmUf66Bxy09lFzJGfog9P+gkGStQjd8X6
         5wEPjq5viSHPSMNFfxiwzQKcsa220+GHFhM4OeeWewqT2kTP6990o7zo2VZVX7OG0rnx
         7c4Op+DBjTvhgEOVOfOQ51pRGRpRUmC6QmMT9Tu+j19JsWyyNc6JxO+DdI8C9VFF4o46
         almw==
X-Gm-Message-State: ACgBeo2ny19NQwwp7KpUiAlNa2GAUzt5uZKIft5yORbTVRyack2DAUvk
        37fr7+X16nDiX/Ku+BuZTjM=
X-Google-Smtp-Source: AA6agR4gY3GwLOr/wKH8JJWN97nfLFUSHK+XwdoZy6WgryF/3sFK3/1QCXuNd1mDhaysFShnsL/Bpw==
X-Received: by 2002:a05:600c:4ec7:b0:3a8:4622:ad27 with SMTP id g7-20020a05600c4ec700b003a84622ad27mr4141193wmq.88.1662011344941;
        Wed, 31 Aug 2022 22:49:04 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id bg15-20020a05600c3c8f00b003a4f08495b7sm4447262wmb.34.2022.08.31.22.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 22:49:04 -0700 (PDT)
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
Subject: [PATCH 5.10 v2 2/7] xfs: always succeed at setting the reserve pool size
Date:   Thu,  1 Sep 2022 08:48:49 +0300
Message-Id: <20220901054854.2449416-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901054854.2449416-1-amir73il@gmail.com>
References: <20220901054854.2449416-1-amir73il@gmail.com>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit 0baa2657dc4d79202148be79a3dc36c35f425060 upstream.

Nowadays, xfs_mod_fdblocks will always choose to fill the reserve pool
with freed blocks before adding to fdblocks.  Therefore, we can change
the behavior of xfs_reserve_blocks slightly -- setting the target size
of the pool should always succeed, since a deficiency will eventually
be made up as blocks get freed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6d4f4271e7be..dacead0d0934 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -380,11 +380,14 @@ xfs_reserve_blocks(
 	 * The code below estimates how many blocks it can request from
 	 * fdblocks to stash in the reserve pool.  This is a classic TOCTOU
 	 * race since fdblocks updates are not always coordinated via
-	 * m_sb_lock.
+	 * m_sb_lock.  Set the reserve size even if there's not enough free
+	 * space to fill it because mod_fdblocks will refill an undersized
+	 * reserve when it can.
 	 */
 	free = percpu_counter_sum(&mp->m_fdblocks) -
 						xfs_fdblocks_unavailable(mp);
 	delta = request - mp->m_resblks;
+	mp->m_resblks = request;
 	if (delta > 0 && free > 0) {
 		/*
 		 * We'll either succeed in getting space from the free block
@@ -401,10 +404,8 @@ xfs_reserve_blocks(
 		 * Update the reserve counters if blocks have been successfully
 		 * allocated.
 		 */
-		if (!error) {
-			mp->m_resblks += fdblks_delta;
+		if (!error)
 			mp->m_resblks_avail += fdblks_delta;
-		}
 	}
 out:
 	if (outval) {
-- 
2.25.1

