Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E5B37BAE6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhELKlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:00 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41959 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhELKk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:59 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8257E1940F70;
        Wed, 12 May 2021 06:39:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uh3uik
        I7gpxHag44ZpUFfPZN1Yj7+mbqIjebQ3Gcrm0=; b=HLGeKPalT/zXdA8+ZZSqxl
        r5X+5361rOUvjvpJJSuyT2pkPnQ2LFVR8zAodj3WoMVdydJS8DXmxCTUognNUuyt
        iy4xtNCiI17WZxhfNhNn/PISrFlK4wpkpok4/jgRo91twwTwH+R9nvMHExyeSxUB
        EAMCqTMXqx8wUxtLERtnVOvz5AW1ECojILiAL5mnWHP4OuVPKL59gepyJxc/fr5X
        BWmcTM7fX8EaKN7cFADTZyKC7jQ0L0+COBVSa01kRgJBjdg5Okf8BdH1BxyC/5i1
        sv4XKkiXanj4mewOS/bCz3P9XlYeKV8NBL54iHWGujoW++UfHl+i06JAyPbyUfTg
        ==
X-ME-Sender: <xms:d7CbYBWmkwACu_GirjWcDD1GQgx9dcGWHyI8FFmPypjLdyZkVMU3mQ>
    <xme:d7CbYBmxZn_UNcsyfELyvOESsqyyfYRVAx9doRvPkw2NO_RG9mu_1E-i4BxWbNp4_
    fNJKI9nKxqD-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:d7CbYNY1Qmp0xfsHPGGqbpR98TXb1t-dPX6cWGnTvvNcIZ_YcOuCZg>
    <xmx:d7CbYEWcujS_p2Ie0JAEsnr0xxu60m7PPcaSRDW2bUnV-gBAvL7ocA>
    <xmx:d7CbYLlLuj2mUDmvEvimmZKmxz7uymuzD7LNiTvuRuwWuZQMOz1N8g>
    <xmx:d7CbYAy3kz-yHCa_0z0TPGaIZhghg5qYfLS0C9y5ykvFu7-6LitDQg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Set the C-bit in the PDPTRs and LM" failed to apply to 5.11-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:39:44 +0200
Message-ID: <1620815984124236@kroah.com>
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
 

