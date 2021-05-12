Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F02F37B9A5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhELJvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:51:39 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:42351 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230210AbhELJvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:51:38 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 38E1D14BF;
        Wed, 12 May 2021 05:50:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 05:50:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Oy/URC
        R6yVLcKGBhN25L98uYUqwn7JW+3thND09XOng=; b=QbdZ/rWTolBQY3ydQ4HyCz
        bvv8eYufKjMuP+s+bEfeCKq6MSDAFodoOXCuJtW/nfVOS4dGfLjipxyQjIh6UZdT
        jBg2QfDKeySUrFmqVskLkVPDCTUIvThdK+lck3WgL5U4Tidt0XFOITSt6HuHCBqE
        EajmQZLd5YA6jO7WO/94sk2nLpxiQxrp33TMyRdp2WlTpm/0Ap4NwsvE6ZvtQKBJ
        qDSTSKVWa6CLRxf/9DSZvm6A2uyfRurOdmaBF4UxZtSGXSvBuJVCeu3+nWKX+K3s
        LmkzIYtlwSsMzC3GDnT7C+vvucKgu13+VOXcdYwwHV2lst4kzTA1dU9W30JBvMHA
        ==
X-ME-Sender: <xms:5aSbYBGXKDHs9iYzYRn4WduhlsPotWpSS7cpy6HNdaa6l65ZQdbMJw>
    <xme:5aSbYGW0o6_6Sqi60onCgDdsECsp7-Nbk6_NbeMW-d8nkQ2dmrYwS13b6R3yUvrIT
    kq0pGOQ1uX2uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepteetffekueduveeugfekheekheefvdfhvefgfeffve
    ffieegffejtdefuddvtedtnecuffhomhgrihhnpegtohhnfhhighdrghgsnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:5aSbYDLlQrfdKVI6yeD6ssN1ryb1oejSll4FRiRIMF6RWJmCL0zG8A>
    <xmx:5aSbYHHuYQyV9au9NidTMoCxSifpAuCkZtgAP8ycER-DsFsOJbA4QQ>
    <xmx:5aSbYHXQW0ylEHLpVniGnADhepfjDCE1MBb_52OuXOu2JPi6MoU0lw>
    <xmx:5aSbYOf2Yyzq0i68dGsjqH9j-h3CjARYpK-wMi_HdPTltpR22jbrHLkOrGg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:50:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/amdgpu: Init GFX10_ADDR_CONFIG for VCN v3 in DPG mode." failed to apply to 5.10-stable tree
To:     bas@basnieuwenhuizen.nl, alexander.deucher@amd.com, leo.liu@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:50:28 +0200
Message-ID: <1620813028105222@kroah.com>
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

From 8bf073ca9235fe38d7b74a0b4e779cfa7cc70fc9 Mon Sep 17 00:00:00 2001
From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Date: Wed, 5 May 2021 03:27:49 +0200
Subject: [PATCH] drm/amdgpu: Init GFX10_ADDR_CONFIG for VCN v3 in DPG mode.

Otherwise tiling modes that require the values form this field
(In particular _*_X) would be corrupted upon video decode.

Copied from the VCN v2 code.

Fixes: 99541f392b4d ("drm/amdgpu: add mc resume DPG mode for VCN3.0")
Reviewed-and-Tested by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 3f15bf34123a..cf165ab5dd26 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -589,6 +589,10 @@ static void vcn_v3_0_mc_resume_dpg_mode(struct amdgpu_device *adev, int inst_idx
 	WREG32_SOC15_DPG_MODE(inst_idx, SOC15_DPG_MODE_OFFSET(
 			VCN, inst_idx, mmUVD_VCPU_NONCACHE_SIZE0),
 			AMDGPU_GPU_PAGE_ALIGN(sizeof(struct amdgpu_fw_shared)), 0, indirect);
+
+	/* VCN global tiling registers */
+	WREG32_SOC15_DPG_MODE(0, SOC15_DPG_MODE_OFFSET(
+		UVD, 0, mmUVD_GFX10_ADDR_CONFIG), adev->gfx.config.gb_addr_config, 0, indirect);
 }
 
 static void vcn_v3_0_disable_static_power_gating(struct amdgpu_device *adev, int inst)

