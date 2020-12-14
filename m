Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AB32D998B
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 15:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438851AbgLNOOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 09:14:48 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57361 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438848AbgLNOOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 09:14:48 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1FFD51942D48;
        Mon, 14 Dec 2020 09:13:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 14 Dec 2020 09:13:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=20f0Ja
        vaI5lkU51e0nRcMd2/1WqXAOkfXDvmw4jMQpc=; b=DvyWqLy9ivzU1vCRbwvDfG
        wI0BFXWyCjr82y9iayA7xk9+Ap7GElJeK+9EDwiEOCKKUBihboQet2Y1pg1vbu1z
        /68+4VIjf4Y0GeChMkX5VcKhqkSkOKDbZT/aPyCygGfF9JqXvb3wNAmFhB2p6Mxh
        WyVwl5SoZXjfpX2IxrW3AeNhFl9K4JB7lmzBg77E3/fcaqrL4j2l4yrYQTIF7eBP
        kvynWJX/49YWX11qX9FKr4e8ScbsRa3paBf/FMfr6PieUAeWd8Pqxmaf/643UCZa
        6/hGfCX1H22jqMBUj9/mI8XDzjLrrr0nNUmobpS5FA3SPITLmqqRCMIKTBXbODEQ
        ==
X-ME-Sender: <xms:FXPXX_Lvi4gqq0K2XtEztOASUZRXiJzfK_FO4c-FgEw40J19OkyKvg>
    <xme:FXPXXzKyNjT0QG1B9fFS9FCR0l5PdNMTy1lOFL7wgAKBiljcg36SptfK3Nh4sDU92
    UH-dXgUFd1KiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:FXPXX3sj2_ivxnVLoppfp1uZFzD5DHwOQtnn-qW_SecUWmWUTj1sZQ>
    <xmx:FXPXX4YJdnuIj8hTqytzoco6DImSdixlorJE7ABLthlEzGGi3Rl7OA>
    <xmx:FXPXX2Y2nNVDWExUVjLNdLffJ-vGi06MmMNZVJ4_boEtw0YXT2LbWQ>
    <xmx:FnPXX_AUXd1goAZl8uL-ZTT5D5kTujsbXSod0ueAt3-fqsRRe_3enw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 955E4240064;
        Mon, 14 Dec 2020 09:13:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix size calculation with stolen vga memory" failed to apply to 5.9-stable tree
To:     alexander.deucher@amd.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 14 Dec 2020 15:14:47 +0100
Message-ID: <1607955287171170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 157fe68d74c2ad2db438c91af9ed3d3a51de4ed7 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Mon, 7 Dec 2020 13:12:29 -0500
Subject: [PATCH] drm/amdgpu: fix size calculation with stolen vga memory
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If we need to keep the stolen vga memory, make sure it is
at least as big as the legacy vga size.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 36604d751d62..3e4892b7b7d3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -499,6 +499,9 @@ void amdgpu_gmc_get_vbios_allocations(struct amdgpu_device *adev)
 	else
 		size = amdgpu_gmc_get_vbios_fb_size(adev);
 
+	if (adev->mman.keep_stolen_vga_memory)
+		size = max(size, (unsigned)AMDGPU_VBIOS_VGA_ALLOCATION);
+
 	/* set to 0 if the pre-OS buffer uses up most of vram */
 	if ((adev->gmc.real_vram_size - size) < (8 * 1024 * 1024))
 		size = 0;

