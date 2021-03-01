Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431E2327B95
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhCAKHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:07:39 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:51925 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231696AbhCAKGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:06:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 142301940E7D;
        Mon,  1 Mar 2021 05:05:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 05:05:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=T9MbUe
        tr6C9bfW9gUYoxDcRn/V7PB99skjsg34VI+oE=; b=r7KOGlDZuL56NYmbJw/TGf
        Q64VkRavnqCpjIrBlCyMt9Cn8LgR7TNLM463/70od8R5MDSdZqVdl8pelbbecT4X
        1rswlWeaQBgytnO9H/87/5K5jXKgeTrkJRBeigQ8jxWhTSNLRvxiJCfv4ZEFBmAd
        5/hTeWPxrnszlmyN421AzoBiBQmC+nYRjPqu1Ut84TWkx9RzJVJlvAtbJDm83m/w
        EfSULl6Uem10pHfjr2J84sLreKrmM34r5+xZBSWl18jh6ZdQ/wshK4IS1/f2Df+z
        Rg3lW9Kl/6k42t4oLlVH/KbMXSDte34zdEm+GYU+SgGO7kdwnJJe2Pnilst6HQqw
        ==
X-ME-Sender: <xms:Vbw8YHMo9_7sFovssczKeNI5XGTC2j6tivjFnqi_oZ_ToMRg_KMtOg>
    <xme:Vbw8YB-njel4ZcIw-IPUt-4FH9npBUVw1IePSh89NgAKMR7zQtUd9XAAT-zkeibjR
    smYSBTb048TYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Vbw8YGRaap8uvPYZusvPwbZPQ8hM3jgzE7lj90Pi82N-lc5JkxRmxg>
    <xmx:Vbw8YLvAkb5KoKknQw0hYYx9LQsfp1-U6NubHWpwiCIySfzuGQW5og>
    <xmx:Vbw8YPfV3ina4DGzMulYT4387uKZyXlBD35Cyn8-LjW1mDs8H2PGIg>
    <xmx:Vrw8YPnfmu9qzLPkaWhP61nECaPq1vmG9URCYiky1ju5SFnacNhFqQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B806424005B;
        Mon,  1 Mar 2021 05:05:09 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu: fix DRM_INFO flood if display core is not" failed to apply to 5.11-stable tree
To:     alexandre.f.demers@gmail.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:05:01 +0100
Message-ID: <1614593101135183@kroah.com>
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

From 044a48f420b9d3c19a135b821c34de5b2bee4075 Mon Sep 17 00:00:00 2001
From: Alexandre Demers <alexandre.f.demers@gmail.com>
Date: Thu, 7 Jan 2021 18:53:03 -0500
Subject: [PATCH] drm/amdgpu: fix DRM_INFO flood if display core is not
 supported (bug 210921)

This fix bug 210921 where DRM_INFO floods log when hitting an unsupported ASIC in
amdgpu_device_asic_has_dc_support(). This info should be only called once.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=210921
Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index b69c34074d8d..087afab67e22 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3034,7 +3034,7 @@ bool amdgpu_device_asic_has_dc_support(enum amd_asic_type asic_type)
 #endif
 	default:
 		if (amdgpu_dc > 0)
-			DRM_INFO("Display Core has been requested via kernel parameter "
+			DRM_INFO_ONCE("Display Core has been requested via kernel parameter "
 					 "but isn't supported by ASIC, ignoring\n");
 		return false;
 	}

