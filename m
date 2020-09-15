Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B075B26A033
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgIOHxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:53:38 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:51947 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgIOHxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:53:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 5CEA36CC;
        Tue, 15 Sep 2020 03:53:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 15 Sep 2020 03:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hwEUA7
        vFudY3dRbiEozd6cF/QfNUoBduIQJpkHwBtoo=; b=icQgYx9R8LIo5FIsaiaXjb
        sk/legYu1l8Vd3ayC/9/8n6b2gwNO3Ent9DfbjkyMFoMOe49/lYwGmDS2tL22+Mw
        MCnrCDOJMbVx8n4tBB4wMqkt8+9pJNHEc+MSf+cDVDqVqMcCuYDWUc+p+N5VwmPr
        wXkDapiACJJ/yFEU2svU2SzM1tf5gUgy7z4E1oqFVn4zAVy2bMNOPrQp7UctFDog
        atVD3c00PXr2n12oFTKA/TAppcbYwaoE7fvhPrJNnsL3r7cKP4q5oCiNzyZzRe3c
        1SihIJUaeRlK5p4RhcSpyou4Z9SEBOVBKBVLVmgRu0BgJjoGpfwpC7GF6qeoa94A
        ==
X-ME-Sender: <xms:9XJgX9B1F6E6FCn8fWOhmSzfEEX7lhliDe5fyigFnYhG2akVAMNcuQ>
    <xme:9XJgX7gljO71RYnWcYRkbs7bvfhLecJJdZDzqd0OsYM_MClyeQao8i7t3hMuxlcwL
    oGFolw23Qai2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeijedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:9XJgX4m3j8g1LkbVVK03vuNMBFu4ysP65sXvT3gYAB8hQXq1YuNI_A>
    <xmx:9XJgX3ynRckqxCW6RRxRZHjDEcXHRxU02iubXIM7m63ZV8EhtvQ5WA>
    <xmx:9XJgXyR8tXGHSujgzK0-pdOT-GlG7PlMCeVxcxW0bFlCvQlIFq-cow>
    <xmx:9nJgX77cnuMtmC68Hvy9H7uh58PnhrMvyPRtRuY4HbmJmg_NZgs4B7wkplc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9C58F3064683;
        Tue, 15 Sep 2020 03:53:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/msm: Enable expanded apriv support for a650" failed to apply to 5.4-stable tree
To:     jcrouse@codeaurora.org, robdclark@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 09:53:23 +0200
Message-ID: <160015640316855@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 604234f33658cdd72f686be405a99646b397d0b3 Mon Sep 17 00:00:00 2001
From: Jordan Crouse <jcrouse@codeaurora.org>
Date: Thu, 3 Sep 2020 20:03:11 -0600
Subject: [PATCH] drm/msm: Enable expanded apriv support for a650

a650 supports expanded apriv support that allows us to map critical buffers
(ringbuffer and memstore) as as privileged to protect them from corruption.

Cc: stable@vger.kernel.org
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index c5a3e4d4c007..406efaac95a7 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -678,7 +678,8 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
 			A6XX_PROTECT_RDONLY(0x980, 0x4));
 	gpu_write(gpu, REG_A6XX_CP_PROTECT(25), A6XX_PROTECT_RW(0xa630, 0x0));
 
-	if (adreno_is_a650(adreno_gpu)) {
+	/* Enable expanded apriv for targets that support it */
+	if (gpu->hw_apriv) {
 		gpu_write(gpu, REG_A6XX_CP_APRIV_CNTL,
 			(1 << 6) | (1 << 5) | (1 << 3) | (1 << 2) | (1 << 1));
 	}
@@ -1056,6 +1057,9 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	adreno_gpu->registers = NULL;
 	adreno_gpu->reg_offsets = a6xx_register_offsets;
 
+	if (adreno_is_a650(adreno_gpu))
+		adreno_gpu->base.hw_apriv = true;
+
 	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, 1);
 	if (ret) {
 		a6xx_destroy(&(a6xx_gpu->base.base));
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index d5645472b25d..57ddc9438351 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -908,7 +908,7 @@ int msm_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 
 	memptrs = msm_gem_kernel_new(drm,
 		sizeof(struct msm_rbmemptrs) * nr_rings,
-		MSM_BO_UNCACHED, gpu->aspace, &gpu->memptrs_bo,
+		check_apriv(gpu, MSM_BO_UNCACHED), gpu->aspace, &gpu->memptrs_bo,
 		&memptrs_iova);
 
 	if (IS_ERR(memptrs)) {
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index 0db117a7339b..37cffac4cbe3 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -15,6 +15,7 @@
 #include "msm_drv.h"
 #include "msm_fence.h"
 #include "msm_ringbuffer.h"
+#include "msm_gem.h"
 
 struct msm_gem_submit;
 struct msm_gpu_perfcntr;
@@ -139,6 +140,8 @@ struct msm_gpu {
 	} devfreq;
 
 	struct msm_gpu_state *crashstate;
+	/* True if the hardware supports expanded apriv (a650 and newer) */
+	bool hw_apriv;
 };
 
 /* It turns out that all targets use the same ringbuffer size */
@@ -327,4 +330,12 @@ static inline void msm_gpu_crashstate_put(struct msm_gpu *gpu)
 	mutex_unlock(&gpu->dev->struct_mutex);
 }
 
+/*
+ * Simple macro to semi-cleanly add the MAP_PRIV flag for targets that can
+ * support expanded privileges
+ */
+#define check_apriv(gpu, flags) \
+	(((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
+
+
 #endif /* __MSM_GPU_H__ */
diff --git a/drivers/gpu/drm/msm/msm_ringbuffer.c b/drivers/gpu/drm/msm/msm_ringbuffer.c
index 39ecb5a18431..935bf9b1d941 100644
--- a/drivers/gpu/drm/msm/msm_ringbuffer.c
+++ b/drivers/gpu/drm/msm/msm_ringbuffer.c
@@ -27,8 +27,8 @@ struct msm_ringbuffer *msm_ringbuffer_new(struct msm_gpu *gpu, int id,
 	ring->id = id;
 
 	ring->start = msm_gem_kernel_new(gpu->dev, MSM_GPU_RINGBUFFER_SZ,
-		MSM_BO_WC | MSM_BO_GPU_READONLY, gpu->aspace, &ring->bo,
-		&ring->iova);
+		check_apriv(gpu, MSM_BO_WC | MSM_BO_GPU_READONLY),
+		gpu->aspace, &ring->bo, &ring->iova);
 
 	if (IS_ERR(ring->start)) {
 		ret = PTR_ERR(ring->start);

