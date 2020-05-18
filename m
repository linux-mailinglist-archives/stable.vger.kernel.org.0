Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367151D79DE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgERNad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:30:33 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41507 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726726AbgERNad (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:30:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D7F9E19430A4;
        Mon, 18 May 2020 09:30:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fS0nrW
        FHD1qeJ7MSS96H3F+v7t8hsVlRGM/nBb+cpVk=; b=EFVDggrfk7b2+lj57nJB1S
        gQRYF8/VaqWPP71158j5Mwspy5Nu38D1Py7+e+8+EGfZGH5vGV+D+8ZXru8rF24n
        rrkr8Js9z2BLiMQ/E1fYXxqTsI9rQvuqmVQA73tM+7UBg+cIlyDhNP0fS8yHbJ/f
        je0a9Rr/OHQrk+OOWoGa21lM15zHnaPzoBi8ZBjoR+punxGJx5j8VnlQO3RIat4A
        WfeoutKgCtGABlA9sXm8qLoHRV0uiQUSHbQPcrKg8w8XWq7Mz8Rzrlru8qc3+DcZ
        /uZvU+TZBG4ZLLj5z44LW7ILOb0OuZNWQnLlTMowalTPmpPXq6pq/naDIbaFEpbw
        ==
X-ME-Sender: <xms:9o3CXiX4RtgQEvCdQpnasKXCur1pPo3zZ-CJPl82us_wDNpNRJUZAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:943CXukBO_ncNCVgY6sqz0MQ50rCoZdU3pJHJUma2SCmdqW0KyGgqQ>
    <xmx:943CXmZ-A-qWIvZKP-gP0Tla9CzpbB3SwDvMINGGuKbDX8XJLdQH7w>
    <xmx:943CXpXh9wW37grLesuSzUZH4Jy9JN2FY1n397Ha0WEq56GqIOh-vw>
    <xmx:943CXjvC_xxyaTQAEHFeSPK-fcbSc9nxFljAynCFK-IkuJWnTAIezQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AB48830663ED;
        Mon, 18 May 2020 09:30:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ARM: imx: provide v7_cpu_resume() only on ARM_CPU_SUSPEND=y" failed to apply to 5.6-stable tree
To:     a.fatoum@pengutronix.de, clemens.gruber@pqgruber.com,
        shawnguo@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:30:29 +0200
Message-ID: <158980862996131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
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

