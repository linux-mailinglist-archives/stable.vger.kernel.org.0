Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7C6161B47
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgBQTK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:10:29 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57077 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727749AbgBQTK3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:10:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B002F20D7C;
        Mon, 17 Feb 2020 14:10:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pnZpta
        xLUFC5P33gdUBFNsXQ7AgC/kcjEPJq1jKTSWE=; b=PB6Vh+R0BvOLfG6j0Vcx3i
        2aXFSbF1yB+r+h5U/i8F9q/d7OGBY1KuYgg+luLXyA38InebmrHaQH4CDBAtsoT9
        C0fvxGRwz29fE89SqESzOj3RhtdS1i33gHmP8CgZ9SU55OUbwHbu7a5MZNr0+VhE
        FDZ/32xXJiNKC8oO+3oqMP0sIonSBYYCKMu28uD5thVmj98dkumk+FW+9OTpjCVr
        1SHcCAFy3v1ZgMyQw5ehMPHPqBn+AKv09vSxWu/TxTZqoGmIQ2NTbHf68KzOOnCY
        MGLRhd8SZDhq0TVNjjlUlBoGnwrcSnAEVrWNDB4iAjQ3uKJ7jVXQj3RKd18YHKxw
        ==
X-ME-Sender: <xms:JOVKXl7N2eMs4SS42o4f9wTi9HRGRHCRURCiJhGAt-NY-rVk8r162Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JOVKXvVldmzqobxIxjUUkfcV0iwztjJs_M3aP3Y7iqyNNObQJEHh9g>
    <xmx:JOVKXjvSvQxVkyt5DOMHa9D2UIGkdJnfFHBvPn0GY_TumNBS51ZgWA>
    <xmx:JOVKXkqhbK22I-l5lAjUyZoIAKWvkdypWG8PgQ1onKT7G5A1FMDhIA>
    <xmx:JOVKXtyal3xfPl_hTfn-2Otv2k_HL0sRpfkBEWOiujqWoQWNdJkSpQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 544063280059;
        Mon, 17 Feb 2020 14:10:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] ARM: npcm: Bring back GPIOLIB support" failed to apply to 4.9-stable tree
To:     krzk@kernel.org, olof@lixom.net, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:10:18 +0100
Message-ID: <158196661895169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

