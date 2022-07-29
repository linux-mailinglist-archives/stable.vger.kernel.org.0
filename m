Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E42585347
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 18:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbiG2QQZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 12:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbiG2QQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 12:16:24 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54761FD29;
        Fri, 29 Jul 2022 09:16:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id e15so6414194edj.2;
        Fri, 29 Jul 2022 09:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=+Pi/295BfdotTPY5GFt4GabpC2L9PI3DKlNtYUqbQNI=;
        b=onF0YML79OLw2+faB/+804cTgT2Y8vCVquEdF+euBngADJP96EQ3lktEKsVoUNM71M
         HRgJYgK5FYJ5whyxWYydun2v6g/RA//4zF57h3Afwf09VF7fyrTRcjh33QGP8g6WNMLq
         v5+w48ukBBlB+cmQFAX7xC8c+T0aRZC2f2gKijmhovs1LI8Qh0RSaRuOX6bPe0yyCC55
         RbiLxWK3hxSjHW0DPlJsUMeQNAtHdUhSzi4/QSHffkL5P4GfSkdxJMv00TaF40yx1rgS
         FDkLV0geyzaTKEaKNimMvXe/hv7uAegraNFAdBvneIHpfuQ2cMNQz8m3qVGlA1PM70En
         dfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=+Pi/295BfdotTPY5GFt4GabpC2L9PI3DKlNtYUqbQNI=;
        b=F3ymdXChoKB39QVYudHzeq0H0aPdFTLEoYVvfXbAkfaKiP7LTwDLvolF776WCA7PFA
         jcBb9V//48DDXdRQ1IYE5CJjZWiSy9yIsrI43i60LnEfvOFBNEEW4rT66Tgoxh+eULgq
         a6jooLwhpmCSzwOkUcnd9uxePXdFVw9AQzAvXM9pVwKIEROrsnKzaZce1uRcd3JDiRxT
         G+MR45R4hAGKdrHMpssJFO9OPhyvb/L3P4dd7cg0ZgfXkLyVgODBsFaLLJmklNSVr2NR
         D9912Tm0/nafINWUV/C8JRv1jLnVpNH+/UZ6/Sx5UkkbhkP0RFw6367MnAFLNUMFwoTb
         l3wA==
X-Gm-Message-State: AJIora+CUjn88oFktEoC8tcUSerbJ6RenurULnAhqytomi0QaJEn4xR4
        Z2UZw5ZEPwuKrVYDSIgzBf2E8L2kxMpVug==
X-Google-Smtp-Source: AGRyM1tg2kwo7/aMUcMoDhTX0SKBenvMrKfgOrGQFzdbuUximMM7VSmCmwjotAzyl4oZ07JvMiXUHg==
X-Received: by 2002:a05:6402:3881:b0:43a:691f:8e3b with SMTP id fd1-20020a056402388100b0043a691f8e3bmr4182824edb.217.1659111381773;
        Fri, 29 Jul 2022 09:16:21 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan (4.196.107.92.dynamic.wline.res.cust.swisscom.ch. [92.107.196.4])
        by smtp.gmail.com with ESMTPSA id fm15-20020a1709072acf00b0072b14836087sm1870116ejc.103.2022.07.29.09.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 09:16:21 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 v2 4/9] xfs: fix log intent recovery ENOSPC shutdowns when inactivating inodes
Date:   Fri, 29 Jul 2022 18:16:04 +0200
Message-Id: <20220729161609.4071252-5-amir73il@gmail.com>
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

From: "Darrick J. Wong" <djwong@kernel.org>

commit 81ed94751b1513fcc5978dcc06eb1f5b4e55a785 upstream.

During regular operation, the xfs_inactive operations create
transactions with zero block reservation because in general we're
freeing space, not asking for more.  The per-AG space reservations
created at mount time enable us to handle expansions of the refcount
btree without needing to reserve blocks to the transaction.

Unfortunately, log recovery doesn't create the per-AG space reservations
when intent items are being recovered.  This isn't an issue for intent
item recovery itself because they explicitly request blocks, but any
inode inactivation that can happen during log recovery uses the same
xfs_inactive paths as regular runtime.  If a refcount btree expansion
happens, the transaction will fail due to blk_res_used > blk_res, and we
shut down the filesystem unnecessarily.

Fix this problem by making per-AG reservations temporarily so that we
can handle the inactivations, and releasing them at the end.  This
brings the recovery environment closer to the runtime environment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 44b05e1d5d32..a2a5a0fd9233 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -968,9 +968,17 @@ xfs_mountfs(
 	/*
 	 * Finish recovering the file system.  This part needed to be delayed
 	 * until after the root and real-time bitmap inodes were consistently
-	 * read in.
+	 * read in.  Temporarily create per-AG space reservations for metadata
+	 * btree shape changes because space freeing transactions (for inode
+	 * inactivation) require the per-AG reservation in lieu of reserving
+	 * blocks.
 	 */
+	error = xfs_fs_reserve_ag_blocks(mp);
+	if (error && error == -ENOSPC)
+		xfs_warn(mp,
+	"ENOSPC reserving per-AG metadata pool, log recovery may fail.");
 	error = xfs_log_mount_finish(mp);
+	xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
 		xfs_warn(mp, "log mount finish failed");
 		goto out_rtunmount;
-- 
2.25.1

