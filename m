Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F57CF3E7
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730283AbfJHHcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:32:33 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:34427 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730279AbfJHHcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:32:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8DD9E55D;
        Tue,  8 Oct 2019 03:32:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=GfAIc+
        KC8ivNlcKimmFoLmvRA5KpkjPrspMUpzn8a7A=; b=I/u/f1bx6lqZjTrRv7FYcm
        PERaQfjw0MUBV1K6TQy2Ru37x+d3BgAVLbsIBnmicxODGhoCYqSyznoy8CpImUyp
        VelfmGX+wFyQhWqasBrOOcuTeXDN+4uRD6jMKyorQ7TVLqZacNhq1833exinKWcX
        udRkVZE4Cbns7oS1bD6aGjJY4VyqqIWaq8wtxs/rr/DJLR/7fNXeN3l23EUFbbco
        tVj4Eq6ddYaNhFV3GaQiqoPwTTCq53Holta5EIUHn0uUP1QnwrrwVn+BIgmpuIoL
        fhgpccg6olUSC5FNXL7TK7Vk0S/WVhSmQDUzPOoeXz69c+pq5tAiJLj6wMUz/Z/g
        ==
X-ME-Sender: <xms:kDucXRem5EgouE0Ty0nQSJi3xtBGfhUteKDf73JovT0jpVoKFIypWg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:kDucXavsjsjQ7fqeznyhJoWqEElJiMyL9WkLJvK4kFSI2PcmfyHidg>
    <xmx:kDucXfm1QqjIZd-NbGf2a2khdhFVfuLqVXG6pVcEx8kWJQOjYOSZVg>
    <xmx:kDucXZ79AsVHI-5TpvB4ZWjpzq03RB9vFqQGnU1EZpmxF7EtPvTiQA>
    <xmx:kDucXX3XtRu8d80knRB_CDvdEXaW0S_4cKBvdhRvEdcKMqDauYmnNA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B23B48005C;
        Tue,  8 Oct 2019 03:32:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature" failed to apply to 4.19-stable tree
To:     aneesh.kumar@linux.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:32:30 +0200
Message-ID: <1570519950118156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 09ce98cacd51fcd0fa0af2f79d1e1d3192f4cbb0 Mon Sep 17 00:00:00 2001
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Date: Tue, 24 Sep 2019 09:22:52 +0530
Subject: [PATCH] powerpc/book3s64/radix: Rename CPU_FTR_P9_TLBIE_BUG feature
 flag

Rename the #define to indicate this is related to store vs tlbie
ordering issue. In the next patch, we will be adding another feature
flag that is used to handles ERAT flush vs tlbie ordering issue.

Fixes: a5d4b5891c2f ("powerpc/mm: Fixup tlbie vs store ordering issue on POWER9")
Cc: stable@vger.kernel.org # v4.16+
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190924035254.24612-2-aneesh.kumar@linux.ibm.com

diff --git a/arch/powerpc/include/asm/cputable.h b/arch/powerpc/include/asm/cputable.h
index a1ebcbc3931f..f080fba48619 100644
--- a/arch/powerpc/include/asm/cputable.h
+++ b/arch/powerpc/include/asm/cputable.h
@@ -209,7 +209,7 @@ static inline void cpu_feature_keys_init(void) { }
 #define CPU_FTR_POWER9_DD2_1		LONG_ASM_CONST(0x0000080000000000)
 #define CPU_FTR_P9_TM_HV_ASSIST		LONG_ASM_CONST(0x0000100000000000)
 #define CPU_FTR_P9_TM_XER_SO_BUG	LONG_ASM_CONST(0x0000200000000000)
-#define CPU_FTR_P9_TLBIE_BUG		LONG_ASM_CONST(0x0000400000000000)
+#define CPU_FTR_P9_TLBIE_STQ_BUG	LONG_ASM_CONST(0x0000400000000000)
 #define CPU_FTR_P9_TIDR			LONG_ASM_CONST(0x0000800000000000)
 
 #ifndef __ASSEMBLY__
@@ -457,7 +457,7 @@ static inline void cpu_feature_keys_init(void) { }
 	    CPU_FTR_CFAR | CPU_FTR_HVMODE | CPU_FTR_VMX_COPY | \
 	    CPU_FTR_DBELL | CPU_FTR_HAS_PPR | CPU_FTR_ARCH_207S | \
 	    CPU_FTR_TM_COMP | CPU_FTR_ARCH_300 | CPU_FTR_PKEY | \
-	    CPU_FTR_P9_TLBIE_BUG | CPU_FTR_P9_TIDR)
+	    CPU_FTR_P9_TLBIE_STQ_BUG | CPU_FTR_P9_TIDR)
 #define CPU_FTRS_POWER9_DD2_0 CPU_FTRS_POWER9
 #define CPU_FTRS_POWER9_DD2_1 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1)
 #define CPU_FTRS_POWER9_DD2_2 (CPU_FTRS_POWER9 | CPU_FTR_POWER9_DD2_1 | \
diff --git a/arch/powerpc/kernel/dt_cpu_ftrs.c b/arch/powerpc/kernel/dt_cpu_ftrs.c
index 5fc1b527de46..a86486390c70 100644
--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -706,14 +706,14 @@ static __init void update_tlbie_feature_flag(unsigned long pvr)
 		if ((pvr & 0xe000) == 0) {
 			/* Nimbus */
 			if ((pvr & 0xfff) < 0x203)
-				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		} else if ((pvr & 0xc000) == 0) {
 			/* Cumulus */
 			if ((pvr & 0xfff) < 0x103)
-				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+				cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		} else {
 			WARN_ONCE(1, "Unknown PVR");
-			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_BUG;
+			cur_cpu_spec->cpu_features |= CPU_FTR_P9_TLBIE_STQ_BUG;
 		}
 	}
 }
diff --git a/arch/powerpc/kvm/book3s_hv_rm_mmu.c b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
index 7186c65c61c9..cfdf232aac34 100644
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
+++ b/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -451,7 +451,7 @@ static void do_tlbies(struct kvm *kvm, unsigned long *rbvalues,
 				     "r" (rbvalues[i]), "r" (kvm->arch.lpid));
 		}
 
-		if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+		if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 			/*
 			 * Need the extra ptesync to make sure we don't
 			 * re-order the tlbie
diff --git a/arch/powerpc/mm/book3s64/hash_native.c b/arch/powerpc/mm/book3s64/hash_native.c
index 90ab4f31e2b3..02568dae4695 100644
--- a/arch/powerpc/mm/book3s64/hash_native.c
+++ b/arch/powerpc/mm/book3s64/hash_native.c
@@ -199,7 +199,7 @@ static inline unsigned long  ___tlbie(unsigned long vpn, int psize,
 
 static inline void fixup_tlbie(unsigned long vpn, int psize, int apsize, int ssize)
 {
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		/* Need the extra ptesync to ensure we don't reorder tlbie*/
 		asm volatile("ptesync": : :"memory");
 		___tlbie(vpn, psize, apsize, ssize);
diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 631be42abd33..69fdc004d83f 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -201,7 +201,7 @@ static inline void fixup_tlbie(void)
 	unsigned long pid = 0;
 	unsigned long va = ((1UL << 52) - 1);
 
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
 		__tlbie_va(va, pid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
 	}
@@ -211,7 +211,7 @@ static inline void fixup_tlbie_lpid(unsigned long lpid)
 {
 	unsigned long va = ((1UL << 52) - 1);
 
-	if (cpu_has_feature(CPU_FTR_P9_TLBIE_BUG)) {
+	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
 		__tlbie_lpid_va(va, lpid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
 	}

