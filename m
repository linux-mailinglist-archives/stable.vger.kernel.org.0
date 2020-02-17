Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96014161B46
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgBQTKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:10:21 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56639 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727749AbgBQTKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:10:21 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A68B21FEB;
        Mon, 17 Feb 2020 14:10:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:10:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qwG9Pn
        T3eTkxcy63WBRsNhX64JODPjPt00MJeKKzd+Q=; b=WFAYS/JyDbATWAlsgqgKc0
        hp46BDxV6+ui5+aK70u5sNIBqfTrRoHbpYYcSJZy5bRiCh7ITq7NIJHpVFCKtGx5
        LfvftJ7DZaAiNBs1EYcdvmKmuzf+90rrQnmtjw9XGAJ3rcgqTn5f5bLpYcFnGMM5
        7Ah8hObn3koQcX+cmGBD9mp/VUz9t1lQjk/v17PeJgn9rVRw6ynl85MZjp1zJzWp
        z8TKjJ3mSF8Zn961j54LRkioEFAzdcXgyp7P7npC1ndRRssCNDwCJgI2H47PMp41
        IKK1fas7OSqDXVeSWdHdZtdsKCgCMKUySuVJfvdZxJdVuP2bZvJsSjNk4Oo94CUQ
        ==
X-ME-Sender: <xms:G-VKXhIqFcEMpEovO0E-m0JVXqYi1te4bTG5bu8aUUGqGKZFH0HMRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:G-VKXu8AEKTj3zTKt3zKVik1jk5DLy2NNNpP2dVecNG79DoJzyobSw>
    <xmx:G-VKXrdJYPjO2FacBdNYK4f4NZTwNlU93Uz0JpXu7k4kcBGl0xxpbg>
    <xmx:G-VKXjmXD7Kd76dKbGKefEEIeGk9cOEl3XVFtINGaaA9z3eTsvMFQQ>
    <xmx:HOVKXnoLr_DryebCak6a_0ZhmlEvDO7X9Cc8tx03_WirPyJXtKjPUA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 971753060BD1;
        Mon, 17 Feb 2020 14:10:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] ARM: npcm: Bring back GPIOLIB support" failed to apply to 4.14-stable tree
To:     krzk@kernel.org, olof@lixom.net, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:10:18 +0100
Message-ID: <158196661868212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e383e871ab54f073c2a798a9e0bde7f1d0528de8 Mon Sep 17 00:00:00 2001
From: Krzysztof Kozlowski <krzk@kernel.org>
Date: Thu, 30 Jan 2020 20:55:24 +0100
Subject: [PATCH] ARM: npcm: Bring back GPIOLIB support

The CONFIG_ARCH_REQUIRE_GPIOLIB is gone since commit 65053e1a7743
("gpio: delete ARCH_[WANTS_OPTIONAL|REQUIRE]_GPIOLIB") and all platforms
should explicitly select GPIOLIB to have it.

Link: https://lore.kernel.org/r/20200130195525.4525-1-krzk@kernel.org
Cc: <stable@vger.kernel.org>
Fixes: 65053e1a7743 ("gpio: delete ARCH_[WANTS_OPTIONAL|REQUIRE]_GPIOLIB")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/arch/arm/mach-npcm/Kconfig b/arch/arm/mach-npcm/Kconfig
index 880bc2a5cada..7f7002dc2b21 100644
--- a/arch/arm/mach-npcm/Kconfig
+++ b/arch/arm/mach-npcm/Kconfig
@@ -11,7 +11,7 @@ config ARCH_NPCM7XX
 	depends on ARCH_MULTI_V7
 	select PINCTRL_NPCM7XX
 	select NPCM7XX_TIMER
-	select ARCH_REQUIRE_GPIOLIB
+	select GPIOLIB
 	select CACHE_L2X0
 	select ARM_GIC
 	select HAVE_ARM_TWD if SMP

