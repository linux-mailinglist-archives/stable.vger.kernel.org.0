Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F2A35ADBF
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhDJNmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 09:42:38 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41919 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234180AbhDJNmi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 09:42:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id BB78619407C0;
        Sat, 10 Apr 2021 09:42:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 09:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=S++fwH
        tp1fEPwbNe8tlfkfeUyNYnw5SNRpSUMhS6Mgs=; b=VyaBr4XkILEUlUdXq5fd8A
        Mq8MkxV12rfKWqPrX5R6qMtMYW2Pa2Zm2rwXPLsXS1ZOOD1nO7LcORqeFNvuwiBg
        zTj4/Dstu9Ph+lSrPLmK7phNSZuKH72aScOLz/G24p/+BCiIZup1mXJJVQ21o7fx
        10XAMRvpxkCsruc5IVo1DwV2l9E/pbocRD7Vw0WyBC5dy2l3Y5tC2ueQFSCbvs4m
        dxr3sFgTr8rHk4RKIyV8sr1klgeHscpYS1csbs32UHoD0bOTeLJnnlR7daWPSbVO
        hg7Wqlu4ywTUAogqNvH0TYuTUS3AIcKAA0MejURxBaPHcP2v4irRYfSzeHUDtg5A
        ==
X-ME-Sender: <xms:P6txYCJ8aXlG1z89yrSg0SILUGur43G5kIrznn9EFSzdQuh_w4YHlg>
    <xme:P6txYKKCvqry0EfSAskOuEG7Vtm5w2e5ZuTVqv7q4BwmC_2OZfoma4bUwdDI1wLwH
    CWn3Y50lmq4VA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:P6txYCuDM72kGLTGxGV8eU-gUNggDbG2W-MgZo_JfrgTw5wtlC9spA>
    <xmx:P6txYHbnTlH67BQ8y4sU4DZ_5O__pSI93ctOhXndE2vW2tlwMcj-sw>
    <xmx:P6txYJZVmHOONxO75o3SvrEhR3xvHEm9ZvHuu-bUZlBPgJ5G6CGjnw>
    <xmx:P6txYKC6nzSOWajBYsbIpc2FxwuSFdSLSMzouRoF-uQ9s3vJvja72g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6A66F240054;
        Sat, 10 Apr 2021 09:42:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to" failed to apply to 5.11-stable tree
To:     pbonzini@redhat.com, seanjc@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 15:42:14 +0200
Message-ID: <161806213423097@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 315f02c60d9425b38eb8ad7f21b8a35e40db23f9 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 6 Apr 2021 11:08:51 -0400
Subject: [PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to
 kvm_tdp_mmu_zap_sp

Right now, if a call to kvm_tdp_mmu_zap_sp returns false, the caller
will skip the TLB flush, which is wrong.  There are two ways to fix
it:

- since kvm_tdp_mmu_zap_sp will not yield and therefore will not flush
  the TLB itself, we could change the call to kvm_tdp_mmu_zap_sp to
  use "flush |= ..."

- or we can chain the flush argument through kvm_tdp_mmu_zap_sp down
  to __kvm_tdp_mmu_zap_gfn_range.  Note that kvm_tdp_mmu_zap_sp will
  neither yield nor flush, so flush would never go from true to
  false.

This patch does the former to simplify application to stable kernels,
and to make it further clearer that kvm_tdp_mmu_zap_sp will not flush.

Cc: seanjc@google.com
Fixes: 048f49809c526 ("KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping")
Cc: <stable@vger.kernel.org> # 5.10.x: 048f49809c: KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU during NX zapping
Cc: <stable@vger.kernel.org> # 5.10.x: 33a3164161: KVM: x86/mmu: Don't allow TDP MMU to yield when recovering NX pages
Cc: <stable@vger.kernel.org>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 486aa94ecf1d..951dae4e7175 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5906,7 +5906,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (is_tdp_mmu_page(sp)) {
-			flush = kvm_tdp_mmu_zap_sp(kvm, sp);
+			flush |= kvm_tdp_mmu_zap_sp(kvm, sp);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);

