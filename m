Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6882E327D08
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 12:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhCALVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 06:21:45 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:34791 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232322AbhCALVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 06:21:36 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2D8CE194125F;
        Mon,  1 Mar 2021 06:20:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 06:20:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=k4GqI1
        ThAjgjtb5/2YyK5fIFogO69IDiT0ckyqP3qPs=; b=q2xPUYqpOUQkp9LLmW6kBr
        pZlotZYHhlUwx4oedJqEr0oS12mpL8rcPRfjtnv2tJRJR74bdqGADcmXJeZKqsoT
        1sYS4Nw4Q3+WigKwocFxeuWW79Ol4+pxh6B3ZYG+tPEimirHNumzhzkZKzZNhzEC
        Kf/MQ6Yi7HVzDd8QaSPiKVWi766gBlohkOKNxSjfjb2LPl2RjpE11S40jgJI3pLL
        gny9ZStTaqCInafCw6hkIqLoykY9HK6VROKNlSqoiq3TvJLqhMPbk6qnSppJfOMS
        XIgKrApHYnZONC+goHBAF3/pA9sWsEMdfMXkyw8hts8Obe1talT96sqLDFyUUBCg
        ==
X-ME-Sender: <xms:Ds48YNgWisp_3OlFmdAZP3qjUBoe-7Tm3hx_Dv0h0Xg2SjVOA72dWw>
    <xme:Ds48YCDmZ_Rzt8oWrYI6iPERFgckMFxyyjNy489WkmXjTHth2QOscG5rConeI-NTZ
    PqL_oJaqqi7Dg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:Ds48YNET3kUgTVM1778oVlsuCSfURj_3WRreFK3bszVVfanaDa0rKg>
    <xmx:Ds48YCSi6wy6vJrG7T9rRWTEAOkZzLmZiL3rrTya5NE-shB6j53zRw>
    <xmx:Ds48YKwldCEpWSog0eBvFo-3wCFO1N2S27-gC28GuvStF9VOvqELDA>
    <xmx:Ds48YPpNn-qNJVOEISN8F4zj6wBXWJ34mQ8nRzdmueR5CiIILWiSPg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BEF0E24005B;
        Mon,  1 Mar 2021 06:20:45 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/virt: Eat faults on VMXOFF in reboot flows" failed to apply to 4.9-stable tree
To:     seanjc@google.com, dpreed@deepplum.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 12:20:42 +0100
Message-ID: <161459764258135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aec511ad153556640fb1de38bfe00c69464f997f Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Dec 2020 16:26:54 -0800
Subject: [PATCH] x86/virt: Eat faults on VMXOFF in reboot flows

Silently ignore all faults on VMXOFF in the reboot flows as such faults
are all but guaranteed to be due to the CPU not being in VMX root.
Because (a) VMXOFF may be executed in NMI context, e.g. after VMXOFF but
before CR4.VMXE is cleared, (b) there's no way to query the CPU's VMX
state without faulting, and (c) the whole point is to get out of VMX
root, eating faults is the simplest way to achieve the desired behaior.

Technically, VMXOFF can fault (or fail) for other reasons, but all other
fault and failure scenarios are mode related, i.e. the kernel would have
to magically end up in RM, V86, compat mode, at CPL>0, or running with
the SMI Transfer Monitor active.  The kernel is beyond hosed if any of
those scenarios are encountered; trying to do something fancy in the
error path to handle them cleanly is pointless.

Fixes: 1e9931146c74 ("x86: asm/virtext.h: add cpu_vmxoff() inline function")
Reported-by: David P. Reed <dpreed@deepplum.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20201231002702.2223707-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 9aad0e0876fb..fda3e7747c22 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -30,15 +30,22 @@ static inline int cpu_has_vmx(void)
 }
 
 
-/** Disable VMX on the current CPU
+/**
+ * cpu_vmxoff() - Disable VMX on the current CPU
  *
- * vmxoff causes a undefined-opcode exception if vmxon was not run
- * on the CPU previously. Only call this function if you know VMX
- * is enabled.
+ * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
+ *
+ * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
+ * atomically track post-VMXON state, e.g. this may be called in NMI context.
+ * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
+ * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
+ * magically in RM, VM86, compat mode, or at CPL>0.
  */
 static inline void cpu_vmxoff(void)
 {
-	asm volatile ("vmxoff");
+	asm_volatile_goto("1: vmxoff\n\t"
+			  _ASM_EXTABLE(1b, %l[fault]) :::: fault);
+fault:
 	cr4_clear_bits(X86_CR4_VMXE);
 }
 

