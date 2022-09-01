Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B135A990C
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiIANgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 09:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiIANfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 09:35:45 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BAF013D37;
        Thu,  1 Sep 2022 06:34:12 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id h204-20020a1c21d5000000b003a5b467c3abso1375612wmh.5;
        Thu, 01 Sep 2022 06:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=xLW9Gby42tyiBFlIoDzW7LpOcnfeeekTuyuaQuWlQqE=;
        b=B2yUD5QhyZpKXP3npKSUaxsF8Gs4LF6DfyVpnz5aRppwwc1GGyPNkuYCG8mGH8o6YW
         I8VWd3UW7eFt3If2sNC2e+meW8TbUde0f2COw1kA6Xy8P5e326ggGV8K8qGeItkYp4xU
         zmk2J5jaNQ0b9UIMfBfhG7ZPsTF8tfLaTW/E0qjs/1cVNFbsoPt+WnNKg7YQ2ik2Jdq8
         warGfiVadYQERqWY8l6hp2PuAJB7DXPFmWWZrm2jATPUYrbcp7y4SxSzZyxHM1DDFlgb
         BSv18VLj3AaFevnpwwcQXqcl9VAHyvrjimV7hOQB2RqgEWBNFjp8jEMRlAsMpPnmNEyo
         OzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xLW9Gby42tyiBFlIoDzW7LpOcnfeeekTuyuaQuWlQqE=;
        b=PUKmkAhDCRmJINxpE8BwIV5JCjhL1G/7IqTShAt/jnawiFK1dGAcO7hfuCtnUlrCx0
         2eldMOGGmgEKZhsiBRaKFwJuB1qPXneO3IjM5gDolmel4v2epOGbeWHRkAkjswWZp/C5
         O6ehsW7fz2v3VYI5v50HcWQ4p+ORkclKCDXIskAvgRBnkkdNyLTHIUHR/benhMvoObW4
         pSphsrAmZa2v2xvfwOLQwRpepMRSXrHOA1ipp73m3DM0nAWcNSEBf4wGiJpUmeU1nUkK
         QVmMPElXohw/CjMbnUim2GwN3cjA8VnIXoEseLDQP600UhPKfOmggDMYBhddknlzVRxb
         /08w==
X-Gm-Message-State: ACgBeo1SzInb3zog0srZdyMQGYuBLBxkFTEXwpBBvnD/Lyjajkkxk1Li
        ZJWf8wM+sUkSJKFJ+m+iJGc=
X-Google-Smtp-Source: AA6agR5LFv8uN4XkQ3pyBPSxydoGoXrU8nQ4GDlUyaFCVq0xQAOgGXUrHuRgxaWGBn985GeEVsvMmw==
X-Received: by 2002:a05:600c:3583:b0:3a7:eeaf:62d3 with SMTP id p3-20020a05600c358300b003a7eeaf62d3mr5229741wmq.170.1662039250218;
        Thu, 01 Sep 2022 06:34:10 -0700 (PDT)
Received: from localhost.localdomain ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id az26-20020adfe19a000000b0022529d3e911sm15516390wrb.109.2022.09.01.06.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 06:34:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 v3 4/5] xfs: fix soft lockup via spinning in filestream ag selection loop
Date:   Thu,  1 Sep 2022 16:33:55 +0300
Message-Id: <20220901133356.2473299-5-amir73il@gmail.com>
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

From: Brian Foster <bfoster@redhat.com>

commit f650df7171b882dca737ddbbeb414100b31f16af upstream.

The filestream AG selection loop uses pagf data to aid in AG
selection, which depends on pagf initialization. If the in-core
structure is not initialized, the caller invokes the AGF read path
to do so and carries on. If another task enters the loop and finds
a pagf init already in progress, the AGF read returns -EAGAIN and
the task continues the loop. This does not increment the current ag
index, however, which means the task spins on the current AGF buffer
until unlocked.

If the AGF read I/O submitted by the initial task happens to be
delayed for whatever reason, this results in soft lockup warnings
via the spinning task. This is reproduced by xfs/170. To avoid this
problem, fix the AGF trylock failure path to properly iterate to the
next AG. If a task iterates all AGs without making progress, the
trylock behavior is dropped in favor of blocking locks and thus a
soft lockup is no longer possible.

Fixes: f48e2df8a877ca1c ("xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_filestream.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index db23e455eb91..bc41ec0c483d 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
 		if (!pag->pagf_init) {
 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
 			if (err) {
-				xfs_perag_put(pag);
-				if (err != -EAGAIN)
+				if (err != -EAGAIN) {
+					xfs_perag_put(pag);
 					return err;
+				}
 				/* Couldn't lock the AGF, skip this AG. */
-				continue;
+				goto next_ag;
 			}
 		}
 
-- 
2.25.1

