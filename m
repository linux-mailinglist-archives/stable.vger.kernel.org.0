Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE23337B34
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCKRnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:43:33 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:35439 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229663AbhCKRnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:43:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 858071940F27;
        Thu, 11 Mar 2021 12:43:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 12:43:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B4MXFv
        IPZmCjre/Sapen3Sygk5DVEZKygfzqYQ26o1M=; b=OHlhFPF6AiszgzL2ev8k1q
        h/mPJ/HRwyQ7K07IhV7jw5759ous/a5kuxBU7JWEHerJKP5UKIdbI/oFNny6lWh+
        n2e/S2B430kS1a5dr/D9RKdvLWlhugSK/yAzwqPpLGDIPqiPYgWGaIZFVthyTADf
        +jIWzxei+Y2nSe++wfogXD9ieatYl6VbQl/mvganiWTRilRL8F4iMAjgIMRpfA1n
        GRtPygFyu0177JBlMl9eVVaULn2fOAnUbciB3s+cM1mahdgPdsAaW3+8OsJRTZB3
        rUt/MR15ky8DwwvjgbaLRJFcNyHfbM5A8Pmpw7F/ziQUU0jKJYod9kreOM32NEuA
        ==
X-ME-Sender: <xms:sFZKYNCm1RsvX6i3G9gqK-vP8D90IeWmnLrtywEN3zVtOh6KNYv9uw>
    <xme:sFZKYLgCjT2C6tF2MLBSCBhJC_4J5CUnDKknRbLDKwBJb6V54cd5m6JdmwiJN0R9r
    WBZVMnu0JZRaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelveelhfdtuedvtedvhefhtdekhfelveeiueeiff
    dthedtteevveetffeuvdffgeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdefvddr
    shgsnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sFZKYInQe-6lTyPsBYlf52uzldyO8TFliSCx9bEv6udbJNw9gehkQw>
    <xmx:sFZKYHxMQhkG9Dt80sRhN77HJS6U0v7_kYU9qe6o_ULI6eMEXWANmg>
    <xmx:sFZKYCS9hZiZ0TC6NMi1wpICiqqdeG11jziJyp1kbteWNlzblV52ow>
    <xmx:sFZKYFLrT5wgOOUObdSBv0d0ZuT3FLW-FFWAzFVBfP7auQBO2o3DXg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21B5624005C;
        Thu, 11 Mar 2021 12:43:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/603: Fix protection of user pages mapped with" failed to apply to 5.4-stable tree
To:     christophe.leroy@csgroup.eu, christoph.plattner@thalesgroup.com,
        mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 18:43:02 +0100
Message-ID: <161548458214676@kroah.com>
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

From c119565a15a628efdfa51352f9f6c5186e506a1c Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Mon, 1 Feb 2021 06:29:50 +0000
Subject: [PATCH] powerpc/603: Fix protection of user pages mapped with
 PROT_NONE

On book3s/32, page protection is defined by the PP bits in the PTE
which provide the following protection depending on the access
keys defined in the matching segment register:
- PP 00 means RW with key 0 and N/A with key 1.
- PP 01 means RW with key 0 and RO with key 1.
- PP 10 means RW with both key 0 and key 1.
- PP 11 means RO with both key 0 and key 1.

Since the implementation of kernel userspace access protection,
PP bits have been set as follows:
- PP00 for pages without _PAGE_USER
- PP01 for pages with _PAGE_USER and _PAGE_RW
- PP11 for pages with _PAGE_USER and without _PAGE_RW

For kernelspace segments, kernel accesses are performed with key 0
and user accesses are performed with key 1. As PP00 is used for
non _PAGE_USER pages, user can't access kernel pages not flagged
_PAGE_USER while kernel can.

For userspace segments, both kernel and user accesses are performed
with key 0, therefore pages not flagged _PAGE_USER are still
accessible to the user.

This shouldn't be an issue, because userspace is expected to be
accessible to the user. But unlike most other architectures, powerpc
implements PROT_NONE protection by removing _PAGE_USER flag instead of
flagging the page as not valid. This means that pages in userspace
that are not flagged _PAGE_USER shall remain inaccessible.

To get the expected behaviour, just mimic other architectures in the
TLB miss handler by checking _PAGE_USER permission on userspace
accesses as if it was the _PAGE_PRESENT bit.

Note that this problem only is only for 603 cores. The 604+ have
an hash table, and hash_page() function already implement the
verification of _PAGE_USER permission on userspace pages.

Fixes: f342adca3afc ("powerpc/32s: Prepare Kernel Userspace Access Protection")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: Christoph Plattner <christoph.plattner@thalesgroup.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/4a0c6e3bb8f0c162457bf54d9bc6fd8d7b55129f.1612160907.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index 727fdab557c9..565e84e20a72 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -457,11 +457,12 @@ InstructionTLBMiss:
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SDR1
-	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
+	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC | _PAGE_USER
 	rlwinm	r2, r2, 28, 0xfffff000
 #ifdef CONFIG_MODULES
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
+	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
 #endif
 112:	rlwimi	r2,r3,12,20,29		/* insert top 10 bits of address */
@@ -520,10 +521,11 @@ DataLoadTLBMiss:
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SDR1
-	li	r1, _PAGE_PRESENT | _PAGE_ACCESSED
+	li	r1, _PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_USER
 	rlwinm	r2, r2, 28, 0xfffff000
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
+	li	r1, _PAGE_PRESENT | _PAGE_ACCESSED
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
 112:	rlwimi	r2,r3,12,20,29		/* insert top 10 bits of address */
 	lwz	r2,0(r2)		/* get pmd entry */
@@ -597,10 +599,11 @@ DataStoreTLBMiss:
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 	mfspr	r2, SPRN_SDR1
-	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT | _PAGE_ACCESSED
+	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_USER
 	rlwinm	r2, r2, 28, 0xfffff000
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
+	li	r1, _PAGE_RW | _PAGE_DIRTY | _PAGE_PRESENT | _PAGE_ACCESSED
 	addi	r2, r2, (swapper_pg_dir - PAGE_OFFSET)@l	/* kernel page table */
 112:	rlwimi	r2,r3,12,20,29		/* insert top 10 bits of address */
 	lwz	r2,0(r2)		/* get pmd entry */

