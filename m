Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE39C1D79E3
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgERNal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:30:41 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:49545 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726854AbgERNal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:30:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id EC97C194309E;
        Mon, 18 May 2020 09:30:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xZ0Rra
        r/l480tkj9cMBRa8XlaG9gdyA6UhpMhuQaJKs=; b=DKu89cgbyIMU1U7rrhcVQ3
        sITP7xE0Ys9Lv/xoIAhhRW3J0stLlP9c4aSflEVDsnov2hjOMiAKIpWCq2jjaebe
        xxRItZ390ik0Afgj53QDL/GT0qb6TGNKuHoDeSyjdsrdsBFeJoJcLOdgaKHWH3gS
        L2M2aSnJkUHg5+LyBbu+nL4c3KhXOJs2TRC3KU2h1uXsteKlS1AWjPVQvSd+vS9z
        iqfUI7CWe5s4FU0sX8/NywVujf+zJEISsyt7fo3Tu2GMBeZrIA+k2SzVSbbZDS+w
        VKHSPa30w7SN6zn4qNsnBx5ovb1KV1eVdTSLo0I21JfOEAsXQmm74ztPbhAoCxdA
        ==
X-ME-Sender: <xms:_43CXm4sho43hnqQC5B5_xcJ_uDcmsFiBwE497ji8XscLVMbzwclkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:_43CXv7aadwXnKaOVjJxaLCwL-P8WGia4zFdET6Yyh7m1SBGPpMDsg>
    <xmx:_43CXlfKWhHMph3_kWHJzIk2NfG8ilvxsmvgCKihR4CbELukzxA36g>
    <xmx:_43CXjK9iTTCri8nPag1bmCnCewn744RcNYXNmMRc5JdV3gGj0x8FQ>
    <xmx:_43CXkw7QBArs04_66wxRz1JbFV3_sy5i56mnTlVzOgE2ZY8pje8tg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 84ADE30663CF;
        Mon, 18 May 2020 09:30:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y" failed to apply to 4.9-stable tree
To:     a.fatoum@pengutronix.de, clemens.gruber@pqgruber.com,
        shawnguo@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:30:31 +0200
Message-ID: <1589808631131245@kroah.com>
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

From 3100423dc133c25679dbaa1099404651b8ae3af9 Mon Sep 17 00:00:00 2001
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Date: Mon, 23 Mar 2020 09:19:33 +0100
Subject: [PATCH] ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y

512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
introduced an unintended linker error for i.MX6 configurations that have
ARM_CPU_SUSPEND=n which can happen if neither CONFIG_PM, CONFIG_CPU_IDLE,
nor ARM_PSCI_FW are selected.

Fix this by having v7_cpu_resume() compiled only when cpu_resume() it
calls is available as well.

The C declaration for the function remains unguarded to avoid future code
inadvertently using a stub and introducing a regression to the bug the
original commit fixed.

Cc: <stable@vger.kernel.org>
Fixes: 512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
Reported-by: Clemens Gruber <clemens.gruber@pqgruber.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>

diff --git a/arch/arm/mach-imx/Makefile b/arch/arm/mach-imx/Makefile
index 03506ce46149..e7364e6c8c6b 100644
--- a/arch/arm/mach-imx/Makefile
+++ b/arch/arm/mach-imx/Makefile
@@ -91,8 +91,10 @@ AFLAGS_suspend-imx6.o :=-Wa,-march=armv7-a
 obj-$(CONFIG_SOC_IMX6) += suspend-imx6.o
 obj-$(CONFIG_SOC_IMX53) += suspend-imx53.o
 endif
+ifeq ($(CONFIG_ARM_CPU_SUSPEND),y)
 AFLAGS_resume-imx6.o :=-Wa,-march=armv7-a
 obj-$(CONFIG_SOC_IMX6) += resume-imx6.o
+endif
 obj-$(CONFIG_SOC_IMX6) += pm-imx6.o
 
 obj-$(CONFIG_SOC_IMX1) += mach-imx1.o

