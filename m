Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE735240582
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 13:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHJL6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 07:58:03 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60177 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726146AbgHJL6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 07:58:03 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id EB3E312E9;
        Mon, 10 Aug 2020 07:58:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 Aug 2020 07:58:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/c23sA
        nHr49zsmCICANNkGNKkZEPxFrWD2YX+plcLG8=; b=tqdZsbISWIj5HITDqTz1Hs
        Y1psSIQ0CF821yFiVwvgQiID9qOp7yoH5OLD4LBFOc77N/6OlKLqJd+1M5338lj3
        HAytkB5HCrtneiFESzw45NhP/qFAb0EpRw2XbONIN07phSasMcDVFhnKoVDaxq8V
        dRG75ZeFAlMD8eg4+TVz3qLuLQIF5Ek2H/vE1vzB70jWS2Rw6SugVkhWsVpt7jh2
        YGfGIrFWugCEeELMxQBRjhjQKCGQUHiZO9gDna/AdMIAx4yzRTplJMZXH+YVLl+n
        ItBs4rM9AB9Mqy78IqbRawccDSnE+a6FNYW/H/virUiXDB73QKcMtmdmcVa5hhDw
        ==
X-ME-Sender: <xms:STYxX1KuNnCK2hQDDcvFHRVel9dHKXAFT6rlp9TP26h74uAhRsG1WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeekgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:STYxXxIBdP8LswiSkBn6T7Zxp7nH4feGB0zN4Q1FfeLPDibBjOBRJg>
    <xmx:STYxX9v4Uo3BNBnEaM4lx4qeUbVedovuPQmA5MvU9ltpeWJ7j8JC7Q>
    <xmx:STYxX2YjsFBJKkCOlFzEsMsOJlFk5I6dDmajXfVAnLaTwTLf9AIgDw>
    <xmx:STYxX1A2NuWz5S1YCXC8gtsvPw45bf9DmefCSVvoGTx5TuTxf_EHN1-LAVA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D095328005E;
        Mon, 10 Aug 2020 07:58:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/kasan: Fix shadow pages allocation failure" failed to apply to 5.4-stable tree
To:     christophe.leroy@csgroup.eu, erhard_f@mailbox.org,
        mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Aug 2020 13:58:04 +0200
Message-ID: <159706068422137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 41ea93cf7ba4e0f0cc46ebfdda8b6ff27c67bc91 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Thu, 2 Jul 2020 11:52:03 +0000
Subject: [PATCH] powerpc/kasan: Fix shadow pages allocation failure

Doing kasan pages allocation in MMU_init is too early, kernel doesn't
have access yet to the entire memory space and memblock_alloc() fails
when the kernel is a bit big.

Do it from kasan_init() instead.

Fixes: 2edb16efc899 ("powerpc/32: Add KASAN support")
Fixes: d2a91cef9bbd ("powerpc/kasan: Fix shadow pages allocation failure")
Cc: stable@vger.kernel.org
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=208181
Link: https://lore.kernel.org/r/63048fcea8a1c02f75429ba3152f80f7853f87fc.1593690707.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/mm/kasan/kasan_init_32.c b/arch/powerpc/mm/kasan/kasan_init_32.c
index 4813c6d50889..019b0c0bbbf3 100644
--- a/arch/powerpc/mm/kasan/kasan_init_32.c
+++ b/arch/powerpc/mm/kasan/kasan_init_32.c
@@ -120,11 +120,24 @@ static void __init kasan_unmap_early_shadow_vmalloc(void)
 void __init kasan_mmu_init(void)
 {
 	int ret;
+
+	if (early_mmu_has_feature(MMU_FTR_HPTE_TABLE) ||
+	    IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
+		ret = kasan_init_shadow_page_tables(KASAN_SHADOW_START, KASAN_SHADOW_END);
+
+		if (ret)
+			panic("kasan: kasan_init_shadow_page_tables() failed");
+	}
+}
+
+void __init kasan_init(void)
+{
 	struct memblock_region *reg;
 
 	for_each_memblock(memory, reg) {
 		phys_addr_t base = reg->base;
 		phys_addr_t top = min(base + reg->size, total_lowmem);
+		int ret;
 
 		if (base >= top)
 			continue;
@@ -134,18 +147,6 @@ void __init kasan_mmu_init(void)
 			panic("kasan: kasan_init_region() failed");
 	}
 
-	if (early_mmu_has_feature(MMU_FTR_HPTE_TABLE) ||
-	    IS_ENABLED(CONFIG_KASAN_VMALLOC)) {
-		ret = kasan_init_shadow_page_tables(KASAN_SHADOW_START, KASAN_SHADOW_END);
-
-		if (ret)
-			panic("kasan: kasan_init_shadow_page_tables() failed");
-	}
-
-}
-
-void __init kasan_init(void)
-{
 	kasan_remap_early_shadow_ro();
 
 	clear_page(kasan_early_shadow_page);

