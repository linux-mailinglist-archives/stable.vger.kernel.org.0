Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C1B2AB478
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgKIKI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:08:58 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52489 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729208AbgKIKI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:08:58 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C504511F1;
        Mon,  9 Nov 2020 05:08:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:08:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=e9nIbC
        qzo1CK+fGW/LTOQazNt8s2WNAkzWy5CvADnPM=; b=NrXBcsytt3oIuQvZOAgZPX
        GvKBaK2U++jaz7soYmOM4LNEIJdURh2tQw5eBquARSJ+Zmu2Au9a7ljSMlnA8uU0
        fr1iGcBuEAKzLJFqxzF0XXA7ukPosqSUCZ8BjcEso49uWvQ+U8ND8ha1cWv9sE8W
        8vTsEHuSehzfWpzxDWPIlMMbitSE946HJ/qoDEBXOlmdfepeIO+6PEojsGaQvuik
        MFQhTddzi+Zm2A+YFBXV/9GP1ZJTZdx/bNMulREwbW7g8nWl2Uai4RqoVds1Xy8p
        UmSqI87f4Y7Wm4ENdYe21VElXS1xY31eoS7x8P2R47AD2seMBaCGyE1s4H9x61wQ
        ==
X-ME-Sender: <xms:NxWpX_OdKORTPsZx3lpVk1PpNXBzbLOX-OkaSosskkuBx1mFpK__4Q>
    <xme:NxWpX5-uLUFWxPf3QdtSNMuwXwqh2J6RZDhso45YI49Bd7xxCbNA0BPBv8va5UY8D
    dSHV_SDQaZpVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleevlefhtdeuvdetvdehhfdtkefhleevieeuiefftd
    ehtdetveevteffuedvffegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpfedvrdhs
    sgenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NxWpX-SLSp-515bXev_5lEqAWkEd6d3o6rzcfE99yUHlCBeFzG7F7w>
    <xmx:NxWpXzvUf78oxnlakQTW8hUN99tNRZUTikk_nfH13h6byFBB75r7lg>
    <xmx:NxWpX3cjwm6VjX1hPv8BvNttgPLXQ62nXKQ1T0PSK5KUZV1jSbQIGw>
    <xmx:OBWpX3nBv9FdB6fJII8irzO236UcHOa7brggRd_LG5YAwhFLD_w3FTmCzII>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74FA7328005A;
        Mon,  9 Nov 2020 05:08:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/603: Always fault when _PAGE_ACCESSED is not set" failed to apply to 5.9-stable tree
To:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 11:09:56 +0100
Message-ID: <1604916596142143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 11522448e641e8f1690c9db06e01985e8e19b401 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Sat, 10 Oct 2020 15:14:30 +0000
Subject: [PATCH] powerpc/603: Always fault when _PAGE_ACCESSED is not set

The kernel expects pte_young() to work regardless of CONFIG_SWAP.

Make sure a minor fault is taken to set _PAGE_ACCESSED when it
is not already set, regardless of the selection of CONFIG_SWAP.

Fixes: 84de6ab0e904 ("powerpc/603: don't handle PAGE_ACCESSED in TLB miss handlers.")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a44367744de54e2315b2f1a8cbbd7f88488072e0.1602342806.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index 5eb9eedac920..2aa16d5368e1 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -457,11 +457,7 @@ InstructionTLBMiss:
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
-#else
-	li	r1,_PAGE_PRESENT | _PAGE_EXEC
-#endif
 #if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC)
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
@@ -523,11 +519,7 @@ DataLoadTLBMiss:
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1, _PAGE_PRESENT | _PAGE_ACCESSED
-#else
-	li	r1, _PAGE_PRESENT
-#endif
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
@@ -603,11 +595,7 @@ DataStoreTLBMiss:
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SPRG_PGDIR
-#ifdef CONFIG_SWAP
 	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT | _PAGE_ACCESSED
-#else
-	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT
-#endif
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */

