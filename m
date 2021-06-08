Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7847B39F826
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 15:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhFHNyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 09:54:55 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:36419 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232752AbhFHNyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 09:54:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 19DEA1AF3;
        Tue,  8 Jun 2021 09:53:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 08 Jun 2021 09:53:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uvXGmu
        eAqc1WKOuVx0C7SLlFoeoVTcqKD7Z/bUmmBsA=; b=bMF2wKmf2zhXHa+fZua6a+
        qVpBOd0KNAMUD/ZQgUs5SDI09re/HvICESodPEATBA0I9Kq14kb9P0iz//eCWDlG
        coQ5c3hJENu2Uf5fsmz2onYOtIp0WuOTRWa5tGl7MMaBBTSIC3t9tvV8KwRnAE9Q
        VJZm7JQ+i8+o37bajCqkiQbuj2Ft02DfEdooJlWQ7KA+x8LT3fuP1R8NEd3Fvbsg
        HZNhwUhmeNa1B8z6wM1jquf39PW0aKyiXeivHCn+gYV8SFSoBgNUpEZIe2aAlNps
        EiXobIjEayqdxaoahI+NjvvsJFWINRPSqeThIZztFmGVSMGdxnkeyungwt77DAMw
        ==
X-ME-Sender: <xms:Ona_YIX3BeN0lA3eYIP4kBp3Pt5vuuQ0n6mijjkVwMik7Jd_1rvc1w>
    <xme:Ona_YMn9fdLjzKhcA-IeVcFq7G6SQgQMNMUU0VJJsW1gwUIgkJ006KXpAJpKv6GQ0
    _vykH1oCbBUAA>
X-ME-Received: <xmr:Ona_YMb8UwwnsKbTvYajslviTUpxsG3Sb5KcTMS7gTvSyYleGuPxsYJXMoUkAhBV6SPQxJfiTZCoRnffuvwyEGyavoxjVQbv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedtledgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepfedvhfevhfdtkeffjeetffdvfeeifeetueetheelve
    elhfefkeeiteelffelhfehnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdprhhmhhgr
    nhgulhgvrhhsrdhssgenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:O3a_YHXwR7T1TSxchNmV5lHoBHNC5f7mVGgqZUU4ZoVIsYUVtzPPbw>
    <xmx:O3a_YClEysIhNufNe5WnbPb9TDPNR3ChOeR34nd3CX8IOuNha81rcQ>
    <xmx:O3a_YMd3Do6NNh2t2iztfjsyURnBmJdNsI-VybgF2jqt9McVbN59Sw>
    <xmx:O3a_YHxNIMoRAVeaJZXB7Ib1O7zzl2ZS4fLq4f3lR3-Fgz1hl5kiqCsE05w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Jun 2021 09:52:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: PPC: Book3S HV: Save host FSCR in the P7/8 path" failed to apply to 4.19-stable tree
To:     npiggin@gmail.com, farosas@linux.ibm.com, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Jun 2021 15:52:46 +0200
Message-ID: <16231603662868@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

