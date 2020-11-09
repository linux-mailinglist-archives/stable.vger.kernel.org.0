Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070BC2AB479
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgKIKJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:09:05 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:47697 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726176AbgKIKJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:09:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B153F1289;
        Mon,  9 Nov 2020 05:09:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 Nov 2020 05:09:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hypBDI
        Bz27OOyzvaZKIM8mExR2vogU9M3vfqJoyouIw=; b=Jw+pK0pxBAytgu70IxI2jo
        pnDEhq0iguT4FjY5mfzhbhtg8PDZlTA3Bp2lT0iQR4Wm16cV3BkzWSDAn2Z/tBW+
        fqWYf9UwKsRnSguP42BVsD8uAU/SsQSitfL3wsnuxgACq496eepQ5zUpE+1Jc/d6
        mbqgHSsxR2lWS8mfew8M7psdyr5jsuEjeXK/N0vwYNgKxEssPUEjC5ja/3Gr4T2l
        4EPu21J/B8LImP/3s48toouOKQILG2tZKqLBM2mKAmlz+BGWA5+CTrgPpFTrybxI
        qnLgNrMIMuH5Xm2ovmvrzmzGqBLJTm2IFKJ1pjWZ2m1rbP4PbYgKAf6sNQ6kdrAg
        ==
X-ME-Sender: <xms:QBWpX9JcB_9_kk-DPr50H-YQpSBPj3UPr4aiyxkh6WItLNmy44qSPg>
    <xme:QBWpX5JNFSlMQXwSZI4Va6cpFloPCJ0LBE4YMRNEm718nJmJWg12CuAoZOOaAkjVO
    S9xluHsItKK7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudduhedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleevlefhtdeuvdetvdehhfdtkefhleevieeuiefftd
    ehtdetveevteffuedvffegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpfedvrdhs
    sgenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QBWpX1uLu7fVCaRYNKwjk8pWo37YXZCMoyacgoqgfbsC5IcIk7PhQA>
    <xmx:QBWpX-aD1WD9CDrUJhZSZYaf5hCtwyeWR8sq6w5VDTDbqniZZSJDqQ>
    <xmx:QBWpX0aRtVf2u579mlduNco9gJKlFelDOlSxkj-JGJKPDDdkvmquMA>
    <xmx:QBWpX9CYLvzqfgHEJD_opSTpnPmIx1ioaPn_cTK_1qDdudfNuM2NLzPEcE0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EBCBE3063082;
        Mon,  9 Nov 2020 05:09:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/603: Always fault when _PAGE_ACCESSED is not set" failed to apply to 5.4-stable tree
To:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Nov 2020 11:09:56 +0100
Message-ID: <1604916596189172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

