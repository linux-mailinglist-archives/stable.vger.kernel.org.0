Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D7A39512D
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 15:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhE3N7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 09:59:34 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39169 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3N7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 09:59:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 758CC194071E;
        Sun, 30 May 2021 09:57:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 30 May 2021 09:57:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5MPaL/
        F9JDxyyTMqPLfmHwYu2Vaiz6aGM9jCNSUP0b8=; b=KViwz1c4OgqHzUYvprRFYm
        reG11GgngFWTmMty9L9w9MHQXcHwmoBJu+xYnLB97Na8ivVh8GYf5kadIlu3AA4U
        MKrC7nzznay6YbFFBEhuksITmbOWb8QERxQn24grTQWGkhqIweMhhlmnEj74dzTi
        llOHemE5Fn5TpYFZbsFPPUY1CwkojEgRmfP2kV0SMmdykaTdunziyn8299ufz6Vz
        dqRR5h5YIaoGKx1cD6WKW246LJP5ToeeHsEzxWCSBjDrAHu1Z7cOO7DF6iaVoQlw
        3NuVz0OSpzSpYiZiJyXR8iEERzC4wP6qnUCtQrqROQ3NilHK4YC6wnTuUlSy/kvA
        ==
X-ME-Sender: <xms:45mzYJiXTEA7_cvHRwG_IRd20IKqJYezof1kpVY1PYVGSlVk5kGZaA>
    <xme:45mzYOA35QgiOpAUao4nqS39XQxLX2K5aeRR0cjz8NkVr7wR5LSSyHb4fhzSY8M_F
    T4NNJOZAYSAWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepjedttdeifeejiefgleelfeffudeujeevgffgjeetue
    fgffeuveeftedvtedujeetnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhp
    ohhtrdgtohhmnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:45mzYJFirHNjM7lfkpL5BH6ltN-N9Nq3Eqh0ayyK2SLrNCpVnbNPSw>
    <xmx:45mzYOSpgwFVRk9Jm3R1cpQjGcb2acD-4gvLHWGEmZ4yM_JM7L6yrw>
    <xmx:45mzYGzyJYJtALMgTj_3JyeGfrDjP5V6Z7xVhrNC6ZshXpb0vLGmjg>
    <xmx:45mzYMbgsnBanxLwMxvhYYR5eWciIOgjASBPQAVdOjgFSKGh4-PCGg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 09:57:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: Fix warning caused by stale emulation context" failed to apply to 5.10-stable tree
To:     wanpengli@tencent.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 15:57:45 +0200
Message-ID: <16223830657217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da6393cdd8aaa354b3a2437cd73ebb34cac958e3 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Thu, 27 May 2021 17:01:36 -0700
Subject: [PATCH] KVM: X86: Fix warning caused by stale emulation context

Reported by syzkaller:

  WARNING: CPU: 7 PID: 10526 at linux/arch/x86/kvm//x86.c:7621 x86_emulate_instruction+0x41b/0x510 [kvm]
  RIP: 0010:x86_emulate_instruction+0x41b/0x510 [kvm]
  Call Trace:
   kvm_mmu_page_fault+0x126/0x8f0 [kvm]
   vmx_handle_exit+0x11e/0x680 [kvm_intel]
   vcpu_enter_guest+0xd95/0x1b40 [kvm]
   kvm_arch_vcpu_ioctl_run+0x377/0x6a0 [kvm]
   kvm_vcpu_ioctl+0x389/0x630 [kvm]
   __x64_sys_ioctl+0x8e/0xd0
   do_syscall_64+0x3c/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Commit 4a1e10d5b5d8 ("KVM: x86: handle hardware breakpoints during emulation())
adds hardware breakpoints check before emulation the instruction and parts of
emulation context initialization, actually we don't have the EMULTYPE_NO_DECODE flag
here and the emulation context will not be reused. Commit c8848cee74ff ("KVM: x86:
set ctxt->have_exception in x86_decode_insn()) triggers the warning because it
catches the stale emulation context has #UD, however, it is not during instruction
decoding which should result in EMULATION_FAILED. This patch fixes it by moving
the second part emulation context initialization into init_emulate_ctxt() and
before hardware breakpoints check. The ctxt->ud will be dropped by a follow-up
patch.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134683fdd00000

Reported-by: syzbot+71271244f206d17f6441@syzkaller.appspotmail.com
Fixes: 4a1e10d5b5d8 (KVM: x86: handle hardware breakpoints during emulation)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Message-Id: <1622160097-37633-1-git-send-email-wanpengli@tencent.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d725567961f..622cba2ed699 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7228,6 +7228,11 @@ static void init_emulate_ctxt(struct kvm_vcpu *vcpu)
 	BUILD_BUG_ON(HF_SMM_MASK != X86EMUL_SMM_MASK);
 	BUILD_BUG_ON(HF_SMM_INSIDE_NMI_MASK != X86EMUL_SMM_INSIDE_NMI_MASK);
 
+	ctxt->interruptibility = 0;
+	ctxt->have_exception = false;
+	ctxt->exception.vector = -1;
+	ctxt->perm_ok = false;
+
 	init_decode_cache(ctxt);
 	vcpu->arch.emulate_regs_need_sync_from_vcpu = false;
 }
@@ -7563,11 +7568,6 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 	    kvm_vcpu_check_breakpoint(vcpu, &r))
 		return r;
 
-	ctxt->interruptibility = 0;
-	ctxt->have_exception = false;
-	ctxt->exception.vector = -1;
-	ctxt->perm_ok = false;
-
 	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
 
 	r = x86_decode_insn(ctxt, insn, insn_len);

