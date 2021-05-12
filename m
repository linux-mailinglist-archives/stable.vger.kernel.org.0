Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0AD37BADD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhELKkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:32 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:56147 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhELKkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 2D9D5C14;
        Wed, 12 May 2021 06:39:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kc5lYF
        LIRyyc9Vvuh0wlocx++vkOMzMJfUxjxQJGK1w=; b=M3bl4GZ7wSk7DcM7eIZUff
        2XMs25ODVh9qGH6bpmgD3lHDx6o8SyC1rljaU7EUQwLP1CGkATLLVgcR1HF54bsT
        fl7M3Z+IpwAxTnPyvuO7gk7UFSFfNvdTK2uY3VrDw+EN8h4ZygcR3VsG+9jLRbLB
        3fTK2JxBq2ug7cPCLApeaPdoDvOKu5DVmFBKN5/3qYiVqqX839lIIJBF1PLmv9Ev
        cuHClzuCAe8qL0xGobzgiH1tGxf5RZh2GwhJcvHYASAMilL0YiOIlQOWaOq8XSxs
        fVMRdlygycLFilHhVURNIbBj2T/PIHsigaPDGmxOHlv/QqUGZ9kk8YsK6bAqP+qw
        ==
X-ME-Sender: <xms:W7CbYGaFWqIvVzpPPtFU18q8eKulFRUkfF_idHZDqDP4WJ28C6pRYg>
    <xme:W7CbYJaMYirHhG9t1_nCAIr2qmzb-e8mMJiPdYUogqQYh2d9Pcc2CLPOY48ZCDkJ4
    38O9S60OL03fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:W7CbYA_47DvmxJXbbtKbgZB-wAqGqh08V3llzwH3lznW-5NtMaHgwg>
    <xmx:W7CbYIqEel9osyaw5g7X2t1JrTBW2T-4iqld3jLBjYXWAiyHacatXA>
    <xmx:W7CbYBovutEdpQSl97S9XfcQxX9sC5oLUpITgqY5Ji58WBWmC0iczg>
    <xmx:W7CbYCDXZWDLbLjsj8CIY77_fjsBBZ6iVb6xxD-gS5PlRH_RTE2ORp5qhXE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Remove emulator's broken checks on CR0/CR3/CR4" failed to apply to 5.4-stable tree
To:     seanjc@google.com, babu.moger@amd.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:39:14 +0200
Message-ID: <1620815954107131@kroah.com>
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

