Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572D526A030
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 09:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIOHwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 03:52:42 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:55361 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbgIOHwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Sep 2020 03:52:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8BA556A7;
        Tue, 15 Sep 2020 03:52:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 15 Sep 2020 03:52:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WrxPfl
        UEeJv5B/TU2ebErghIBCcsc+Z2qCo7oG+EUjs=; b=mJjWcTt/k7YZ0JY4cxWblN
        TAqo+xXscCRwKNbzcrAnW4xk8vL8tgakW2Lk9YzJgtJS5/dPHK3T4mfxHS25HQ+b
        kmHQiN1ZfnwfSn6H4VHtyoYkjhHVuVX27oTSYRXWgy54/0tA2pv+Okfq/El/py99
        jRzQso6V3Sh55wmEeyhsvhjJn+w6pxsaG2EMA1KWjGygmDozo63NFoMfNjfVSqSo
        aEo4mbfncqjVvD7/PiLvS/wlXd5PJr73qL5OM11Tvf/DKo2wPs9SLwpFenehZVIh
        r56r1R5MmLSwYANetAlLtxmXHD4E5HPdDbf6Y+4d9hpPkMiF1Ak9ScOwWTzCNx7Q
        ==
X-ME-Sender: <xms:wHJgXwbClONSS4Vtiw1Nql4Kyo13JohkVWx28jis2s0p-4c1i4xtCg>
    <xme:wHJgX7YcJua9VkWgSVsz52KS61QKbC7AqW4Q8leAq5qQI97hWLQOwKfYWz5WxIN1L
    xoTgDujP0RZnA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeijedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:wHJgX68VLn-AH73eQAKoI-bDGXf_VlUinMRxb-ZK534aSPS5IbnO2Q>
    <xmx:wHJgX6rhUZJpjFQO6m1qjc9GNg7PzaptxPayG9KGHFWPUj-byM2OJw>
    <xmx:wHJgX7qVl444A3lJH6ZfIqDb2_3VkStzva7tVumBkCu9BcTTcY5kVA>
    <xmx:wXJgX6SZAACjhwVP7-UvXdotaDrNvi3qt2jCRnUgknoP6_AOUKJTHkGMUr0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A595B3064688;
        Tue, 15 Sep 2020 03:52:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/msm: Disable the RPTR shadow" failed to apply to 5.4-stable tree
To:     jcrouse@codeaurora.org, robdclark@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Sep 2020 09:52:30 +0200
Message-ID: <1600156350118197@kroah.com>
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

From f6828e0c4045f03f9cf2df6c2a768102641183f4 Mon Sep 17 00:00:00 2001
From: Jordan Crouse <jcrouse@codeaurora.org>
Date: Thu, 3 Sep 2020 20:03:13 -0600
Subject: [PATCH] drm/msm: Disable the RPTR shadow

Disable the RPTR shadow across all targets. It will be selectively
re-enabled later for targets that need it.

Cc: stable@vger.kernel.org
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>

diff --git a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
index 6021f8d9efd1..48fa49f69d6d 100644
--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -164,6 +164,11 @@ static int a2xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
+	gpu_write(gpu, REG_AXXX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
+	gpu_write(gpu, REG_AXXX_CP_RB_BASE, lower_32_bits(gpu->rb[0]->iova));
+
 	/* NOTE: PM4/micro-engine firmware registers look to be the same
 	 * for a2xx and a3xx.. we could possibly push that part down to
 	 * adreno_gpu base class.  Or push both PM4 and PFP but
diff --git a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
index 0a5ea9f56cb8..f6471145a7a6 100644
--- a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
@@ -211,6 +211,16 @@ static int a3xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
+	/*
+	 * Use the default ringbuffer size and block size but disable the RPTR
+	 * shadow
+	 */
+	gpu_write(gpu, REG_AXXX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
+	/* Set the ringbuffer address */
+	gpu_write(gpu, REG_AXXX_CP_RB_BASE, lower_32_bits(gpu->rb[0]->iova));
+
 	/* setup access protection: */
 	gpu_write(gpu, REG_A3XX_CP_PROTECT_CTRL, 0x00000007);
 
diff --git a/drivers/gpu/drm/msm/adreno/a4xx_gpu.c b/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
index b9b26b2bf9c5..954753600625 100644
--- a/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
@@ -267,6 +267,16 @@ static int a4xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
+	/*
+	 * Use the default ringbuffer size and block size but disable the RPTR
+	 * shadow
+	 */
+	gpu_write(gpu, REG_A4XX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
+	/* Set the ringbuffer address */
+	gpu_write(gpu, REG_A4XX_CP_RB_BASE, lower_32_bits(gpu->rb[0]->iova));
+
 	/* Load PM4: */
 	ptr = (uint32_t *)(adreno_gpu->fw[ADRENO_FW_PM4]->data);
 	len = adreno_gpu->fw[ADRENO_FW_PM4]->size / 4;
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index e718f964d590..ce3c0b5c167b 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -703,8 +703,6 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
-	a5xx_preempt_hw_init(gpu);
-
 	if (!adreno_is_a510(adreno_gpu))
 		a5xx_gpmu_ucode_init(gpu);
 
@@ -712,6 +710,15 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
+	/* Set the ringbuffer address */
+	gpu_write64(gpu, REG_A5XX_CP_RB_BASE, REG_A5XX_CP_RB_BASE_HI,
+		gpu->rb[0]->iova);
+
+	gpu_write(gpu, REG_A5XX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
+	a5xx_preempt_hw_init(gpu);
+
 	/* Disable the interrupts through the initial bringup stage */
 	gpu_write(gpu, REG_A5XX_RBBM_INT_0_MASK, A5XX_INT_MASK);
 
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 406efaac95a7..74bc27eb4203 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -695,6 +695,13 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		goto out;
 
+	/* Set the ringbuffer address */
+	gpu_write64(gpu, REG_A6XX_CP_RB_BASE, REG_A6XX_CP_RB_BASE_HI,
+		gpu->rb[0]->iova);
+
+	gpu_write(gpu, REG_A6XX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
 	/* Always come up on rb 0 */
 	a6xx_gpu->cur_ring = gpu->rb[0];
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index d2dbb6968cba..459f10a3710b 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -400,26 +400,6 @@ int adreno_hw_init(struct msm_gpu *gpu)
 		ring->memptrs->rptr = 0;
 	}
 
-	/*
-	 * Setup REG_CP_RB_CNTL.  The same value is used across targets (with
-	 * the excpetion of A430 that disables the RPTR shadow) - the cacluation
-	 * for the ringbuffer size and block size is moved to msm_gpu.h for the
-	 * pre-processor to deal with and the A430 variant is ORed in here
-	 */
-	adreno_gpu_write(adreno_gpu, REG_ADRENO_CP_RB_CNTL,
-		MSM_GPU_RB_CNTL_DEFAULT |
-		(adreno_is_a430(adreno_gpu) ? AXXX_CP_RB_CNTL_NO_UPDATE : 0));
-
-	/* Setup ringbuffer address - use ringbuffer[0] for GPU init */
-	adreno_gpu_write64(adreno_gpu, REG_ADRENO_CP_RB_BASE,
-		REG_ADRENO_CP_RB_BASE_HI, gpu->rb[0]->iova);
-
-	if (!adreno_is_a430(adreno_gpu)) {
-		adreno_gpu_write64(adreno_gpu, REG_ADRENO_CP_RB_RPTR_ADDR,
-			REG_ADRENO_CP_RB_RPTR_ADDR_HI,
-			rbmemptr(gpu->rb[0], rptr));
-	}
-
 	return 0;
 }
 
@@ -427,11 +407,8 @@ int adreno_hw_init(struct msm_gpu *gpu)
 static uint32_t get_rptr(struct adreno_gpu *adreno_gpu,
 		struct msm_ringbuffer *ring)
 {
-	if (adreno_is_a430(adreno_gpu))
-		return ring->memptrs->rptr = adreno_gpu_read(
-			adreno_gpu, REG_ADRENO_CP_RB_RPTR);
-	else
-		return ring->memptrs->rptr;
+	return ring->memptrs->rptr = adreno_gpu_read(
+		adreno_gpu, REG_ADRENO_CP_RB_RPTR);
 }
 
 struct msm_ringbuffer *adreno_active_ring(struct msm_gpu *gpu)

