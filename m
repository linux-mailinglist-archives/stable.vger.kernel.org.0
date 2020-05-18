Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350DB1D79ED
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgERNe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:34:29 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:33167 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgERNe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:34:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 662D419407DA;
        Mon, 18 May 2020 09:34:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:34:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZjfRzb
        r4vHh9Iqic2CmR/xaWlaHJ8cqPOhSrzE7yWz4=; b=IluW0w7sGIWOCCMCnNaso4
        mxGZ/XGDUXhlfo73eZnMR9rG1BS3NVL8O5aNdeIhO8PKqg+wvyafY0NbAgUcVaFf
        /oBUVxkpD7lo4+hDi7cRqVkmCpnYh67URCvt+uaxaKcc2yAnFiHSWumRr1ItO4A+
        6blyzVBW3ofurmDwE5I1YLKN6X7SreC4fIk0+zut3iMMNXvpXOHZ4AHXnOjwA6vf
        7jRIba9HLmKg9oCayQjAosyjdsoBAAQEelsZIobr7EYVamMbmlHPVjOIAAQ4o4dg
        RReIVi9q5slYjMcrCyaSmIQkRTAbyj+lVgmt1CGr6uL/lPBJET+OwNkPpH95RndA
        ==
X-ME-Sender: <xms:5I7CXldsgJLlRL0uaVP8_W2DdcrVQfXiGGZqdeA0dE47ol3lxrCt-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:5I7CXjNnLlwAbI-noium23QOeDpcBZ-KA4i2EY1BZz_uqeFQps058g>
    <xmx:5I7CXuga3kQE84Cpy5LsS02TNrOlD9C-9P636mXYRzEANTXHy9ysBQ>
    <xmx:5I7CXu9QgSHgE_YaK2XUc0WLNu0UwbbWUaysvnqN2YE-mu9VWWesdQ>
    <xmx:5I7CXm4tN7uGasxAKL65KhSRtHzzhoDRn19HRbPy-LAnOvVkb-Zp1g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D021730663F4;
        Mon, 18 May 2020 09:34:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu: force fbdev into vram" failed to apply to 4.19-stable tree
To:     alexander.deucher@amd.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:34:25 +0200
Message-ID: <158980886524987@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a6aacb2b26e85aa619cf0c6f98d0ca77314cd2a1 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Tue, 5 May 2020 09:42:26 -0400
Subject: [PATCH] drm/amdgpu: force fbdev into vram
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We set the fb smem pointer to the offset into the BAR, so keep
the fbdev bo in vram.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=207581
Fixes: 6c8d74caa2fa33 ("drm/amdgpu: Enable scatter gather display support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
index 9ae7b61f696a..25ddb482466a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c
@@ -133,8 +133,7 @@ static int amdgpufb_create_pinned_object(struct amdgpu_fbdev *rfbdev,
 	u32 cpp;
 	u64 flags = AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED |
 			       AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS     |
-			       AMDGPU_GEM_CREATE_VRAM_CLEARED 	     |
-			       AMDGPU_GEM_CREATE_CPU_GTT_USWC;
+			       AMDGPU_GEM_CREATE_VRAM_CLEARED;
 
 	info = drm_get_format_info(adev->ddev, mode_cmd);
 	cpp = info->cpp[0];

