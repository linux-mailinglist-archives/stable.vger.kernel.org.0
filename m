Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6652C7400
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388843AbgK1Vtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:45 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:34227 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730218AbgK1SBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 13:01:51 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id DFB761943794;
        Sat, 28 Nov 2020 07:47:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 28 Nov 2020 07:47:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gCpigE
        jK/fOLcUd5DXlEf6cx0Q1UPXLkDquu9XyyGF8=; b=J0Xl9TyWuaZp95ReohtLOD
        9OUAmpyqnMiCo9X8xb2TW3/ptSXo7d0eWiiay3Xz+RZyc2rKbR6miuHzW+L8qAwG
        0k9xuKwDF5BmZWfz/nSjp2svCye2KGZtsI5Y9HdlbelVgSJaRsHbUuIlSZv/YWZX
        ZztMP7KsY88YFzZiXOL3fnKmScLgbZ9/4fcpcdVYtP5QhOvjSM9xE+0bw2bf/ZUK
        rrKYLELk0vPzcFtN0OQ3TzNJ9Fj5HQ9Op4njq3wy1KcJUQ7QPiniDAGdR/KE9ErC
        fu43Wt0XX654k8a7IKqzaWlmhLLfjBlMDmH+S1TVYXXXsWpAoBPeppMwJgeP4F2Q
        ==
X-ME-Sender: <xms:-0bCX9qjfp-39dvsqzhKqCRlTw9xkmIRmEouSVCRj9HyqQJHYab92A>
    <xme:-0bCX_q7DxE5JFmSmqIS3wiIRzeTd_CDGO9bT1_u91mHG_x31aPNMtlX5wtAXXgLR
    ZsY5mSOHqroyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehiedggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-0bCX6P9bXSubYOl_BQi8Z6SaHSRdUKS5x_kPAgA499FW04QF0PjKQ>
    <xmx:-0bCX47c3NVqkv108_mqj_TDEkACnnL4SPhsO02Okz3A7HZf6KpZ0A>
    <xmx:-0bCX85AXTC_ghxUwHOlVvYtysL41itU3wn2Tlql94F-vAeRCNimAg>
    <xmx:-0bCXxgMkmD8czTXNMibuh1Y5HT8Ivye7bh7xHcusYvo_o1Whk7e_A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3BCF33064AA7;
        Sat, 28 Nov 2020 07:47:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: pgtable: Ensure dirty bit is preserved across" failed to apply to 4.4-stable tree
To:     will@kernel.org, catalin.marinas@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 28 Nov 2020 13:49:04 +0100
Message-ID: <160656774418472@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ff1712f953e27f0b0718762ec17d0adb15c9fd0b Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Fri, 20 Nov 2020 13:57:48 +0000
Subject: [PATCH] arm64: pgtable: Ensure dirty bit is preserved across
 pte_wrprotect()

With hardware dirty bit management, calling pte_wrprotect() on a writable,
dirty PTE will lose the dirty state and return a read-only, clean entry.

Move the logic from ptep_set_wrprotect() into pte_wrprotect() to ensure that
the dirty bit is preserved for writable entries, as this is required for
soft-dirty bit management if we enable it in the future.

Cc: <stable@vger.kernel.org>
Fixes: 2f4b829c625e ("arm64: Add support for hardware updates of the access and dirty pte bits")
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20201120143557.6715-3-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 326c34677e86..5628289b9d5e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -165,13 +165,6 @@ static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
 	return pmd;
 }
 
-static inline pte_t pte_wrprotect(pte_t pte)
-{
-	pte = clear_pte_bit(pte, __pgprot(PTE_WRITE));
-	pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
-	return pte;
-}
-
 static inline pte_t pte_mkwrite(pte_t pte)
 {
 	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
@@ -197,6 +190,20 @@ static inline pte_t pte_mkdirty(pte_t pte)
 	return pte;
 }
 
+static inline pte_t pte_wrprotect(pte_t pte)
+{
+	/*
+	 * If hardware-dirty (PTE_WRITE/DBM bit set and PTE_RDONLY
+	 * clear), set the PTE_DIRTY bit.
+	 */
+	if (pte_hw_dirty(pte))
+		pte = pte_mkdirty(pte);
+
+	pte = clear_pte_bit(pte, __pgprot(PTE_WRITE));
+	pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
+	return pte;
+}
+
 static inline pte_t pte_mkold(pte_t pte)
 {
 	return clear_pte_bit(pte, __pgprot(PTE_AF));
@@ -846,12 +853,6 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addres
 	pte = READ_ONCE(*ptep);
 	do {
 		old_pte = pte;
-		/*
-		 * If hardware-dirty (PTE_WRITE/DBM bit set and PTE_RDONLY
-		 * clear), set the PTE_DIRTY bit.
-		 */
-		if (pte_hw_dirty(pte))
-			pte = pte_mkdirty(pte);
 		pte = pte_wrprotect(pte);
 		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));

