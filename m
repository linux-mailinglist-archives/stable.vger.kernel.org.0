Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4569635ADBE
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhDJNmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 09:42:32 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:48901 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234180AbhDJNmb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 09:42:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 239EA1940A04;
        Sat, 10 Apr 2021 09:42:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 09:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=khW1yy
        5Ck4TX4aglYOBOfjer73Prl6S8eujMRxeRwS8=; b=LufjDrwK7RmvgtcL9nDNYH
        RX+PwlM1bKdeRzE5cyjt+1cY/iRxyrMBHRuepzQbp7VSPqY1WK0I3XkYEZvZl7YM
        3Ka+44ZiVQbvbmmx4lqq8XdN/epMA4TtcSdp6guXjz/VdcllGMNR4+bsF/bEyF3f
        emT1wspkNNxthhLPrO1EezbJEIGEtReD9UuoHaXsQme2O/LEx8MEUdZ8xUBns1R8
        hArhVYQoUl2Av0zKrDT3vJCFJ0yPogJGt0FWxHJMubzzKbg7uOTBjsN+zjVecCRB
        tdiqTp9NAayV2LvO5nIaHV6pJyk+0zCM2T/WvHKnwVDjrloDy6CptvvC2kpPph6g
        ==
X-ME-Sender: <xms:OatxYKiMIhGu7iskySDw574OFB62EZ81RnuuS31BCmkZbv3yBeyGQg>
    <xme:OatxYLDv6viFiOFoS13_8sT6NIpKazfPXVqvUlxT6VnIVkUX2GRvK_JU9nWyqACrK
    wCbSTXujid2fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:OatxYCGGAJ3zcFcty-9S39iFC7K1aRdvsrMjky1Kn2d_9Q47NcxFmg>
    <xmx:OatxYDQuCtt6n9k2B8NzRZnht-2waziUbILjWB3m9Z6dOGESAns5Ug>
    <xmx:OatxYHwoDFXRlDK0EpcOHNAosIS48ivG2LnlpzEsuzN6SVRFxGSZPA>
    <xmx:OatxYFbmcZrMFvNY--dJhqY9znPp9cyJNC8OEOzj6HCO2Tp8jyy5Nw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C399F1080064;
        Sat, 10 Apr 2021 09:42:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: preserve pending TLB flush across calls to" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com, seanjc@google.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 15:42:13 +0200
Message-ID: <161806213314922@kroah.com>
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

