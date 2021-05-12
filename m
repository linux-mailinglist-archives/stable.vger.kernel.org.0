Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DC337BB22
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhELKqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:46:06 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:48435 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhELKqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:46:06 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id C5523F63;
        Wed, 12 May 2021 06:44:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:44:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+ROsUq
        8MVZ1Yv/tMg5MIDbaKSYTZdCoFFdS0yL8AnMw=; b=lBa88REDFL/DfZz8ZT8j1M
        EsKJGFy1ZwDgtT0IuukUul1Wu1g71Xf88hK3VV9oI2Is087JrHm5iU5y6tULWfcR
        zU9imW5ZWR02LpRLRJ+0NROBSutFq+FfHURdrDLAUWTu0focZJ6tGdXsrW1aqlnI
        RNQ3i1otqZcz06uywUkwSwcGI3jbRapL8UxkumjkHoSFy5FGaro2J5oxZc9FCZZk
        pYCqh4mv2O5AbpJGMKwAAq24v6vZF4Z9LkpugDP8DrUi9WZsYu4npZm1KVqs1R3i
        HbA7uQTi+MBdfC9n7KcFL0043IrniiKJhCmxb0k6NpzzKIVHi0kEHHuuvcn3w0EQ
        ==
X-ME-Sender: <xms:qbGbYIqwNkRvMmrJZzGmwPrKWu2BbvuYot3bZkly-juuDOCXANBtSA>
    <xme:qbGbYOpCE-FsP87AKbWqjQ8FT5VbUkLJZtYWN0kap78oB_db9mAVqQbsMpYoxfT-m
    dvtODwjGbqq3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgfejgfeggfelvddtffelkeeggeffffetlefftdeuhf
    ehffeuffejtdehtdeggfehnecuffhomhgrihhnpegsrghsvgdrrggunecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qbGbYNMRarbGV0LZNbEOQGus1XcCNhsudw7p0UE07aiPVB4XSAYuKw>
    <xmx:qbGbYP6UlKRTBAHeeGAU8D34jzIlaW6s9CxIaw4TdESq3TCTJ8znGQ>
    <xmx:qbGbYH5oi2stCHwWd3zSeato7CGPyM7lREkyozbkhLEog8uGPplIyw>
    <xmx:qbGbYEh2ii2ldEvTJTB2I77q_PiclEgxRAHaGRfovdxbfJGaKux0JZJDNQA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:44:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Defer the MMU reload to the normal path on an EPTP" failed to apply to 4.14-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:44:55 +0200
Message-ID: <1620816295225212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c805f5d5585ab5e0cdac6b1ccf7086eb120fb7db Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Mar 2021 17:10:57 -0800
Subject: [PATCH] KVM: nVMX: Defer the MMU reload to the normal path on an EPTP
 switch

Defer reloading the MMU after a EPTP successful EPTP switch.  The VMFUNC
instruction itself is executed in the previous EPTP context, any side
effects, e.g. updating RIP, should occur in the old context.  Practically
speaking, this bug is benign as VMX doesn't touch the MMU when skipping
an emulated instruction, nor does queuing a single-step #DB.  No other
post-switch side effects exist.

Fixes: 41ab93727467 ("KVM: nVMX: Emulate EPTP switching for the L1 hypervisor")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-14-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bd1343a0896e..d74abd778429 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5481,16 +5481,11 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 		if (!nested_vmx_check_eptp(vcpu, new_eptp))
 			return 1;
 
-		kvm_mmu_unload(vcpu);
 		mmu->ept_ad = accessed_dirty;
 		mmu->mmu_role.base.ad_disabled = !accessed_dirty;
 		vmcs12->ept_pointer = new_eptp;
-		/*
-		 * TODO: Check what's the correct approach in case
-		 * mmu reload fails. Currently, we just let the next
-		 * reload potentially fail
-		 */
-		kvm_mmu_reload(vcpu);
+
+		kvm_make_request(KVM_REQ_MMU_RELOAD, vcpu);
 	}
 
 	return 0;

