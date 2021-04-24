Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5E836A1A2
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 16:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbhDXOjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Apr 2021 10:39:54 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:54317 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229848AbhDXOjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Apr 2021 10:39:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2DAF81940AA2;
        Sat, 24 Apr 2021 10:39:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 24 Apr 2021 10:39:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=BOcuqW
        5o8nlLIJXw2rq2Lgtz1KMWy0VRl4xPJIaOK8g=; b=Df7PKRjx/CVog3yZgMq/P8
        9wuXRRuh9UCWia2KJdMII3onC7K0gF282da1SA0GINhstGPJBEaWsmnMp9yiyt2v
        MwQLzxHXUtg9l75AXfo3URcHBsC9zfK90t8WayhHtCgJoIzak259Ad+w+NIWBOnF
        6dI5sQ37smT4ut9M6v/ABY5gYfw2tMml0Wzm7Jk5F4395MpXpuGemTwnUycAPekq
        h9xTlJhzva9TtxhH8jfhwGk5++QTKqURtXxdIUznDltJv4bIN9WujH2mfsBj/Nla
        NVKO59hQGGWTNLkMDmGEw1GHiFml7qEqowOCLwR9n5pyZBKNiWBoV3Ie7krmVC2w
        ==
X-ME-Sender: <xms:kS2EYGGLQFvVzdkyd1U-TOYEP2S1qBBBEi0gpFoxwGqQNv04wikEsw>
    <xme:kS2EYHWaFrsYtReHtMyXqJaxQaExHtpGH-ukUbKsFaKMKMv9KUR9LweGBe37LvvJN
    jjqAoOkTZdjVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:kS2EYAI6ochYhTqkrM9CXSnJQeWr6d9vDf7R0oGvJF80e4dPg841oA>
    <xmx:kS2EYAHrfsEa8sR9h_LJ6B6jhN7lU1ObphYZbgxXPYYiM8lsENqXwQ>
    <xmx:kS2EYMW5XCmbt3HtbbntGk5GGY7pdQTR0mJRQhbRvZHjrWLZ6RjBTA>
    <xmx:ki2EYHf1zXYWyiYaCfzkFT0KsKZcyR7YdWVCWr11tLeBIfMMO7pmhg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E90F24005B;
        Sat, 24 Apr 2021 10:39:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amd/display: Update modifier list for gfx10_3" failed to apply to 5.11-stable tree
To:     qingqing.zhuo@amd.com, alexander.deucher@amd.com,
        bas@basnieuwenhuizen.nl
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Apr 2021 16:39:11 +0200
Message-ID: <161927515165209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d638b3ffd27036c062d32cb4efd4be172c2a65e Mon Sep 17 00:00:00 2001
From: Qingqing Zhuo <qingqing.zhuo@amd.com>
Date: Wed, 14 Apr 2021 19:00:01 -0400
Subject: [PATCH] drm/amd/display: Update modifier list for gfx10_3

[Why]
Current list supports modifiers that have DCC_MAX_COMPRESSED_BLOCK
set to AMD_FMT_MOD_DCC_BLOCK_128B, while AMD_FMT_MOD_DCC_BLOCK_64B
is used instead by userspace.

[How]
Replace AMD_FMT_MOD_DCC_BLOCK_128B with AMD_FMT_MOD_DCC_BLOCK_64B
for modifiers with DCC supported.

Fixes: faa37f54ce0462 ("drm/amd/display: Expose modifiers")
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Tested-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 573cf17262da..57e5900059ed 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4296,7 +4296,7 @@ add_gfx10_3_modifiers(const struct amdgpu_device *adev,
 		    AMD_FMT_MOD_SET(DCC_CONSTANT_ENCODE, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_64B, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_128B, 1) |
-		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_128B));
+		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_64B));
 
 	add_modifier(mods, size, capacity, AMD_FMT_MOD |
 		    AMD_FMT_MOD_SET(TILE, AMD_FMT_MOD_TILE_GFX9_64K_R_X) |
@@ -4308,7 +4308,7 @@ add_gfx10_3_modifiers(const struct amdgpu_device *adev,
 		    AMD_FMT_MOD_SET(DCC_CONSTANT_ENCODE, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_64B, 1) |
 		    AMD_FMT_MOD_SET(DCC_INDEPENDENT_128B, 1) |
-		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_128B));
+		    AMD_FMT_MOD_SET(DCC_MAX_COMPRESSED_BLOCK, AMD_FMT_MOD_DCC_BLOCK_64B));
 
 	add_modifier(mods, size, capacity, AMD_FMT_MOD |
 		    AMD_FMT_MOD_SET(TILE, AMD_FMT_MOD_TILE_GFX9_64K_R_X) |

