Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389791F9893
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbgFONaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:30:07 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:59355 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730135AbgFONaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:30:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D0EDE6A3;
        Mon, 15 Jun 2020 09:30:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cqi6yM
        Fjd7MPLCh/B0KyHHFn1WXbTtlRloJfojGwKLE=; b=WArD+sofni7IDqeNDkzhLt
        7/gI9XMGCwy5QiZJ7NuAl2LJfNXoFp3j9fsqgCHOJiv378bGptaXYsfBp9sJ5Nzc
        KsBbmzuEd9OaWob5u16mvtRhkrV9F3gKPGmiGRfMrPBaO96+3VxwWCV2UXGe/mrT
        h2Ml7Qn27fSNOSlRneMG5wC8KRZIem0F+2aaFD4PJFoLM+89ZPYCC95OZYHnHSDj
        rl91sFUco4H8sPjjJ3UBhSGoO/ZqIw1hNoZpUkViilvvRycxGkegN4wl41Sz3jYg
        tvJBZmDryxpFc4ZwEK7vNmscQ2+9wMkocIkXjV0s5OkmaqruQ21P/5FqNZje/Tmg
        ==
X-ME-Sender: <xms:3XfnXgj_qbjnI__H-uf_MCba9C4jpidDXvGUwZbXOr0QGoQ5wC-QVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:3XfnXpDi2K5UHpZdnDXHpl-nupI5B5xu1Wv-iOQIfI2i4hwSifIikg>
    <xmx:3XfnXoEvBgJHnqo6c4aQaJ7mLwnf1GoCrhxV81AQxu5hnMT0gUs7QA>
    <xmx:3XfnXhSMH1kgA2nRXBB8sWM8NA_Ty8uncaDHKVL7pQ2H6GYySPsLBQ>
    <xmx:3XfnXs9CyMPTMGKZ6qGkYiYO-pijMh6bvW8vhJTgUEQs5q8kXzWjq4uDGwI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C68C83060FE7;
        Mon, 15 Jun 2020 09:30:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: only do L1TF workaround on affected processors" failed to apply to 4.14-stable tree
To:     pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:29:49 +0200
Message-ID: <159222778921650@kroah.com>
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

From d43e2675e96fc6ae1a633b6a69d296394448cc32 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 19 May 2020 05:34:41 -0400
Subject: [PATCH] KVM: x86: only do L1TF workaround on affected processors

KVM stores the gfn in MMIO SPTEs as a caching optimization.  These are split
in two parts, as in "[high 11111 low]", to thwart any attempt to use these bits
in an L1TF attack.  This works as long as there are 5 free bits between
MAXPHYADDR and bit 50 (inclusive), leaving bit 51 free so that the MMIO
access triggers a reserved-bit-set page fault.

The bit positions however were computed wrongly for AMD processors that have
encryption support.  In this case, x86_phys_bits is reduced (for example
from 48 to 43, to account for the C bit at position 47 and four bits used
internally to store the SEV ASID and other stuff) while x86_cache_bits in
would remain set to 48, and _all_ bits between the reduced MAXPHYADDR
and bit 51 are set.  Then low_phys_bits would also cover some of the
bits that are set in the shadow_mmio_value, terribly confusing the gfn
caching mechanism.

To fix this, avoid splitting gfns as long as the processor does not have
the L1TF bug (which includes all AMD processors).  When there is no
splitting, low_phys_bits can be set to the reduced MAXPHYADDR removing
the overlap.  This fixes "npt=0" operation on EPYC processors.

Thanks to Maxim Levitsky for bisecting this bug.

Cc: stable@vger.kernel.org
Fixes: 52918ed5fcf0 ("KVM: SVM: Override default MMIO mask if memory encryption is enabled")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8071952e9cf2..86619631ff6a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -335,6 +335,8 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask)
 {
 	BUG_ON((u64)(unsigned)access_mask != access_mask);
 	BUG_ON((mmio_mask & mmio_value) != mmio_value);
+	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << shadow_nonpresent_or_rsvd_mask_len));
+	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
 	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
 	shadow_mmio_mask = mmio_mask | SPTE_SPECIAL_MASK;
 	shadow_mmio_access_mask = access_mask;
@@ -583,16 +585,15 @@ static void kvm_mmu_reset_all_pte_masks(void)
 	 * the most significant bits of legal physical address space.
 	 */
 	shadow_nonpresent_or_rsvd_mask = 0;
-	low_phys_bits = boot_cpu_data.x86_cache_bits;
-	if (boot_cpu_data.x86_cache_bits <
-	    52 - shadow_nonpresent_or_rsvd_mask_len) {
+	low_phys_bits = boot_cpu_data.x86_phys_bits;
+	if (boot_cpu_has_bug(X86_BUG_L1TF) &&
+	    !WARN_ON_ONCE(boot_cpu_data.x86_cache_bits >=
+			  52 - shadow_nonpresent_or_rsvd_mask_len)) {
+		low_phys_bits = boot_cpu_data.x86_cache_bits
+			- shadow_nonpresent_or_rsvd_mask_len;
 		shadow_nonpresent_or_rsvd_mask =
-			rsvd_bits(boot_cpu_data.x86_cache_bits -
-				  shadow_nonpresent_or_rsvd_mask_len,
-				  boot_cpu_data.x86_cache_bits - 1);
-		low_phys_bits -= shadow_nonpresent_or_rsvd_mask_len;
-	} else
-		WARN_ON_ONCE(boot_cpu_has_bug(X86_BUG_L1TF));
+			rsvd_bits(low_phys_bits, boot_cpu_data.x86_cache_bits - 1);
+	}
 
 	shadow_nonpresent_or_rsvd_lower_gfn_mask =
 		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);

