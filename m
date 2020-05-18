Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E741D79E0
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgERNag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:30:36 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:38955 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726854AbgERNaf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:30:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id AFBFB1943088;
        Mon, 18 May 2020 09:30:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:30:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vCXaFO
        s3dNPI1QciGGGUWkv0itVzC/4SCYUUY341/XQ=; b=oFs7Y+m8X8FQlh9B+h2yQi
        rLd0ivbg1/waC9IOilwIfSKWhpYIVCq6gj4M0TyNzh9Y6lYAnavQ+mN/LEJ/3q4J
        uvNulmFcC35ryIcG417sP0b80ixmw7X1CCtfLXUsHT/9Hwa6TIfyqdn4pGCOS0Y3
        4IU0u/PcDuHYnKivwYEiD+ssQegad6E4sksmDC14tJaOOcd0vK0d1TGVobg7yEGe
        pKP6fUsVqGlkoSu0Bv5cLSLe1Igv3Dq2vLE0xfnf273YkmJKHKYD0iMiyTcCc9H4
        hTa68hywDAMH/Vw/j+vblxb1Q0kxmQCPxOngLK7TrZZW9J5AsRuzuEr6Tw2ZY+UQ
        ==
X-ME-Sender: <xms:-o3CXimFvMUF0L7Nq016ejxzsQTuPLCMBW_gOvJNx7mWJBgmW-doAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:-o3CXp2kqSgDZBw3glSU0CY9VUWHw23yieVYKJAqfo0msTX-IH_P3w>
    <xmx:-o3CXgp9PJj5qQr1qv5iFQaTnZpuxJdnjWBuxcJPjMIlT8_w_NUIUw>
    <xmx:-o3CXmmlM2BXtfBgcPEUZG7Xds2knpHlP_ErbKInkuNWcqh0t-o9rg>
    <xmx:-o3CXl9xNKLPh6xAQATLbwAxk0wGWZT3WVpz7oLPoUcKzIHGDfLFRg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4FA04328005D;
        Mon, 18 May 2020 09:30:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y" failed to apply to 4.19-stable tree
To:     a.fatoum@pengutronix.de, clemens.gruber@pqgruber.com,
        shawnguo@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:30:29 +0200
Message-ID: <1589808629122191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

