Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0816737BAD6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhELKkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:03 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:60611 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 22A4A12D8;
        Wed, 12 May 2021 06:38:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:38:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8ihTL7
        BMs6wYIj5CeOTV5vbQ2x9Vm3jMKWU5O4FrV+4=; b=jLcptYFVHpc7qZZHHWnytY
        4WSLO1LHahI2ToR1hRHaR5ocEpqTIF2C6WOGXmPQs1cduR1FnpIvMkZOo/LfpW/l
        lGkWd/HZDdSjJuuPwn1SibDiqGyOjdC3Ai1uoK8NOnFkHp4MgUWacRRqz+qHrc4S
        M+3FH3bWLhMYqlxWYdlmkGC17g29dMl9U7XyWb9llZMbOYCAQ7Ok99G/yKQ2VJNg
        HeOH+f8nOHhXKf2apT6v0xRiudXBMH6kmFcFDEeFulIgB/1akpqoQvWaw3X9P+QG
        3aUAiwoIgvaLl6cKe8tifikrem4O4KRdCuEwLfnocFLaf0W/Y2jYE2soxROretgw
        ==
X-ME-Sender: <xms:PrCbYLEWwX93hmeJ0PbfNDipI4tPgjeO-PbD11JgQddp1WKVVBbx2A>
    <xme:PrCbYIXLu5Arojex3exTUmWNYA8AMIuMfzYRwgLq-Lgppd_lMiIurf9kFPSs21BrL
    weDO8k52Zf7Mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:PrCbYNJ9y0TP_S5MQYZxYs3hHjRGBg7FRLRekPGaxrNo1B9taDXqmg>
    <xmx:PrCbYJGqKnyEW0h6IhA-Ve_Donsq_Uw-Hft7_RHUAzcL-oHR7LtLFA>
    <xmx:PrCbYBWqWGuu7cgPY35O0Jfvchkd17XGVeP2BOVa2GDpFIWJ3gM0XA>
    <xmx:PrCbYCfDBwe7ThE_21ya4EXdehsLTtwOz9IX1XIRmq_t9l0fNZg_3nvfZf8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:38:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Check CR3 GPA for validity regardless of vCPU mode" failed to apply to 4.9-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:38:44 +0200
Message-ID: <1620815924109235@kroah.com>
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

From 886bbcc7a523b8d4fac60f1015d2e0fcad50db82 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:21 -0700
Subject: [PATCH] KVM: x86: Check CR3 GPA for validity regardless of vCPU mode

Check CR3 for an invalid GPA even if the vCPU isn't in long mode.  For
bigger emulation flows, notably RSM, the vCPU mode may not be accurate
if CR0/CR4 are loaded after CR3.  For MOV CR3 and similar flows, the
caller is responsible for truncating the value.

Fixes: 660a5d517aaa ("KVM: x86: save/load state on SMM switch")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c9c9592a437..3010284dc59b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1077,10 +1077,15 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 0;
 	}
 
-	if (is_long_mode(vcpu) && kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	/*
+	 * Do not condition the GPA check on long mode, this helper is used to
+	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
+	 * the current vCPU mode is accurate.
+	 */
+	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
 		return 1;
-	else if (is_pae_paging(vcpu) &&
-		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+
+	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);

