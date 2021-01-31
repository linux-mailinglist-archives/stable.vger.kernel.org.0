Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E835309D2D
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhAaOuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 09:50:09 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:33519 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230210AbhAaOnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 09:43:32 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B9B401288;
        Sun, 31 Jan 2021 09:42:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 31 Jan 2021 09:42:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=f5zlC/
        2D/5USHj1okjRgrbYDi0iMV7wIYPX5b7sfTkU=; b=MUIz+Kra85GAeNQlQJGikj
        o0HSclRkfxWcmcJByTmIxnBSJq2JYjfiZ+fp1enk16P0liwTdWl1Km+ehS8gx+Sk
        YDZmEJbFgsqil/Wz0NumzDfJIaWN+Lzg26NlBRKu1lScgfUh4J3f9RhcvFGmQqJv
        zB9vM43rQewmpfj1jADX1NVyFcRBVQzvVcSOcNOxJHGzi1CySILDlQCElQ24mD9r
        gtRxsylAYltwSL5Z1pkznr/thWJciyrBvRsBVSpLEkS7B2gSonhmyaUnnLh3BE/P
        xkJzclqIfkdZnpN8+qSuMCF34ooIWmzqdfdqigXUjuTXRmdvhlVH/V+RzksoG7+Q
        ==
X-ME-Sender: <xms:0MEWYBvUk_4oMpVH51pBv5W0RnXahKHAR0b5wmaNrLdHLG5TDTdpDg>
    <xme:0MEWYKetW3D5tw14Zm2lEftzkFwPFvttdE9qEXwscnBb1qhOO29iDm3TDTvlUAgPz
    k2-FX5iG0szxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:0MEWYExSYRQp9QUqrDbhNXNZy-YFqYW8LBBpk2U8fYtfxCAgnmQ4KQ>
    <xmx:0MEWYIO-Uyipg9FtjxeV-B1X0nRWntzbVwaafmCvjjam9jaqQ7WTAg>
    <xmx:0MEWYB-U2d8dd0K7XJ_8OhZeT6GBC3TT3gr8n48yXz62d0l0hZr2qA>
    <xmx:0MEWYOHs8VONW_maH_QZonaymGGJXa7aFBhG9zV4uo2ROON1ijXA1uRgbnI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1348D24005B;
        Sun, 31 Jan 2021 09:42:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] riscv: Fixup pfn_valid error with wrong max_mapnr" failed to apply to 5.10-stable tree
To:     guoren@linux.alibaba.com, palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 15:42:15 +0100
Message-ID: <1612104135249149@kroah.com>
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

From 336e8eb2a3cfe2285c314cd85630076da365f6c6 Mon Sep 17 00:00:00 2001
From: Guo Ren <guoren@linux.alibaba.com>
Date: Thu, 21 Jan 2021 14:31:17 +0800
Subject: [PATCH] riscv: Fixup pfn_valid error with wrong max_mapnr

The max_mapnr is the number of PFNs, not absolute PFN offset.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Fixes: d0d8aae64566 ("RISC-V: Set maximum number of mapped pages correctly")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 7cd4993f4ff2..f9f9568d689e 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -196,7 +196,7 @@ void __init setup_bootmem(void)
 	max_pfn = PFN_DOWN(dram_end);
 	max_low_pfn = max_pfn;
 	dma32_phys_limit = min(4UL * SZ_1G, (unsigned long)PFN_PHYS(max_low_pfn));
-	set_max_mapnr(max_low_pfn);
+	set_max_mapnr(max_low_pfn - ARCH_PFN_OFFSET);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	setup_initrd();

