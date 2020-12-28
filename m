Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603D92E356C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgL1JY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:24:59 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:59159 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:24:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 514C47C8;
        Mon, 28 Dec 2020 04:24:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=addXF0
        NJGlJcQnfnPrKQTOkz4phm4H8DCGNg0awMTmE=; b=gOzaxZqHJH4Mvl2htzl2de
        nOT4bdMHnbjLsIMPavUeupShX1QULACBaTDWr+lAdnZiThSV3+v89eZnM2Y30jQy
        hQpIa+cOxFLpmVqCkqb/yL7GPwgM/MWmsPb3ZUjzrKuKtnUQFvn1aE/juBdDNmP4
        k1VYD55VlKVQ8MyUYaxaRgo1PjB/5AfAs6ggyqeeKsN10sEbbbDqhotNhUzKApGG
        EhRLEVwfhmTwvKY1KN030QbnoLZF2nkSj8ZIRt0+aetvm4LNxWz1WBH/pzhinGd7
        EjV4bRJ8F4iaU6+yIsKjqppeb1TO69yan2HsIIhtucMVeTIbtRquo5tVxoOh3iNg
        ==
X-ME-Sender: <xms:PKTpX2MR8xRi5MNmKL8Zc8NF7UXOcCB_4ARoH27L9Tz_mcwh85EtHg>
    <xme:PKTpX091V3bL406d0lnmJx_IfTNoYgJ8T97U24Y5r2gewZzQrR1ZHGRd3hCtApLBC
    _a10JhhTcj4fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PKTpX9RE1pSUPOV06iL5FlmrZD-Us5nX9MtD95au9kLHbBqGvk5y0A>
    <xmx:PKTpX2syZXG_-zGdTFEQfviUaQbdXcrODLPuZqR_QZ-_I2EQCu7GjA>
    <xmx:PKTpX-ddSrT51s0h_qa7CIZV8WFyULxh10ysNezxnS4c18yaYUg-Yg>
    <xmx:PKTpX_qgFjaI8M93q-fkRXNOHgBwAc2g99jCxjrUd3OkEH9xzn74sl0mdd4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BD9B108005C;
        Mon, 28 Dec 2020 04:24:12 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc: Fix incorrect stw{, ux, u, x} instructions in" failed to apply to 4.9-stable tree
To:     mathieu.desnoyers@efficios.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, segher@kernel.crashing.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:25:27 +0100
Message-ID: <160914752718365@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From d85be8a49e733dcd23674aa6202870d54bf5600d Mon Sep 17 00:00:00 2001
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Thu, 22 Oct 2020 09:29:20 +0000
Subject: [PATCH] powerpc: Fix incorrect stw{, ux, u, x} instructions in
 __set_pte_at

The placeholder for instruction selection should use the second
argument's operand, which is %1, not %0. This could generate incorrect
assembly code if the memory addressing of operand %0 is a different
form from that of operand %1.

Also remove the %Un placeholder because having %Un placeholders
for two operands which are based on the same local var (ptep) doesn't
make much sense. By the way, it doesn't change the current behaviour
because "<>" constraint is missing for the associated "=m".

[chleroy: revised commit log iaw segher's comments and removed %U0]

Fixes: 9bf2b5cdc5fe ("powerpc: Fixes for CONFIG_PTE_64BIT for SMP support")
Cc: <stable@vger.kernel.org> # v2.6.28+
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/96354bd77977a6a933fe9020da57629007fdb920.1603358942.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/include/asm/book3s/32/pgtable.h b/arch/powerpc/include/asm/book3s/32/pgtable.h
index 36443cda8dcf..41d8bc6db303 100644
--- a/arch/powerpc/include/asm/book3s/32/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -522,9 +522,9 @@ static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 	if (pte_val(*ptep) & _PAGE_HASHPTE)
 		flush_hash_entry(mm, ptep, addr);
 	__asm__ __volatile__("\
-		stw%U0%X0 %2,%0\n\
+		stw%X0 %2,%0\n\
 		eieio\n\
-		stw%U0%X0 %L2,%1"
+		stw%X1 %L2,%1"
 	: "=m" (*ptep), "=m" (*((unsigned char *)ptep+4))
 	: "r" (pte) : "memory");
 
diff --git a/arch/powerpc/include/asm/nohash/pgtable.h b/arch/powerpc/include/asm/nohash/pgtable.h
index 6277e7596ae5..ac75f4ab0dba 100644
--- a/arch/powerpc/include/asm/nohash/pgtable.h
+++ b/arch/powerpc/include/asm/nohash/pgtable.h
@@ -192,9 +192,9 @@ static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 	 */
 	if (IS_ENABLED(CONFIG_PPC32) && IS_ENABLED(CONFIG_PTE_64BIT) && !percpu) {
 		__asm__ __volatile__("\
-			stw%U0%X0 %2,%0\n\
+			stw%X0 %2,%0\n\
 			eieio\n\
-			stw%U0%X0 %L2,%1"
+			stw%X1 %L2,%1"
 		: "=m" (*ptep), "=m" (*((unsigned char *)ptep+4))
 		: "r" (pte) : "memory");
 		return;

