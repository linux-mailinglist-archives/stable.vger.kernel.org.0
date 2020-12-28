Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47392E364E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgL1LQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:16:35 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33005 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgL1LQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:16:35 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 28169837;
        Mon, 28 Dec 2020 06:15:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:15:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Pd2tAl
        cj7ZJunyNzT64bBkVtXcFv9VZYNCbBCnMHu3M=; b=BjpUyntqy1UFncuT20X1hT
        O51kMuBXsm9LDKSftiwJsid0lRXcjaetyDUg8+Y0fZMi6JQ+GGHZOA5rJt40VImH
        mTiUp1TnhViQAEZcEbrghpfmSv1czhYOlJv7aKsXsTYSKWraDuiWs3Rs9MklB8l2
        sWnCwgsbmQfxNiuM7CRAEwuo7WowRBXXC6MaUJdks/D9kb1vcf6vSIE4lhqZX+QR
        zk1JeiB+CNNDvxkmEJ/wYCvdvHA8M+z5bOxU49SgH2FHi59E+munnkd7M5tisRKM
        23Oqzddz0b5YYj/cU+se9kV740xqd3SGvD4FgznzSDunWtyMi6+6vM1GluikAYCQ
        ==
X-ME-Sender: <xms:T77pX-YfT-2CqfWMmtZTLgd_5ZRTwPkSOTWN3yOtv2LV2zmi08kRLw>
    <xme:T77pXxZVV0U1wnKFwgrR9dxrJLPrgLCbUdYevmL4g4KX8V1xPS3gRZbu0IBV4uXwh
    iTR2pXD6CAshA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:T77pX49WSXjsn-RzgA4fc7b2PRGCdJzDO6pLrsDa2BC5zq7wQ6q5hw>
    <xmx:T77pXwrBtS1dtIV4cytilh7ea6RLcLHzbB6DlIJWywkgc9FZe0ZGVg>
    <xmx:T77pX5rxTZ8hmqfK77ugbr15x5BWTIyToMXhEct8NP3-B_EnD9b8Eg>
    <xmx:UL7pX6AjHP_1low-KnhpC1E46dzie3o-e1KjtR_oRcpr01_uqkYkyFa3pUA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8AE6C240057;
        Mon, 28 Dec 2020 06:15:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] pinctrl: jasperlake: Fix HOSTSW_OWN offset" failed to apply to 5.10-stable tree
To:     evgreen@chromium.org, andriy.shevchenko@linux.intel.com,
        mika.westerberg@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:16:50 +0100
Message-ID: <160915421010570@kroah.com>
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

From 5aa5541eca04a1c69a05bbb747164926bbf20de4 Mon Sep 17 00:00:00 2001
From: Evan Green <evgreen@chromium.org>
Date: Wed, 11 Nov 2020 15:17:28 -0800
Subject: [PATCH] pinctrl: jasperlake: Fix HOSTSW_OWN offset

GPIOs that attempt to use interrupts get thwarted with a message like:
"pin 161 cannot be used as IRQ" (for instance with SD_CD). This is because
the HOSTSW_OWN offset is incorrect, so every GPIO looks like it's
owned by ACPI.

Fixes: e278dcb7048b1 ("pinctrl: intel: Add Intel Jasper Lake pin controller support")
Cc: stable@vger.kernel.org
Signed-off-by: Evan Green <evgreen@chromium.org>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

diff --git a/drivers/pinctrl/intel/pinctrl-jasperlake.c b/drivers/pinctrl/intel/pinctrl-jasperlake.c
index c5e204c8da9c..ec435b7ab392 100644
--- a/drivers/pinctrl/intel/pinctrl-jasperlake.c
+++ b/drivers/pinctrl/intel/pinctrl-jasperlake.c
@@ -16,7 +16,7 @@
 
 #define JSL_PAD_OWN	0x020
 #define JSL_PADCFGLOCK	0x080
-#define JSL_HOSTSW_OWN	0x0b0
+#define JSL_HOSTSW_OWN	0x0c0
 #define JSL_GPI_IS	0x100
 #define JSL_GPI_IE	0x120
 

