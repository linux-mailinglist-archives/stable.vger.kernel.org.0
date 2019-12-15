Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF44F11F748
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 11:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfLOKxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 05:53:21 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:32769 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbfLOKxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 05:53:21 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DC48922278;
        Sun, 15 Dec 2019 05:53:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 05:53:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=l86Dig
        CGvinahViX9QNGIS51XhMLwGLDrxCCtZR4cqM=; b=pqE0F1wNZms3lzTvRF5hFj
        K5cDiAAHG/i+obfThFrMFwqMvtX8Q+K6bUoSaAm3sjipCX0uXZS1XfFSPUJJAIq0
        YKSGaJE3tlms2x/Tvy/xDLzCANS7poYAmaU/xYVLLxXZTRq0uw5zJ9RskUy2rqEY
        M8L3QFMXEeDU1Mrqoe0fNiNohpovVxIFy2+IFVejDYmMrybD8beYxb3GdVOHl5u6
        5XPyVrf8aZbngmBfdJDZ7/L923Y3RTAOROxxLGLJkdJJwiri+3n+qqKIsGcc6EPr
        gPqLsjfnJ/B4iqSqQRaTopQA75gdFTcVl7mv5uM7MtLrkv1qxu84SGo33kMyUNcQ
        ==
X-ME-Sender: <xms:nxD2XSj2zOK1-RHjvCEKizAAy7z75YkAFuDrg2E44nneZ_-KUl10_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:nxD2XeCkY6wq2PxrIIZFA7yw9jL2sVbkYefK0PiGLC1ox2GCGWoJTA>
    <xmx:nxD2XZEnvz2fhVDKg31XqJToSynJLM5D9JhDB0scOU5RXrBwjtXKmg>
    <xmx:nxD2Xc8xrqp2s2wHzUoTUt_ismpxKBlYXr3nXXQY4lEYkv6OC438cQ>
    <xmx:oBD2Xazr7QVJ2oeGWEgHHEZmmnoRUrjtdASNri9a2rq3Fz0Penw29A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6325D8005C;
        Sun, 15 Dec 2019 05:53:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] EDAC/altera: Use fast register IO for S10 IRQs" failed to apply to 4.19-stable tree
To:     Meng.Li@windriver.com, bp@suse.de, james.morse@arm.com,
        linux-edac@vger.kernel.org, mchehab@kernel.org,
        rrichter@marvell.com, stable@vger.kernel.org,
        thor.thayer@linux.intel.com, tony.luck@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 11:53:16 +0100
Message-ID: <1576407196157167@kroah.com>
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

From 56d9e7bd3fa0f105b6670021d167744bc50ae4fe Mon Sep 17 00:00:00 2001
From: Meng Li <Meng.Li@windriver.com>
Date: Thu, 21 Nov 2019 12:30:46 -0600
Subject: [PATCH] EDAC/altera: Use fast register IO for S10 IRQs

When an IRQ occurs, regmap_{read,write,...}() is invoked in atomic
context. Regmap must indicate register IO is fast so that a spinlock is
used instead of a mutex to avoid sleeping in atomic context:

  lock_acquire
  __mutex_lock
  mutex_lock_nested
  regmap_lock_mutex
  regmap_write
  a10_eccmgr_irq_unmask
  unmask_irq.part.0
  irq_enable
  __irq_startup
  irq_startup
  __setup_irq
  request_threaded_irq
  devm_request_threaded_irq
  altr_sdram_probe

Mark it so.

 [ bp: Massage. ]

Fixes: 3dab6bd52687 ("EDAC, altera: Add support for Stratix10 SDRAM EDAC")
Reported-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Meng Li <Meng.Li@windriver.com>
Signed-off-by: Thor Thayer <thor.thayer@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: James Morse <james.morse@arm.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Robert Richter <rrichter@marvell.com>
Cc: stable <stable@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/1574361048-17572-2-git-send-email-thor.thayer@linux.intel.com

diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
index fbda4b876afd..0be3d1b17f03 100644
--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -560,6 +560,7 @@ static const struct regmap_config s10_sdram_regmap_cfg = {
 	.reg_write = s10_protected_reg_write,
 	.use_single_read = true,
 	.use_single_write = true,
+	.fast_io = true,
 };
 
 /************** </Stratix10 EDAC Memory Controller Functions> ***********/

