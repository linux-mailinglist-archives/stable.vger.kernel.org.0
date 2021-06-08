Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA2739F825
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 15:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbhFHNyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 09:54:49 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:49533 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231162AbhFHNyt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 09:54:49 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 79DFC1946;
        Tue,  8 Jun 2021 09:52:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Jun 2021 09:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xWzGUn
        ukW/pmF0+7TEVPtixgZ3paXHEuETnHzzrv9hU=; b=Zkf/Eep35GTuieo9yAH9ZU
        mIlTPHP6Eu09ecmyw7my/9huhw0Lkf46PoQH0kioq7HpZFGYBjkXE+/iDLnvz/xR
        cvRNXNTtlkABMTGyq0XwAf2xMLTfHYXSNR+05pyNt19bwpuG2gQzzHwkJoSsjhsX
        G6UPZEC7qHVFmAHjIEK8KqB1icrLDqiJpglqHYO0q8uQMt2AbWa0v/vcLy3VGSqJ
        y4kVOYwiajEz6vfOYM7EiJ6CM33eXC9QnVc57nm9S1u0DTZDIYD5x232OaGe1dHA
        zao7tMlGqidBcv0w3WP5gn+FM4u2IYgdocMhrphqhkx3nLmgCIyBHDNUlWzFqJsg
        ==
X-ME-Sender: <xms:OHa_YKa82auaOmW2LaC_5ZLNtR8vH5IWYO2tBhSqNgah2NiOtpGfog>
    <xme:OHa_YNaSMPCCCM590WbtRiBJ9yERvvY2o2RLUQ9qnx_NXutbZV8iKzujx6y3WyMIf
    ELlduSFb2uttQ>
X-ME-Received: <xmr:OHa_YE8hQ9EIxjxfBJUEh3OICG8oy1G8CinOqFDW3ncgEoSjy3Bsgw0j-9otzJKeeIGCjQmi0ywRrTnMQt5-QRke06YcWFO8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfedvhfevhfdtkeffjeetffdvfeeifeetueetheelve
    elhfefkeeiteelffelhfehnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdprhhmhhgr
    nhgulhgvrhhsrdhssgenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:OHa_YMqUOeWIvaA4z3kkeNFPkhU-ik4RJ_RnnTe8zYri-_-8KH2eXA>
    <xmx:OHa_YFqaredys1Tp_PPpoLsE9zzYxLHymGHxgRyYeRuOd1p7fooe6A>
    <xmx:OHa_YKQwdnUE8-JWHPJ-V4ECVickJclm-9e5HuGi1MtplAh1_oR33Q>
    <xmx:OHa_YM3YC6J-3byR4xiW0AkugQiDk9fme0m71Hxtl97vNj4d64x16bvkgbI>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 09:52:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path" failed to apply to 5.4-stable tree
To:     npiggin@gmail.com, farosas@linux.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 15:52:45 +0200
Message-ID: <1623160365124171@kroah.com>
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

From 1438709e6328925ef496dafd467dbd0353137434 Mon Sep 17 00:00:00 2001
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

