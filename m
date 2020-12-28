Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4F42E356D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgL1JZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:25:09 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:50181 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:25:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 925817DB;
        Mon, 28 Dec 2020 04:24:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:24:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KOSzft
        GQRQeAuTillpyx/VRbC0s8JUc7+y6LiqA6HyU=; b=gZPZVQV1H96bmbVCWAjszR
        a0xKiXhqM5OunpA5Wy4umUHRLQ3T6TkqaVvyQ8PMvtRa52FFO8uIcgXkWEGxDxdb
        mPignQGblOk/En4bzWXcXOxpcec5cQhV7f4xXAWlfE+hnob5Sj/zqUG8mb8pFCoy
        omgMLK+8ukATysh0VMoJEWoMgGok5TzS2y+MANkmE2LAmy+GgLACgMPBkyaFlpcS
        HpDchK3q1XdKyWEAlqmrVQZ1OeJOURtHVsxP5Abr0ltoxhWjkC4aefK9j53I8y7A
        RaFOS3/v3GdMIcAhNv5WbnCUsdAeOqKd6UrnU12Qag/jl6nWMjBOE3m6wyhlIRQQ
        ==
X-ME-Sender: <xms:MqTpX8URKu2ICjS-aI0Xi0Ekj5szG931HJqVOjuVn3iwyY3QrkF5Yg>
    <xme:MqTpXwmrckaHwy1T-sUG9c1Y7fqvBTusnIuSzjJJKBHmVGrXooSYPIbXBzNXmUIzp
    KNVRqRk_Jn_sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MqTpXwZBKXZOxK2AL0FlFHNl39ljrpgdMwpemN0O6vfUM_a6AlNPyg>
    <xmx:MqTpX7V_Z8pRj_akX3DIof-YrmiGuxjf-2zNK3G9hWOommgZ7TlJkg>
    <xmx:MqTpX2nC7Rd9BhheSr-2GraGoRlzW-ZeHJugssWh01rQxJ6QrRiAsQ>
    <xmx:M6TpX7xTXc6M25eo6IdklLM9IbmJYAC45LkUnvYroqlqIpnU_v09FqQ0B7E>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 341F71080057;
        Mon, 28 Dec 2020 04:24:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc: Fix incorrect stw{, ux, u, x} instructions in" failed to apply to 4.14-stable tree
To:     mathieu.desnoyers@efficios.com, christophe.leroy@csgroup.eu,
        mpe@ellerman.id.au, segher@kernel.crashing.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:25:25 +0100
Message-ID: <160914752518658@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

