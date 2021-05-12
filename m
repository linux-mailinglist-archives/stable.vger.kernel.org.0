Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F53337BAE2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhELKkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:53 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:56461 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhELKkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:52 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6BA921940E95;
        Wed, 12 May 2021 06:39:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:39:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Y2A65o
        UJi0KPAwMzAyKy/A8KmJEmO/l0pABq2jcq/4g=; b=jjJhsE6bL9rJqwsvzt1QTP
        2DM8mCQ7K3/ApoPfEGZhh81WiHkb3bIrX5iVkuMqCeIjrLtQNJLChJBMorYHD/x/
        Wv96J32X16/tiWYg/I3iWuPLFxNRAtdWmyh5E3Qx9sKeiiikUGRrYRz/hZUWAUrN
        wEAf+7JOxIZdlEE5/xzkn5WnkYi2zlLQgytbcbR7QY9NaiuLJMkgmKwy0ZD2VWgk
        TaamJqoynJIS8qC7ixxz8uaulOYIzdyBOXaEuwMapz85QX4C2HS2DDf9Od8yIJEy
        xGHgodL/JvoxO6/Z9l2NN8ae5I2nXf1P+O2RktAGQolhafjauagQRCiqCojbnRLA
        ==
X-ME-Sender: <xms:cLCbYJxQw_G-BHgAOyDrAx4ftGVcdBDb7tF0HxHZXKlwfckBZhP3eA>
    <xme:cLCbYJSWW0qWjmymPDjlsJ2xpc1X3MW7XNnv4MK4okSYpdxlqsaIB0cmp0WSk6HpR
    _w32sGivdlDOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:cLCbYDVtGBJeNeGBWRZ9np-1lkPlQ5rl2010fsBboi65j41rHGBZoA>
    <xmx:cLCbYLiJQ44QYSXBXjpRke72AcFWxJPmKtJYcr9yii-JXkac9IIoUw>
    <xmx:cLCbYLC3YAKf3rFwDorcMK6d2kQTA-GJ-6h7cNZCIzcZpBPCjBnZ-w>
    <xmx:cLCbYOMKyfmic-Ks7v93OazdD5W-uRqF4XY600AwqI4cbLqZdT4GYg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Set the C-bit in the PDPTRs and LM" failed to apply to 4.14-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:39:42 +0200
Message-ID: <162081598222848@kroah.com>
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

From 17e368d94af77c1533bfd4136e080a33a6330282 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Mar 2021 17:10:54 -0800
Subject: [PATCH] KVM: x86/mmu: Set the C-bit in the PDPTRs and LM
 pseudo-PDPTRs

Set the C-bit in SPTEs that are set outside of the normal MMU flows,
specifically the PDPDTRs and the handful of special cased "LM root"
entries, all of which are shadow paging only.

Note, the direct-mapped-root PDPTR handling is needed for the scenario
where paging is disabled in the guest, in which case KVM uses a direct
mapped MMU even though TDP is disabled.

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-11-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index da94734272db..ff7e050ba1ac 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3261,7 +3261,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
-			mmu->pae_root[i] = root | PT_PRESENT_MASK;
+			mmu->pae_root[i] = root | PT_PRESENT_MASK |
+					   shadow_me_mask;
 		}
 		mmu->root_hpa = __pa(mmu->pae_root);
 	} else
@@ -3314,7 +3315,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * or a PAE 3-level page table. In either case we need to be aware that
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
-	pm_mask = PT_PRESENT_MASK;
+	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
 	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 

