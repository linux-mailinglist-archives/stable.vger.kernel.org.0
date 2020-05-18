Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A581D79FC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgERNfp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:35:45 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52771 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727020AbgERNfo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:35:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7219219409F5;
        Mon, 18 May 2020 09:35:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=crdetf
        UAHdFgqFi55MjgO2xgSEzB3C6F2dQynMRSyok=; b=FH1FimwTxdf6mYJH9xq++m
        PaKfkPrzvgyX1YzLxew7LdROFqTYiU7Et3BE6R8w8I9dtb9B5zGUMqmZxx889sNU
        R0w/+blN9J2XjKxkDeEwSyP8PaCGy1/gizERON091y+jdDy4cblZizJkEM7UOmeI
        ox7v+V5+RygzKk3pZbaMYmfyoMlwGO2Ea4D3i7GunPBNWyrqzIlLMa/bYsmExjwS
        qWlrCkOLasn05SolPIq8VQ+6mmHSsW6S/4zQZYYjbQFF0f3+dcJRQysxMsiRDpqj
        tfv/xKyb0kIY++nSbCf5fw2rOGPQX/BNxiQgCKGGIt+GxF9ISZx6emfGFFv8ZAZA
        ==
X-ME-Sender: <xms:L4_CXtsAKNQN9oQ3Jzv8vTeAwR9ViAzd6Po9tw6jXV79XmgUBHjaoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:L4_CXmc7p0ERb16fcISWpw8066VnnmhNcS3TU8x2gAmgBKYqPhu46g>
    <xmx:L4_CXgwt5z-NFYsjI3hFmW_z4gAbhyl1MYUw2c2R4ALrUKgrd0PnYw>
    <xmx:L4_CXkNi2hvDFKQhOGxh_9xQX-GpjQN9_bsG0QDzwUCFmIyWTm1pYg>
    <xmx:L4_CXiLUGlOsfzX4MFTbaqtyOIqLJ7qOSrqi5kizYNgBLuu_MWoQOg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id EBAC43280067;
        Mon, 18 May 2020 09:35:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu: enable hibernate support on Navi1X" failed to apply to 5.6-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:35:41 +0200
Message-ID: <1589808941179223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b2b6290a23986a5c88384887b8a589a3c4ebe292 Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Thu, 7 May 2020 18:17:55 +0800
Subject: [PATCH] drm/amdgpu: enable hibernate support on Navi1X

BACO is needed to support hibernate on Navi1X.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu.h b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
index 2992a49ad4a5..8ac1581a6b53 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu.h
@@ -945,6 +945,7 @@ struct amdgpu_device {
 
 	/* s3/s4 mask */
 	bool                            in_suspend;
+	bool				in_hibernate;
 
 	/* record last mm index being written through WREG32*/
 	unsigned long last_mm_index;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 466bfe541e45..a735d79a717b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -1181,7 +1181,9 @@ static int amdgpu_pmops_freeze(struct device *dev)
 	struct amdgpu_device *adev = drm_dev->dev_private;
 	int r;
 
+	adev->in_hibernate = true;
 	r = amdgpu_device_suspend(drm_dev, true);
+	adev->in_hibernate = false;
 	if (r)
 		return r;
 	return amdgpu_asic_reset(adev);
diff --git a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
index 09fa685b811b..e77046931e4c 100644
--- a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
@@ -1476,7 +1476,7 @@ static int smu_disable_dpm(struct smu_context *smu)
 	bool use_baco = !smu->is_apu &&
 		((adev->in_gpu_reset &&
 		  (amdgpu_asic_reset_method(adev) == AMD_RESET_METHOD_BACO)) ||
-		 (adev->in_runpm && amdgpu_asic_supports_baco(adev)));
+		 ((adev->in_runpm || adev->in_hibernate) && amdgpu_asic_supports_baco(adev)));
 
 	ret = smu_get_smc_version(smu, NULL, &smu_version);
 	if (ret) {

