Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAEA3C3C78
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGKMnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:43:42 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41215 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:43:41 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id E57501AC04BD;
        Sun, 11 Jul 2021 08:40:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 11 Jul 2021 08:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vu3Yjd
        XrA9pcAAvl3KwMTowaIRTbVWThgFf0RIuqxSA=; b=moyB9Lu2S1I6nJxiKfDGg0
        JzHh+1uf0Gdsmw2zHBPGjDqRqhwAv/8d574RKdRDtCzVv/ZgXCGzOWIRIfxq/vOU
        a1O59QGSUqCvZEuO+oojlGqCINhYTbyXJKoqdmBkKQ3EwFEA0kDIyr2L38a5KjJQ
        i+L45snUC4UQIAg+ysoP3duVkASSUthgCT0Bpqb3EfBThZSt+1VrrRnYP0wMRlTW
        WxJDqzjUMa+3rd4G1/Ip5AaWyqoUG7tSZedi4o0oG4hUDJFOn9znqHO4H8EHbS2F
        l7NFsgBXqWD2tzei6fSq1pjiH73572OkDP5Ue5W7KDkiJ+wvtxgWr+oH9Wk5KoFg
        ==
X-ME-Sender: <xms:1ubqYJoRp8GbvvD7hgOphxlwU65jRravr5DSC4ExTrGd1me3B45pog>
    <xme:1ubqYLr24JvZoO4MsycPWrFY-nEznQjfuoElZ39fqfsemv19Qgyvhw_psik5lk7-K
    rlTFDm-aqZ4Aw>
X-ME-Received: <xmr:1ubqYGOBTDPQ3Eijeuf3igYDoP37II6Hv_gKrwBiIs3lLvb6QPagUSMYQ93sitxyzvysKEu81XzZaMN8CFdHKUdRJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1ubqYE51-fkl7qnUq50dOCcE4cOSABu91iMaXaqRCtCl0kDB9Plh8Q>
    <xmx:1ubqYI7KxpLxPlWlcRFmR4hCqoB9VjIakLsbesfFaonObbYFmQ7RVQ>
    <xmx:1ubqYMhubni_CiTFfXLAQugTJ1tVYJCleOH1PMJVnaMBsy9tfyTnuA>
    <xmx:1ubqYGScoKrYFcs4jEa9WJ2jpEukXRqvDY_iehn4Sbk1AuUuaSOR517h1To>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:40:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:40:52 +0200
Message-ID: <1626007252169125@kroah.com>
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

From 112022bdb5bc372e00e6e43cb88ee38ea67b97bd Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 22 Jun 2021 10:56:47 -0700
Subject: [PATCH] KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP
 shadow MMUs

Mark NX as being used for all non-nested shadow MMUs, as KVM will set the
NX bit for huge SPTEs if the iTLB mutli-hit mitigation is enabled.
Checking the mitigation itself is not sufficient as it can be toggled on
at any time and KVM doesn't reset MMU contexts when that happens.  KVM
could reset the contexts, but that would require purging all SPTEs in all
MMUs, for no real benefit.  And, KVM already forces EFER.NX=1 when TDP is
disabled (for WP=0, SMEP=1, NX=0), so technically NX is never reserved
for shadow MMUs.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b3be690d081a..444e068e6ad9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4221,7 +4221,15 @@ static inline u64 reserved_hpa_bits(void)
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
-	bool uses_nx = context->nx ||
+	/*
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
+	 */
+	bool uses_nx = context->nx || !tdp_enabled ||
 		context->mmu_role.base.smep_andnot_wp;
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;

