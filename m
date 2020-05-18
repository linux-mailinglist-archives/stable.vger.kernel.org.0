Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD6D1D79DF
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgERNae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:30:34 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:51897 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726854AbgERNae (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:30:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 514B41943094;
        Mon, 18 May 2020 09:30:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:30:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=o4t8Fj
        OJps66ts9Q6ZWRXX1R3Gzi5MwtFcf3gn2/amA=; b=3paY8JoMv53iu/4QrA7/sL
        6yiX68lhQA3HYJz/Lo8l8lK1E2PepVxh+kWBn1aMdxMdlUJY4qV7zKhubXEwxjGU
        9nuqX485t1PUhwiUWXy7g58tiv0Te6O+5vpUoLVbihHvZ+tAhFQpDNOO155CeLqM
        Cr1obUKhTf+ouqy526EtsUP1USShEY2tg25UCXP5dlk3UlQp/EjeGIjLQ7dUakgK
        cuQJGHYFZocnLqzKILMaaZavqlvS6vS0ZHSWclvpsR0hlCK+uIik8n5m27BlsNN3
        il4PznXmsuTDoClR00xAVlcGw0JWlQqq7/H/28Sr/LxB2UgByn+OheZr1faJn34A
        ==
X-ME-Sender: <xms:-Y3CXs4Oa9sicUxLRKcIicd5CGwaUnMo8hPUC2mHCqlwWMFwFeMAvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:-Y3CXt59wC333X1ZBqQce0CPSABSS2YG0GRh2CgBvKtuCbpl-ZvLYg>
    <xmx:-Y3CXrdjE_BpCPY_raxZTtK6QBIiyjyJZdTD2QRqFCeK-r1jCRSHeg>
    <xmx:-Y3CXhJLb4ddxyQxqTD3cKl7y7gANkuZ31TGLaREuJOmxgQCffs9PA>
    <xmx:-Y3CXqygLji6eNI2RdYJQJwWvlJfhS071qo4XBkcJQrFANNDkah0sg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF05B328005A;
        Mon, 18 May 2020 09:30:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y" failed to apply to 5.4-stable tree
To:     a.fatoum@pengutronix.de, clemens.gruber@pqgruber.com,
        shawnguo@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:30:29 +0200
Message-ID: <158980862999243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

