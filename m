Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18164337B2E
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCKRnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:43:33 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:34669 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhCKRnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 12:43:05 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D93E61940F5B;
        Thu, 11 Mar 2021 12:43:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 12:43:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YauLvK
        BkuN9B8uVNrvHf77rsKzUXWykUnz8oVPIEC+I=; b=qMgL1DU2VNDFbcepsplYLc
        1tlzeS0h0sVddfXfk6JfnqOnjCu1fmXsUKMDwijR/2MZ63aZ3jAR/mFQYamHXEJ0
        i2PMfb1iz4b90DsMy+iyNvdFpjoXTG65jNjmI3WGqwzpJqWVewGZUXgnxm7E20C4
        ofAJfA+vorQZOghBEpACNFsUamYgd8GjEN1K16SJtGKNNtc/s+LRpcVWvGlU4n3V
        w+FYJNsg7nAQQolLrAW4IH/Ylpu47JrJaBURUPdqMRwxFoGN99JJZ29hrmDJJZT/
        fHAUNlwwoUXbU9hV2LXyD4qNXfhT9GWjY69+L+CJ8eg5gP1gnxgHtP78e1ytZHXw
        ==
X-ME-Sender: <xms:p1ZKYOCtnDuz7Ps1VaXu-wFfKbQowYhLH_d2-nNSa8yCg51XwjTX1A>
    <xme:p1ZKYCL7AYxNt9hKlIv8xJDqSEhgF_gNt-tQaMDxn0v41zGhdgjzQM9KasB7-ScKI
    IOzFD-Y3YiHXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelveelhfdtuedvtedvhefhtdekhfelveeiueeiff
    dthedtteevveetffeuvdffgeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdefvddr
    shgsnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:p1ZKYBlxohUirz2bi_Rz_LZd8trz-RKvz4TOUUpYp1GdxdgAZSDSGg>
    <xmx:p1ZKYAGmUE2qVYi2PA2y4iXsFQfZLCr63FMnst5ufszXaP2uwCsE8w>
    <xmx:p1ZKYBEYMjD0cCQ0Uf7_BZHtOdjunDaGzgwP0cRgN-f0iBlvTaA0-w>
    <xmx:qFZKYITW_bpw3-Q0n00e-Blg0xdHjE-r8K7bLBGE7zSr7J7_3xFfew>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 684CB108005F;
        Thu, 11 Mar 2021 12:43:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/603: Fix protection of user pages mapped with" failed to apply to 5.10-stable tree
To:     christophe.leroy@csgroup.eu, christoph.plattner@thalesgroup.com,
        mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 18:43:01 +0100
Message-ID: <1615484581199173@kroah.com>
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

