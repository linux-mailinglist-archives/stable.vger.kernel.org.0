Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5F861EA0
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 14:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbfGHMmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 08:42:11 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36315 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbfGHMmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 08:42:11 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 994552102F;
        Mon,  8 Jul 2019 08:42:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 08 Jul 2019 08:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BOOKpD
        SUQ3tV6cfVBiSVzblm4xGfa6zf4eFKuGdgSv0=; b=ixs9GVuvKmoqnUChiflKf/
        CAHc7KYJgT8z/u9ztUkYbpCasyMcq/kY3m3irr6w+wouyv+dGyKAl3Ng+J9iWCHi
        Tt1nPeVlGn5PlpQHvUh2bp8nhX6GBlmpk2oXB3bk2SJGW3SamDku3UYr6x9H8Mhu
        Y1+dfkTa3zH4Efh7mRUSFr1Jp8GvMN1nMaHFbfVtsbNsJJs0EfdwwnjM4XCAyXQ0
        4W2XN0HxPgS3tpb//lWcogkc/Gl6uNLokzxW5gI52UmLAcW29zFlwfO4aesookK7
        mk3zBbVLNgeBdqQJzbZWDANWjmnQkRPKH2tzLlJwPRbOxDhfWvNSum0e+AzBCH6A
        ==
X-ME-Sender: <xms:IjojXWKajQ4f6KZDXRIeU0EkcMRMjkDmhgHZIjpHq1hrJga6QGL4wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:IjojXd2J0UJMXn3-M_LdbMbTfnRG5xcUzkc-sVBxPV8J1g9A_83pYw>
    <xmx:IjojXSXHSNXvS8DuB51ex72v--2uiGKaa6S8OAL6Lw5Uck8tTw0Vzw>
    <xmx:IjojXXNMUtauh7IapHcSpXPoKuIROxc1aZoj4QquHx_Oi1mQe-6lOA>
    <xmx:IjojXajGhk_1B7Gorj0izp5ecOU2suH0jzrlXdyOiq0OK4fiSvP8Hg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A191380074;
        Mon,  8 Jul 2019 08:42:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] MIPS: have "plain" make calls build dtbs for selected" failed to apply to 4.9-stable tree
To:     Cedric_Hombourger@mentor.com, paul.burton@mips.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jul 2019 14:42:00 +0200
Message-ID: <1562589720119108@kroah.com>
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

