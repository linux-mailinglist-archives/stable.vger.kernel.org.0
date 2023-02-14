Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC96696F7A
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 22:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232838AbjBNV1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 16:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbjBNV1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 16:27:05 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4593303F8;
        Tue, 14 Feb 2023 13:26:27 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id k13so18421793plg.0;
        Tue, 14 Feb 2023 13:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D4ycGkk3qcn7VrJ4nBZli7Tj+n2Cr5liEIeaqSLavKY=;
        b=M7ufR78AaMh+GneDxEPh59VSWgdo18rjoEqopHpm9f2pZz/+tIKNCwDZReGQS74k4o
         pzaLlgrdtrllt4RMtN026JrTAXm5goJQ9W+YuywaRAIbCwmPEgBpFBu52Jvgqjc9yitZ
         ydTPERRSOkEhwWdX6RZuyK0t3eszt4ywwQg/wuSpV68D5uBkUAacd440LWen1KGDW5Ug
         GA+fem/GgKOg02fmmhPDhUx8ukyWllFP5tj64OYLE/Y5T2i5H2hdFJl4zX/61JjhyMlO
         AXLZeSI1bSSgKxujSmFTKS6cH6PZ9QYPPYu41gC5RwSEy333kXXqIReLZgfj8/pEvxxt
         FF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D4ycGkk3qcn7VrJ4nBZli7Tj+n2Cr5liEIeaqSLavKY=;
        b=LBf+4zaCaJ5iG1wRBMBHB5hoRNAH8RLe0Ub1+bs+wB1y5Ksh3C90wPjz4Ei7VhVHn/
         iZvJiyDToow0bYrrLVMCBvn2U8D1qpxmsOeaekiBl1DWdJCJGnuhqmCuZWnGIzM7hcaD
         IFSuvwmuyoJzxj5xgRdlvNIEg2u5eJT4eqV+LZ92gJ/myvTmbZPSPHXJCp/m3Ynutr2e
         3TNhf9x6dITd5XMyAitM5S4pISFTnGtn/VQpmv2icD8c/HlukKrhKtDtz0NGtSQDkPyI
         7IRmXOhlQMZA4XUXu/LYNWBn+dkale173Uw9dsJmnXZ8iyFJqBPgCfjXIJgcY+yBvIaG
         VU4w==
X-Gm-Message-State: AO0yUKUWuujpevPUQZUz157iLP840qOZOjWjo0dhxYH5OUW2stHCcUXu
        fGEKDYpXKEOtVioDhnoPO4LXx3S4ljTxzA==
X-Google-Smtp-Source: AK7set8pIcYPBs8qchSHsSHcUMOngpGDsRkci5AGbFq+FJavVyLVXj6T9R9Cvm+zdw6FDbDlCAYwGA==
X-Received: by 2002:a17:902:fad0:b0:199:201d:12f1 with SMTP id ld16-20020a170902fad000b00199201d12f1mr63756plb.47.1676409967146;
        Tue, 14 Feb 2023 13:26:07 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:cf14:3756:2b5e:fb87])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b00195f0fb0c18sm6692569pln.31.2023.02.14.13.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:26:06 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 02/10] xfs: fix potential log item leak
Date:   Tue, 14 Feb 2023 13:25:26 -0800
Message-Id: <20230214212534.1420323-3-leah.rumancik@gmail.com>
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

[ Upstream commit c230a4a85bcdbfc1a7415deec6caf04e8fca1301 ]

Ever since we added shadown format buffers to the log items, log
items need to handle the item being released with shadow buffers
attached. Due to the fact this requirement was added at the same
time we added new rmap/reflink intents, we missed the cleanup of
those items.

In theory, this means shadow buffers can be leaked in a very small
window when a shutdown is initiated. Testing with KASAN shows this
leak does not happen in practice - we haven't identified a single
leak in several years of shutdown testing since ~v4.8 kernels.

However, the intent whiteout cleanup mechanism results in every
cancelled intent in exactly the same state as this tiny race window
creates and so if intents down clean up shadow buffers on final
release we will leak the shadow buffer for just about every intent
we create.

Hence we start with this patch to close this condition off and
ensure that when whiteouts start to be used we don't leak lots of
memory.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c     | 2 ++
 fs/xfs/xfs_icreate_item.c  | 1 +
 fs/xfs/xfs_refcount_item.c | 2 ++
 fs/xfs/xfs_rmap_item.c     | 2 ++
 4 files changed, 7 insertions(+)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 03159970133f..51ffdec5e4fa 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -39,6 +39,7 @@ STATIC void
 xfs_bui_item_free(
 	struct xfs_bui_log_item	*buip)
 {
+	kmem_free(buip->bui_item.li_lv_shadow);
 	kmem_cache_free(xfs_bui_zone, buip);
 }
 
@@ -198,6 +199,7 @@ xfs_bud_item_release(
 	struct xfs_bud_log_item	*budp = BUD_ITEM(lip);
 
 	xfs_bui_release(budp->bud_buip);
+	kmem_free(budp->bud_item.li_lv_shadow);
 	kmem_cache_free(xfs_bud_zone, budp);
 }
 
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 017904a34c02..c265ae20946d 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -63,6 +63,7 @@ STATIC void
 xfs_icreate_item_release(
 	struct xfs_log_item	*lip)
 {
+	kmem_free(ICR_ITEM(lip)->ic_item.li_lv_shadow);
 	kmem_cache_free(xfs_icreate_zone, ICR_ITEM(lip));
 }
 
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 46904b793bd4..8ef842d17916 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -35,6 +35,7 @@ STATIC void
 xfs_cui_item_free(
 	struct xfs_cui_log_item	*cuip)
 {
+	kmem_free(cuip->cui_item.li_lv_shadow);
 	if (cuip->cui_format.cui_nextents > XFS_CUI_MAX_FAST_EXTENTS)
 		kmem_free(cuip);
 	else
@@ -204,6 +205,7 @@ xfs_cud_item_release(
 	struct xfs_cud_log_item	*cudp = CUD_ITEM(lip);
 
 	xfs_cui_release(cudp->cud_cuip);
+	kmem_free(cudp->cud_item.li_lv_shadow);
 	kmem_cache_free(xfs_cud_zone, cudp);
 }
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5f0695980467..15e7b01740a7 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -35,6 +35,7 @@ STATIC void
 xfs_rui_item_free(
 	struct xfs_rui_log_item	*ruip)
 {
+	kmem_free(ruip->rui_item.li_lv_shadow);
 	if (ruip->rui_format.rui_nextents > XFS_RUI_MAX_FAST_EXTENTS)
 		kmem_free(ruip);
 	else
@@ -227,6 +228,7 @@ xfs_rud_item_release(
 	struct xfs_rud_log_item	*rudp = RUD_ITEM(lip);
 
 	xfs_rui_release(rudp->rud_ruip);
+	kmem_free(rudp->rud_item.li_lv_shadow);
 	kmem_cache_free(xfs_rud_zone, rudp);
 }
 
-- 
2.39.1.581.gbfd45094c4-goog

