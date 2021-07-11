Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4A83C3C6E
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhGKMl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:41:56 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:35379 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:41:55 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id DDFC41AC0E9D;
        Sun, 11 Jul 2021 08:39:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=N5PIkB
        A+7ksuj0bUPRNsss50hGZnnIzsoIhl3qg7hTA=; b=wc4K+xzlkP4K1jqKJ/xERJ
        jOtsbyQlDWekekqQaCfCixtUXvoFjXQOgDIPUBHhh3k4sqiv8HKAUgIOiVELuDtg
        HuU9g4hqj9CPAJRqLleXyVwpamRKNE8NiaJQWSWQeSn11r03lPUSo/TzDft838wS
        KZPKjWJfj7O7Ga1sf6qYk4wASwJqusgC0rxSCxqc1bF+HHIuHGgTqM0HPyPjVjTU
        Uu7Lgd42QabHdEV6gWa4dOe4/VAeVmkbI68Ob9NQg5wiAa+nK5Ti0ZhjDQPdDIPN
        9t9P1Eo45oika8gcFLPo0LRpTFAb37NIJfaUbwwRtb5DDVu8hYs7ZjyeEuM+tXDQ
        ==
X-ME-Sender: <xms:a-bqYPoMOClJq2mOMAxnhdPRUnCv1yX5cYMA8BaKFeOdcO2BLKkNqw>
    <xme:a-bqYJo-9PLlfUJ64mW7NNa0ZZH_oolZo8VZ2F6iHtXBZOKE6oRbeIwsT3h5Tu16h
    1jk6bep4NZajw>
X-ME-Received: <xmr:a-bqYMNblRsfNFb1Mb6vyrogtqaHUbXcngxQv9VRqMMeovY4Ba50o0C2ckWUQ-xd9y3z6XbBXMkt8KXFvxXzIkUcdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeefvdfhvefhtdekffejteffvdefieefteeuteehleevle
    fhfeekieetlefflefhheenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhrmhhhrghn
    ughlvghrshdrshgsnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:a-bqYC6wsOXnEXtyYbTq95IcU7LXEFr_6zXZOHET1p6wgrjRjGqU0Q>
    <xmx:a-bqYO4bMBVSoJrr-I_X9jT5O56bqWCbQscOs3jg46eEF-bWB6tF6w>
    <xmx:a-bqYKhU4uKy6O0IPS4DnD885rX2R4hCWUlhUtOYWe5Uix603HD5tg>
    <xmx:bObqYOF4vTRIggjT8qyL0YM8QcenxytVWTmPqSHbTCeGKaXG9aOBLD53_cA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:39:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path" failed to apply to 4.4-stable tree
To:     npiggin@gmail.com, farosas@linux.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:39:06 +0200
Message-ID: <162600714694213@kroah.com>
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

From 6ba53317d497dec029bfb040b1daf38328fa00ab Mon Sep 17 00:00:00 2001
From: Nicholas Piggin <npiggin@gmail.com>
Date: Wed, 26 May 2021 22:58:51 +1000
Subject: [PATCH] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path

Similar to commit 25edcc50d76c ("KVM: PPC: Book3S HV: Save and restore
FSCR in the P9 path"), ensure the P7/8 path saves and restores the host
FSCR. The logic explained in that patch actually applies there to the
old path well: a context switch can be made before kvmppc_vcpu_run_hv
restores the host FSCR and returns.

Now both the p9 and the p7/8 paths now save and restore their FSCR, it
no longer needs to be restored at the end of kvmppc_vcpu_run_hv

Fixes: b005255e12a3 ("KVM: PPC: Book3S HV: Context-switch new POWER8 SPRs")
Cc: stable@vger.kernel.org # v3.14+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210526125851.3436735-1-npiggin@gmail.com

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 28a80d240b76..13728495ac66 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4455,7 +4455,6 @@ static int kvmppc_vcpu_run_hv(struct kvm_vcpu *vcpu)
 		mtspr(SPRN_EBBRR, ebb_regs[1]);
 		mtspr(SPRN_BESCR, ebb_regs[2]);
 		mtspr(SPRN_TAR, user_tar);
-		mtspr(SPRN_FSCR, current->thread.fscr);
 	}
 	mtspr(SPRN_VRSAVE, user_vrsave);
 
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 5e634db4809b..004f0d4e665f 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -59,6 +59,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_ARCH_300)
 #define STACK_SLOT_UAMOR	(SFS-88)
 #define STACK_SLOT_DAWR1	(SFS-96)
 #define STACK_SLOT_DAWRX1	(SFS-104)
+#define STACK_SLOT_FSCR		(SFS-112)
 /* the following is used by the P9 short path */
 #define STACK_SLOT_NVGPRS	(SFS-152)	/* 18 gprs */
 
@@ -686,6 +687,8 @@ BEGIN_FTR_SECTION
 	std	r6, STACK_SLOT_DAWR0(r1)
 	std	r7, STACK_SLOT_DAWRX0(r1)
 	std	r8, STACK_SLOT_IAMR(r1)
+	mfspr	r5, SPRN_FSCR
+	std	r5, STACK_SLOT_FSCR(r1)
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 BEGIN_FTR_SECTION
 	mfspr	r6, SPRN_DAWR1
@@ -1663,6 +1666,10 @@ FTR_SECTION_ELSE
 	ld	r7, STACK_SLOT_HFSCR(r1)
 	mtspr	SPRN_HFSCR, r7
 ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_300)
+BEGIN_FTR_SECTION
+	ld	r5, STACK_SLOT_FSCR(r1)
+	mtspr	SPRN_FSCR, r5
+END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 	/*
 	 * Restore various registers to 0, where non-zero values
 	 * set by the guest could disrupt the host.

