Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409F75A98FD
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbiIANgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiIANfm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:35:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D66DD5;
        Thu,  1 Sep 2022 06:34:08 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n23-20020a7bc5d7000000b003a62f19b453so1379339wmk.3;
        Thu, 01 Sep 2022 06:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=pbhYhCVy+vOkWyvQ7AmT+FzIvJlqjatuYMTY3L/HslY=;
        b=C63vUPjBGRXMpqYryIcGVTqZriybt9mtRuA38vIuPphixORXfxbDoKPPPYYDYU33t+
         tatMhENMViYLFwM35AJ8lqDtKfHZPHpLz8+f9iT186zrKmhXE2dE8HukOJ1FYe84TeBX
         S+THgqJuiq3cFEHnb4SKWTZKMQ9xef+zoMFcwl/D8RBc9sVxUKwjlIe2Ml38NY0MS1DY
         zK8kA+bAJO5evmyPROH3eyz49CXMHLg2yUHJsQXoxJGZxsMBg1yOt6M5R+ic37OwvorE
         tzXXiwyxZ6WyuoHe7gLAYwxym7HrnVQ2DGlWudTXIhvnaT0xXVNuKlCH+U0QlIMMNSdZ
         cAqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=pbhYhCVy+vOkWyvQ7AmT+FzIvJlqjatuYMTY3L/HslY=;
        b=63GuCzXFEU9tdU4rOqOkzPMqbn5X6+nAAU6adOfb3gU8dGPo8HGv8hKKe8qqgaM8eE
         gs0eTPbfhgP2Tw9YVl58H4OnNu0E4UI3WtsAC43Tnp2GTFCvxOI8EodeCrgzGaESZTE1
         JpLj2C704ch4kHYYSAchMUDx4+LVPcorDFSqUZQw28Gzc6LBVB9dwvbZJJQRB7uIVfJ2
         CDcTvpLQFokmHRhP/xhEsVjYjc8fmUf1Cf+auS+l6awlyYP+Wgguod6UEqpIGrjsHPCS
         TGju5FYKSdKrA72FnkwZgS32QEtmNsY+fsdUXSVQl7rni2nktCSitULVESqt71C0EWQA
         Vmeg==
X-Gm-Message-State: ACgBeo01r1Gmbyd0Jr5dYq3adqxdw5cLynY1Z07MWh+h3/FynKI0D7uF
        wxF0Z4pGV/JZHlKayEf3D2Q=
X-Google-Smtp-Source: AA6agR7rOkK6HBprga+z0yn27BQE45IffF10cIeTPOsJ9SA+fiN9zHi6QXqbKCjuol9N62djqdx5Hw==
X-Received: by 2002:a05:600c:348d:b0:3a6:b4e:ff6d with SMTP id a13-20020a05600c348d00b003a60b4eff6dmr4987755wmq.95.1662039246543;
        Thu, 01 Sep 2022 06:34:06 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b0022529d3e911sm15516390wrb.109.2022.09.01.06.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:34:06 -0700 (PDT)
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
Subject: [PATCH 5.10 v3 2/5] xfs: always succeed at setting the reserve pool size
Date:   Thu,  1 Sep 2022 16:33:53 +0300
Message-Id: <20220901133356.2473299-3-amir73il@gmail.com>
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

