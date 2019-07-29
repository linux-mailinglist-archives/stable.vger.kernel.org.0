Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588E079056
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 18:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728518AbfG2QHo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 12:07:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40741 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727796AbfG2QHo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 12:07:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A0F2920782;
        Mon, 29 Jul 2019 12:07:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 29 Jul 2019 12:07:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0QnhCD
        +zc/YKewAZ+8+MZGIPCSOfq6+ZBASgUGbxUhs=; b=gguVHBqNAqHl5xYyuxJFNb
        wpOONHY6nhev/jxIHSCJEpcrmPgcuwABC5/9NVG/VRcGg0VqrJN+MhoiFXEqLmv7
        HTtAIWnuSTDTaC2wc0hH037Zq1vH42Bs87E3t22nwviv8U3n5LksUYfr1dobH8Y8
        KNl/E9FaFLjh3TtJeyQ4lflo+KBVNPa5vS9aP/6LvQAFdSJXqIa4/x4hORbx6LcU
        QC9n28CVBC3DYkrtNWqKyKYCCMPdbkxrSfjpYQ/j5SdGVxatEjSvwqqjfd2bqBbR
        eoYk+m8/sG9gxo/XqaxwwmZ1Nmt0IO4Kj9S777tmHFqQ7YCu85bnd9asI5lxudQg
        ==
X-ME-Sender: <xms:zxk_XVpNu67PAqqsH8NT7u4S4TffR4pKTuHx0NXuT4E7OHwxLKOZAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrledugdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:zxk_XRRPgoSyXQRNkiBqVhKI9tMa4QgeZPLYULQw-_gorxpBRiUngA>
    <xmx:zxk_XVoLXelkWF5WSDPKLEbmMasKacDIbh0WzC5JQllI6ehub4L3pQ>
    <xmx:zxk_XXyR0OUAGUaYIbJh4s6WSzk5FHhPQxp-h4AQwwtHfWwOQcXKjg>
    <xmx:zxk_XRlF2emq5DvhihG-Zl2W3zGKXnGvsLUDDysaJU9-yCUGiS766w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E8D298005B;
        Mon, 29 Jul 2019 12:07:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu: Don't skip display settings in hwmgr_resume()" failed to apply to 5.2-stable tree
To:     lyude@redhat.com, Likun.Gao@amd.com, Rex.Zhu@amd.com,
        alexander.deucher@amd.com, evan.quan@amd.com, ray.huang@amd.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jul 2019 18:07:41 +0200
Message-ID: <1564416461175229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ee006eb00a00198d21dad60696318fd443a59f88 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Thu, 20 Jun 2019 19:21:26 -0400
Subject: [PATCH] drm/amdgpu: Don't skip display settings in hwmgr_resume()

I'm not entirely sure why this is, but for some reason:

921935dc6404 ("drm/amd/powerplay: enforce display related settings only on needed")

Breaks runtime PM resume on the Radeon PRO WX 3100 (Lexa) in one the
pre-production laptops I have. The issue manifests as the following
messages in dmesg:

[drm] UVD and UVD ENC initialized successfully.
amdgpu 0000:3b:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring vce1 test failed (-110)
[drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block <vce_v3_0> failed -110
[drm:amdgpu_device_resume [amdgpu]] *ERROR* amdgpu_device_ip_resume failed (-110).

And happens after about 6-10 runtime PM suspend/resume cycles (sometimes
sooner, if you're lucky!). Unfortunately I can't seem to pin down
precisely which part in psm_adjust_power_state_dynamic that is causing
the issue, but not skipping the display setting setup seems to fix it.
Hopefully if there is a better fix for this, this patch will spark
discussion around it.

Fixes: 921935dc6404 ("drm/amd/powerplay: enforce display related settings only on needed")
Cc: Evan Quan <evan.quan@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Rex Zhu <Rex.Zhu@amd.com>
Cc: Likun Gao <Likun.Gao@amd.com>
Cc: <stable@vger.kernel.org> # v5.1+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
index 0b0d83c2a678..a24beaa4fb01 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/hwmgr.c
@@ -327,7 +327,7 @@ int hwmgr_resume(struct pp_hwmgr *hwmgr)
 	if (ret)
 		return ret;
 
-	ret = psm_adjust_power_state_dynamic(hwmgr, true, NULL);
+	ret = psm_adjust_power_state_dynamic(hwmgr, false, NULL);
 
 	return ret;
 }

