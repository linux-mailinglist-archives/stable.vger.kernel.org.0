Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096B1313306
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 14:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBHNOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 08:14:17 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41995 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229703AbhBHNOP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 08:14:15 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id F01DB194054D;
        Mon,  8 Feb 2021 08:13:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 08 Feb 2021 08:13:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uyf3PV
        85hoR4TN7LtyIoXDbOJ6soBKZA6ZoYoZFcTWY=; b=ArfM1uU5K+41n+BVpaImt6
        QomfzgtZCCUFrsHl8YB8FGlDBTPPMcs0MyobjyjJoPuCgXxziuCzPg5CDGGdEd9n
        pqYSDqfGqTzE9A/dCjkRLFBpYXSo+t0lm0ivN4oqKWABvVwTvgpK+4jSyAzGykUt
        VnPYnPhPqOIHoh0vVer9ufs+HbCtSPTqIzeYzmdusjmnVEI+XEsdeY+soXDsNVOi
        OfZSY8fxAqCDcXOQY0j6CEVl9Qq1ylkDjfbjqzRSgnJl6W48ipxSWGrYFG0D6wlD
        YHQWRhzQgKZjdAe28YFy+vw5pZRVlIWUcch5XpuS9Tdd0h67pZEHBJx4L0QvSEQA
        ==
X-ME-Sender: <xms:5DghYDtbRZ1hha4mrnPD-QX080aKU1TQVWbpER1UmmvUGsnoXZbruQ>
    <xme:5DghYAzHjUzb-ZmG7CgSNlOC1D3VSYTIY6JyRNN1Lb2lX0lnVue-Z7d6iv1yHB_1I
    3Pd0FBGOsUJTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtudeuje
    fhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5DghYJiRQe_vonuDedgVpG0HmZupw_I0BAM0DlZeO31S5zJP88tDVw>
    <xmx:5DghYEAtbagwWHI8_b7gMUJ7mYtRlEaJ0Pmk5ewfj6oHjcgi8ChJ-Q>
    <xmx:5DghYGu6bDhPGK_wA9606mRcr8bXA8s6Sp1_fogme3_1lkBvBS4Kpw>
    <xmx:5DghYO-bWEZiiQ-qrAQhlrqqKmrhaZM_NhnpYQsSDWoxrvglbOFqHQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6AD9C240066;
        Mon,  8 Feb 2021 08:13:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/nouveau: fix dma syncing warning with debugging on." failed to apply to 5.10-stable tree
To:     airlied@redhat.com, bskeggs@redhat.com, lyude@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 14:13:06 +0100
Message-ID: <1612789986495@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f295c8cfec833c2707ff1512da10d65386dde7af Mon Sep 17 00:00:00 2001
From: Dave Airlie <airlied@redhat.com>
Date: Mon, 1 Feb 2021 10:56:32 +1000
Subject: [PATCH] drm/nouveau: fix dma syncing warning with debugging on.

Since I wrote the below patch if you run a debug kernel you can a
dma debug warning like:
nouveau 0000:1f:00.0: DMA-API: device driver tries to sync DMA memory it has not allocated [device address=0x000000016e012000] [size=4096 bytes]

The old nouveau code wasn't consolidate the pages like the ttm code,
but the dma-debug expects the sync code to give it the same base/range
pairs as the allocator.

Fix the nouveau sync code to consolidate pages before calling the
sync code.

Fixes: bd549d35b4be0 ("nouveau: use ttm populate mapping functions. (v2)")
Reported-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/417588/

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index c85b1af06b7b..7ea367a5444d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -547,7 +547,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 {
 	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
 	struct ttm_tt *ttm_dma = (struct ttm_tt *)nvbo->bo.ttm;
-	int i;
+	int i, j;
 
 	if (!ttm_dma)
 		return;
@@ -556,10 +556,21 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	if (nvbo->force_coherent)
 		return;
 
-	for (i = 0; i < ttm_dma->num_pages; i++)
+	for (i = 0; i < ttm_dma->num_pages; ++i) {
+		struct page *p = ttm_dma->pages[i];
+		size_t num_pages = 1;
+
+		for (j = i + 1; j < ttm_dma->num_pages; ++j) {
+			if (++p != ttm_dma->pages[j])
+				break;
+
+			++num_pages;
+		}
 		dma_sync_single_for_device(drm->dev->dev,
 					   ttm_dma->dma_address[i],
-					   PAGE_SIZE, DMA_TO_DEVICE);
+					   num_pages * PAGE_SIZE, DMA_TO_DEVICE);
+		i += num_pages;
+	}
 }
 
 void
@@ -567,7 +578,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 {
 	struct nouveau_drm *drm = nouveau_bdev(nvbo->bo.bdev);
 	struct ttm_tt *ttm_dma = (struct ttm_tt *)nvbo->bo.ttm;
-	int i;
+	int i, j;
 
 	if (!ttm_dma)
 		return;
@@ -576,9 +587,21 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	if (nvbo->force_coherent)
 		return;
 
-	for (i = 0; i < ttm_dma->num_pages; i++)
+	for (i = 0; i < ttm_dma->num_pages; ++i) {
+		struct page *p = ttm_dma->pages[i];
+		size_t num_pages = 1;
+
+		for (j = i + 1; j < ttm_dma->num_pages; ++j) {
+			if (++p != ttm_dma->pages[j])
+				break;
+
+			++num_pages;
+		}
+
 		dma_sync_single_for_cpu(drm->dev->dev, ttm_dma->dma_address[i],
-					PAGE_SIZE, DMA_FROM_DEVICE);
+					num_pages * PAGE_SIZE, DMA_FROM_DEVICE);
+		i += num_pages;
+	}
 }
 
 void nouveau_bo_add_io_reserve_lru(struct ttm_buffer_object *bo)

