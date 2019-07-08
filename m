Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2114061EA1
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 14:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbfGHMmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 08:42:13 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51921 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbfGHMmN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 08:42:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 9F3E621B1B;
        Mon,  8 Jul 2019 08:42:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 08 Jul 2019 08:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O4afF3
        3Akh4cHX6TgasPOguH6sVqh+HMj/nyF63MFd8=; b=ypCgGBMizOgYCtUCmysw28
        KKm1wJ3Eg1j12Dndy7EsDTE6TuOWRi1m2Gatt7g2+LLn9rTbqlMwmXoR8RXc0BSa
        60WfF94EzEH8Cpwu7zrXlpLr46D8OHWpcwfnC4Euz020h3u+jc/13kUPOVsq/9om
        tboEsRZFw4cRP04FPc4xaeX3gNDaLKCZ2mb1iJV6ssqQpnbD/14XDJW0hUf3/WiA
        gP8icO4Egy90adDFucFlKnbVnYapo/Nt5NQZVJRwJOH53b8B/iYg+wDrB4l81iSW
        Qb7hvnZHdiBp50PYrZeaV6RZfp7mkaDb9IxsqHm4c8q8i049MuIBkTi9JpO7hTnw
        ==
X-ME-Sender: <xms:JDojXYZW-zVR3NiJ3-Gjg5yEeigjaQn5Dku_Ymm8WzOcWBjPijxnrQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:JDojXT3R5gjbKmgqZrjuX_5iCpMcjM-CIiPlTSwMqQYO70_kHKy0TQ>
    <xmx:JDojXZ0nUs9I8upmONTm1TO6IP50p9A9Y0IxWpkS17NXmqQOlrGhVA>
    <xmx:JDojXY5bYRdHgNAIDYBkDp_trlU3yzZjrD-RXLyooCK7k8snn-4f8w>
    <xmx:JDojXcjK64a0nNtYLXMgU_Dr3p-f5xZA5hwT-7GeVlAohPZZuB-kHQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 16E4D8005A;
        Mon,  8 Jul 2019 08:42:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] MIPS: have "plain" make calls build dtbs for selected" failed to apply to 4.4-stable tree
To:     Cedric_Hombourger@mentor.com, paul.burton@mips.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jul 2019 14:42:01 +0200
Message-ID: <1562589721222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 637dfa0fad6d91a9a709dc70549a6d20fa77f615 Mon Sep 17 00:00:00 2001
From: Cedric Hombourger <Cedric_Hombourger@mentor.com>
Date: Thu, 13 Jun 2019 10:52:50 +0200
Subject: [PATCH] MIPS: have "plain" make calls build dtbs for selected
 platforms

scripts/package/builddeb calls "make dtbs_install" after executing
a plain make (i.e. no build targets specified). It will fail if dtbs
were not built beforehand. Match the arm64 architecture where DTBs get
built by the "all" target.

Signed-off-by: Cedric Hombourger <Cedric_Hombourger@mentor.com>
[paul.burton@mips.com: s/builddep/builddeb]
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: stable@vger.kernel.org # v4.1+

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 8f4486c4415b..eceff9b75b22 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -17,6 +17,7 @@ archscripts: scripts_basic
 	$(Q)$(MAKE) $(build)=arch/mips/boot/tools relocs
 
 KBUILD_DEFCONFIG := 32r2el_defconfig
+KBUILD_DTBS      := dtbs
 
 #
 # Select the object file format to substitute into the linker script.
@@ -384,7 +385,7 @@ quiet_cmd_64 = OBJCOPY $@
 vmlinux.64: vmlinux
 	$(call cmd,64)
 
-all:	$(all-y)
+all:	$(all-y) $(KBUILD_DTBS)
 
 # boot
 $(boot-y): $(vmlinux-32) FORCE

