Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900721AA410
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506225AbgDONRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:17:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43705 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506236AbgDONQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:16:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id F2DBA5C012E;
        Wed, 15 Apr 2020 09:16:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 09:16:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=71Uz3I
        CYaRVCsN5B4GFC8BIHz9EqhKmB5EQqi3Oy+6k=; b=KBfqe0nC5kDVNXnoKMgBM0
        RCQuJtboN0NIDa4oxklJoaszIt1ID+87FxCtzGfBH7Rt7/MHIt+ohTpLQQj1B8qm
        0lsE5FgPNP/DW+nsNzOZoJD5bU91IOA6LJ5vDR5OUfMFkT6Nm5mPpMVy7Nkpz6Jj
        FR1dOkgS3WgoE89QNjWqHGpVAMeUZu/mQqb9b5+/G0RviXufmomby6erxPiVn8Ya
        b/eVnk61PtYZ5McjKQwxRXy9Dg9iL9pLUIsUaCXTtKuXNu3w3EqTsw3pNxFPh5hi
        g4BODT1jjpfq7352qb4M7DnZVEJLQETd0qszIGcAIZ0GmOLGiwi9lIXKp6ThGokw
        ==
X-ME-Sender: <xms:OAmXXk1ht02SCt68Xa3wBpUSGXIRpfTtTWVeg-qbX4XiCK2eT-XLPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhlohifrdhssgenucfkphepkeefrd
    ekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OAmXXjWRoPLwHLo4JFAjfhikEmJ7m8EU_mmLDDi2KmRkO5vggqaGlQ>
    <xmx:OAmXXn5eWiVPAk83sBbNO-i9-ebvZ7drTYZ71A3oDGZl3vn-9oiioA>
    <xmx:OAmXXiJ5hocbunhHy3lJAHWKHdWINVELKzxnADkaQv6cwRQjh4_nEg>
    <xmx:OAmXXvmhNGMDsrN71J6ZoGYqdMMnLwsB18j7F3yvkknEGwhzGlaGCw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 886E53060062;
        Wed, 15 Apr 2020 09:16:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/fsl_booke: Avoid creating duplicate tlb1 entry" failed to apply to 4.14-stable tree
To:     laurentiu.tudor@nxp.com, mpe@ellerman.id.au, oss@buserror.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 15:16:28 +0200
Message-ID: <158695658886168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa4113340ae6c2811e046f08c2bc21011d20a072 Mon Sep 17 00:00:00 2001
From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Date: Thu, 23 Jan 2020 11:19:25 +0000
Subject: [PATCH] powerpc/fsl_booke: Avoid creating duplicate tlb1 entry

In the current implementation, the call to loadcam_multi() is wrapped
between switch_to_as1() and restore_to_as0() calls so, when it tries
to create its own temporary AS=1 TLB1 entry, it ends up duplicating
the existing one created by switch_to_as1(). Add a check to skip
creating the temporary entry if already running in AS=1.

Fixes: d9e1831a4202 ("powerpc/85xx: Load all early TLB entries at once")
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Acked-by: Scott Wood <oss@buserror.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200123111914.2565-1-laurentiu.tudor@nxp.com

diff --git a/arch/powerpc/mm/nohash/tlb_low.S b/arch/powerpc/mm/nohash/tlb_low.S
index 2ca407cedbe7..eaeee402f96e 100644
--- a/arch/powerpc/mm/nohash/tlb_low.S
+++ b/arch/powerpc/mm/nohash/tlb_low.S
@@ -397,7 +397,7 @@ _GLOBAL(set_context)
  * extern void loadcam_entry(unsigned int index)
  *
  * Load TLBCAM[index] entry in to the L2 CAM MMU
- * Must preserve r7, r8, r9, and r10
+ * Must preserve r7, r8, r9, r10 and r11
  */
 _GLOBAL(loadcam_entry)
 	mflr	r5
@@ -433,6 +433,10 @@ END_MMU_FTR_SECTION_IFSET(MMU_FTR_BIG_PHYS)
  */
 _GLOBAL(loadcam_multi)
 	mflr	r8
+	/* Don't switch to AS=1 if already there */
+	mfmsr	r11
+	andi.	r11,r11,MSR_IS
+	bne	10f
 
 	/*
 	 * Set up temporary TLB entry that is the same as what we're
@@ -458,6 +462,7 @@ _GLOBAL(loadcam_multi)
 	mtmsr	r6
 	isync
 
+10:
 	mr	r9,r3
 	add	r10,r3,r4
 2:	bl	loadcam_entry
@@ -466,6 +471,10 @@ _GLOBAL(loadcam_multi)
 	mr	r3,r9
 	blt	2b
 
+	/* Don't return to AS=0 if we were in AS=1 at function start */
+	andi.	r11,r11,MSR_IS
+	bne	3f
+
 	/* Return to AS=0 and clear the temporary entry */
 	mfmsr	r6
 	rlwinm.	r6,r6,0,~(MSR_IS|MSR_DS)
@@ -481,6 +490,7 @@ _GLOBAL(loadcam_multi)
 	tlbwe
 	isync
 
+3:
 	mtlr	r8
 	blr
 #endif

