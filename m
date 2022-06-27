Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F5555DDC7
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbiF0GrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiF0GrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:47:12 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9D755A1;
        Sun, 26 Jun 2022 23:47:11 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id i67-20020a1c3b46000000b003a03567d5e9so5217494wma.1;
        Sun, 26 Jun 2022 23:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X6hunTx6t84e1RH7TuIwMAVJt14IU7tMQ/ZDFHTvWjE=;
        b=g1Q8KVUjStQrhmtPbMn82Hiqa8K5FY15rjCdTyi04LMhWMPrNBheqjMsnrPulYvuY8
         EB18zWGSmhbp3xgcFI/lgH4uSIRNP5iY12exQwEif7m9Rvp1QvvC6j9Sp0v2zkjBn/nY
         SsPjuZZKLpNn5Mq+2oFLCK1p3ss0dhiH/3s+rKNT4UqhyP0u0FBt5waRa57EHQ12OU0n
         BR+imwKVFZ68/R0uOpPJ9cFFt+SPlg7Mx1jVt3xmtic9oaCPZ6Om+U+sOlJdi9xzglQ4
         qUsQR3AuJicD28mWP3U9NB0cmPH8/X/1LpMX82YPxBlTCgG9/mj4mr9MYWuGYVZ9Z2mW
         vWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X6hunTx6t84e1RH7TuIwMAVJt14IU7tMQ/ZDFHTvWjE=;
        b=0eNYqWrAHi38PgjaKvhauwTcZhwx3ACyCWZgGVI7ylGmI2MAjWzRDvpGmL/aP8RFkX
         nkzUPX8vafW86nE4zv7B7CVUSHVyvwtwGFO6CHaRl+tlrcmIhLqXUzMZ2eXKRwsYj0BP
         JIFmkLmp+RrnHIgo+54uqo2SbvV2cWzhW0ggpHVrBvP3nQK7zk2uYmmPPh+daP4axtAR
         sjjBVmJOcC8eX29eQ1400K4bKWFXtD2SJ4/ifJtSf6Mp0G0UBJZNQiLV8JKbe+sjM3Ui
         /QKH6vYVsIqqpB28rm28Ln8Kxm0CIFJd1QOVzT8dG45rTvzCUoF86t7HWfc8eGjNNkUO
         UBUw==
X-Gm-Message-State: AJIora8rC9I0u8s47bvbYLNDinEUQOGEDS+ETNaIQuUQoCbSrb3P0lDL
        oZ7qPr8OKB5Kgi/Adu/rqV0=
X-Google-Smtp-Source: AGRyM1vtVs1maAJsnr+lJr1Ogkk0I1xlMYIbpmi/zZtUR1+zMDGng7446E7dztcd0TbToRHlIc+rAg==
X-Received: by 2002:a05:600c:4282:b0:3a0:2ddf:4df3 with SMTP id v2-20020a05600c428200b003a02ddf4df3mr13412134wmc.45.1656312430188;
        Sun, 26 Jun 2022 23:47:10 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([77.137.66.49])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm16460839wmq.26.2022.06.26.23.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:47:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        Rustam Kovhaev <rkovhaev@gmail.com>
Subject: [PATCH v3 1/5] xfs: use kmem_cache_free() for kmem_cache objects
Date:   Mon, 27 Jun 2022 09:46:59 +0300
Message-Id: <20220627064703.2798133-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220627064703.2798133-1-amir73il@gmail.com>
References: <20220627064703.2798133-1-amir73il@gmail.com>
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

From: Rustam Kovhaev <rkovhaev@gmail.com>

commit c30a0cbd07ecc0eec7b3cd568f7b1c7bb7913f93 upstream.

For kmalloc() allocations SLOB prepends the blocks with a 4-byte header,
and it puts the size of the allocated blocks in that header.
Blocks allocated with kmem_cache_alloc() allocations do not have that
header.

SLOB explodes when you allocate memory with kmem_cache_alloc() and then
try to free it with kfree() instead of kmem_cache_free().
SLOB will assume that there is a header when there is none, read some
garbage to size variable and corrupt the adjacent objects, which
eventually leads to hang or panic.

Let's make XFS work with SLOB by using proper free function.

Fixes: 9749fee83f38 ("xfs: enable the xfs_defer mechanism to process extents to free")
Signed-off-by: Rustam Kovhaev <rkovhaev@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extfree_item.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 5c0395256bd1..11474770d630 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -482,7 +482,7 @@ xfs_extent_free_finish_item(
 			free->xefi_startblock,
 			free->xefi_blockcount,
 			&free->xefi_oinfo, free->xefi_skip_discard);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
@@ -502,7 +502,7 @@ xfs_extent_free_cancel_item(
 	struct xfs_extent_free_item	*free;
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 }
 
 const struct xfs_defer_op_type xfs_extent_free_defer_type = {
@@ -564,7 +564,7 @@ xfs_agfl_free_finish_item(
 	extp->ext_len = free->xefi_blockcount;
 	efdp->efd_next_extent++;
 
-	kmem_free(free);
+	kmem_cache_free(xfs_bmap_free_item_zone, free);
 	return error;
 }
 
-- 
2.25.1

