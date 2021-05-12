Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF8137BADF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhELKkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:36 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:59487 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhELKkg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id ECC6812D1;
        Wed, 12 May 2021 06:39:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZrG+4S
        waF+htO+MOxMee5L7XJtusvO7enAACrCWvLns=; b=jsLUYr+gPP7nU1G3CRrU82
        AkcHdmCsbD3P9ndVV/QYxtaTjDROXVNZSSg3sBogMiRqLHmhZ54eaXPsELUFnAzB
        3kCS11483gETfi23xit287wPRwls04b10Yxh1mYJpX/S1F9Q9OR9rA+TVqiamZqj
        K58JWERMDhM2nUa0jp0wEHwZ4dTEknvRYCrNuXmHH/TxGKXBke+oKs7O96pVsz9B
        aRJ9vYQl5VpYM6HaICGa4yrCVtUCbxf9UCObfzRU89nXGpq/HGvfANFouT42qZVm
        arvqGmNQGlzzGnDXS0h8K3d5KylUYqM5/ilJCZthkc9bP4OthOqqBVOkk9w0+Wpg
        ==
X-ME-Sender: <xms:XrCbYERy6ptnq4pgPWgkFfia1chr85GcNETejOw6Jsmv-DmFo8S3rA>
    <xme:XrCbYBzbIZyppjEFK8bhPmvMs4jV5Cmu4ZfAKWkZTrx73nNeaHdd1U9UhvAbmSLp8
    bfz4f4hsTa6BQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:XrCbYB3LdSIIW1IrohSQYTlmQpbZWqW-kj_NEBUa0MGF1kbuvpSLUA>
    <xmx:XrCbYID1Qiofhwzan83KVNm-k0Rq1M0eC0nfOlkIRIjPG6RF3CHaqA>
    <xmx:XrCbYNhLV7VvcLu2RYCc7ewYa4LmHClX7ZVr5ZahdZCpNMG5gpb4-Q>
    <xmx:XrCbYNYw8x9mQv6HjnzGhHtypjIh6Uki93tub-oyL9p8hHZEFnuqeYMfclo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Remove emulator's broken checks on CR0/CR3/CR4" failed to apply to 4.19-stable tree
To:     seanjc@google.com, babu.moger@amd.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:39:14 +0200
Message-ID: <162081595423628@kroah.com>
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

From d0fe7b6404408835ed60232cb3bf28324b2f95db Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:20 -0700
Subject: [PATCH] KVM: x86: Remove emulator's broken checks on CR0/CR3/CR4
 loads

Remove the emulator's checks for illegal CR0, CR3, and CR4 values, as
the checks are redundant, outdated, and in the case of SEV's C-bit,
broken.  The emulator manually calculates MAXPHYADDR from CPUID and
neglects to mask off the C-bit.  For all other checks, kvm_set_cr*() are
a superset of the emulator checks, e.g. see CR4.LA57.

Fixes: a780a3ea6282 ("KVM: X86: Fix reserved bits check for MOV to CR3")
Cc: Babu Moger <babu.moger@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-2-seanjc@google.com>
Cc: stable@vger.kernel.org
[Unify check_cr_read and check_cr_write. - Paolo]
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index f7970ba6219f..abd9a4db11a8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4220,7 +4220,7 @@ static bool valid_cr(int nr)
 	}
 }
 
-static int check_cr_read(struct x86_emulate_ctxt *ctxt)
+static int check_cr_access(struct x86_emulate_ctxt *ctxt)
 {
 	if (!valid_cr(ctxt->modrm_reg))
 		return emulate_ud(ctxt);
@@ -4228,80 +4228,6 @@ static int check_cr_read(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
-static int check_cr_write(struct x86_emulate_ctxt *ctxt)
-{
-	u64 new_val = ctxt->src.val64;
-	int cr = ctxt->modrm_reg;
-	u64 efer = 0;
-
-	static u64 cr_reserved_bits[] = {
-		0xffffffff00000000ULL,
-		0, 0, 0, /* CR3 checked later */
-		CR4_RESERVED_BITS,
-		0, 0, 0,
-		CR8_RESERVED_BITS,
-	};
-
-	if (!valid_cr(cr))
-		return emulate_ud(ctxt);
-
-	if (new_val & cr_reserved_bits[cr])
-		return emulate_gp(ctxt, 0);
-
-	switch (cr) {
-	case 0: {
-		u64 cr4;
-		if (((new_val & X86_CR0_PG) && !(new_val & X86_CR0_PE)) ||
-		    ((new_val & X86_CR0_NW) && !(new_val & X86_CR0_CD)))
-			return emulate_gp(ctxt, 0);
-
-		cr4 = ctxt->ops->get_cr(ctxt, 4);
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-
-		if ((new_val & X86_CR0_PG) && (efer & EFER_LME) &&
-		    !(cr4 & X86_CR4_PAE))
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	case 3: {
-		u64 rsvd = 0;
-
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-		if (efer & EFER_LMA) {
-			u64 maxphyaddr;
-			u32 eax, ebx, ecx, edx;
-
-			eax = 0x80000008;
-			ecx = 0;
-			if (ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx,
-						 &edx, true))
-				maxphyaddr = eax & 0xff;
-			else
-				maxphyaddr = 36;
-			rsvd = rsvd_bits(maxphyaddr, 63);
-			if (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_PCIDE)
-				rsvd &= ~X86_CR3_PCID_NOFLUSH;
-		}
-
-		if (new_val & rsvd)
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	case 4: {
-		ctxt->ops->get_msr(ctxt, MSR_EFER, &efer);
-
-		if ((efer & EFER_LMA) && !(new_val & X86_CR4_PAE))
-			return emulate_gp(ctxt, 0);
-
-		break;
-		}
-	}
-
-	return X86EMUL_CONTINUE;
-}
-
 static int check_dr7_gd(struct x86_emulate_ctxt *ctxt)
 {
 	unsigned long dr7;
@@ -4841,10 +4767,10 @@ static const struct opcode twobyte_table[256] = {
 	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* 8 * reserved NOP */
 	D(ImplicitOps | ModRM | SrcMem | NoAccess), /* NOP + 7 * reserved NOP */
 	/* 0x20 - 0x2F */
-	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_read),
+	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, cr_read, check_cr_access),
 	DIP(ModRM | DstMem | Priv | Op3264 | NoMod, dr_read, check_dr_read),
 	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_cr_write, cr_write,
-						check_cr_write),
+						check_cr_access),
 	IIP(ModRM | SrcMem | Priv | Op3264 | NoMod, em_dr_write, dr_write,
 						check_dr_write),
 	N, N, N, N,

