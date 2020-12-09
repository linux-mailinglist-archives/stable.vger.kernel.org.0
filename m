Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0239C2D45DF
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgLIPxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:53:31 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:43427 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731237AbgLIPx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:53:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 98B931943940;
        Wed,  9 Dec 2020 03:37:27 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:37:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=E1Tfpl
        LhLMk1KClrfNgZIAvxU9MxHccr5FmnOtjh0+c=; b=O6ZABBs851W5nnSxeyESFd
        c8LB/YwiZwJgfZuxeTeMo9RU4IPLckERtI0R5/e2yqQVW3M7p54NDxozSHM/GZKV
        b+e6TiUWrqhevO3Itoo37Zll9MFBo8H+EgYq2YCc+7rfTVrjDzFhxH0iicOuLtwd
        e6YMUAM55sNjiDRQGtbO/e32VC4pP2w0EBhnIGFsCMrQzMtfv7Oj3sdtYxk1kSER
        NE6Cdswuyyx0BDOOHI/mcDIKF4h4sLBUldUH5aBV2qrLhaIj1YAU2/vv5+TgqJzh
        KITX8it/TbLAdq0LLrSbuc0V2+G/Xw8VUTYJfG2OF0Z3fESh0uq8WQ97c9SH5eCg
        ==
X-ME-Sender: <xms:x4zQX7w6BruOMXNnG2_k_rrFk2qq8dViVCKg5z2qGAw8qaxYNdGIyQ>
    <xme:x4zQXzQGsq9piXEJuMj8NotwNzyDFA0dQ2r3YWL9Nbq4Hv4Ieidr5s5E7oDKb8Kee
    -TYmKafHCvsjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:x4zQX1W0r4eM1cT2ZylKCx8TrKSEpZL7vEL5WTjVsyGslMOjHNeQ6w>
    <xmx:x4zQX1iSE9sGVEeRzcvGWkR_I7lR9UWXuh02LaDPAcR8NPXVN1V4Gw>
    <xmx:x4zQX9AjNFIHPpsZdZD4UmXkY7yLsbPdYLeJlkyNdV4CYWmgsZB5-g>
    <xmx:x4zQX66QeU9rKgsI8eJjlQFER7-LK6xP551i718sFASieXr6kRoFmA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43803240066;
        Wed,  9 Dec 2020 03:37:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amdgpu/pm/smu11: Fix fan set speed bug" failed to apply to 5.9-stable tree
To:     Arunpravin.PaneerSelvam@amd.com, alexander.deucher@amd.com,
        kenneth.feng@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:38:45 +0100
Message-ID: <160750312520892@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From acab02c1af43d3a9051524579b1c3dcfbfa5479d Mon Sep 17 00:00:00 2001
From: Arunpravin <Arunpravin.PaneerSelvam@amd.com>
Date: Fri, 27 Nov 2020 21:40:24 +0530
Subject: [PATCH] drm/amdgpu/pm/smu11: Fix fan set speed bug

Fix fan set speed calculation.

Suggested-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Arunpravin <Arunpravin.PaneerSelvam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index 2380759ddf48..6db96fa1df09 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1164,7 +1164,12 @@ int smu_v11_0_set_fan_speed_rpm(struct smu_context *smu,
 	if (ret)
 		return ret;
 
-	crystal_clock_freq = amdgpu_asic_get_xclk(adev);
+	/*
+	 * crystal_clock_freq div by 4 is required since the fan control
+	 * module refers to 25MHz
+	 */
+
+	crystal_clock_freq = amdgpu_asic_get_xclk(adev) / 4;
 	tach_period = 60 * crystal_clock_freq * 10000 / (8 * speed);
 	WREG32_SOC15(THM, 0, mmCG_TACH_CTRL,
 		     REG_SET_FIELD(RREG32_SOC15(THM, 0, mmCG_TACH_CTRL),

