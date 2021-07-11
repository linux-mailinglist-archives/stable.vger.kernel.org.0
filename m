Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8076E3C3C79
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhGKMnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:43:45 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36545 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:43:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 41DA11AC0DB3;
        Sun, 11 Jul 2021 08:40:58 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 08:40:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/TJP+0
        DAwr2I3PSjnExsznOfVDyHxPUGECYnAS7l67I=; b=mEWjhsJzpfzp17h/dda2M3
        DlkkPj7zN73paatiZjY3GPQbPo6dAOvpQWDWQodoDBxudeyWHsu8Oms47yOn+yV5
        zHF/GlHpbNigqTJgU1NtQmNzKGQjx+J+BpVyLCZfYoeuHL0HU/unOVLWS01eqh4q
        9aPDNYCkKLx+U5kfVNxzHpAEIR7u0prSD8sQ+Qnrz6Hw93ew6tOsA3Qu+lBFs3Rs
        9EfFjiZ/XQnFJIju2NmPtoyM9Cs0aM16h7TtEXjlJYzh+Xhlkl55imBAPjlXtHCm
        iDkIgZTy+hHRqV3IFnf4K2C9BCC8ZNgv/wn0KeQirmc4ZtcSB5hsoTSvD4+/a/nw
        ==
X-ME-Sender: <xms:2ebqYJBdXWMwvPR2Z5sMmVBeUzV5uz7vd5SSMNF_8WKCrRynVMcc5Q>
    <xme:2ebqYHhShplo6mYj_-GUvWGnUjeV3IzV6-BIQbvCO7KbH1MBAYQgkTxqCvurb2T5n
    PVG8Al85B7YgA>
X-ME-Received: <xmr:2ebqYElFSRpK_EtftRNQXdc9qU4FXI3RebVOU9MKUIvHShf-kJFD0-U3cMYw9p9tETz6QulypyL8w5oER8-i2pQ2Fw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2ebqYDyCoXfA8CNCDO3CtENhxHXX7U1-LjSvUTqLxHEgAILW0Gin2Q>
    <xmx:2ebqYOQfWl7ckCpbsQ1W0fMXKwCxdiG3i26F13XOSHeA4qhsz7oFwg>
    <xmx:2ebqYGYIHcRsAkXD5cDJCPBlNxsmtihx4UYUwBcYVo76LXHb87h9Sg>
    <xmx:2ebqYBIZuO1iZvzqR5Lm3H0Vgl-5o5lbz6PC095tqX4uyiCRHv4hi5L8i7c>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:40:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP" failed to apply to 4.14-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:40:56 +0200
Message-ID: <1626007256205217@kroah.com>
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

