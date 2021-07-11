Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59553C3C77
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbhGKMnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:43:39 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:43395 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKMni (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:43:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DA6341AC0F92;
        Sun, 11 Jul 2021 08:40:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 08:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=USarev
        hsm2SHUd2GVpBHz+56vvOF12TuO7RLx09Quto=; b=p1YKJpfa8q/6dkRbM1TG6E
        LWd05RgvrBolf97npvlKjX5s7wmd7gJ62M5LqWo+9RZy5Ja6C5wB9t1+VWlKIqwR
        KHceH/wtgep/EcZ9d9hE4k8eGAwzJzqfW8cJRF5puAU8Ync2J4ISWIc78vfdPIf8
        wQhPc3UPaQhKuAxywQGB4iSzx+0Ryc/IfZzVBDSuPHb0D9PhpkO531ppwhONENZb
        3+3mG1EuVJVGmglXxT9zdxcER5D+/O1xB6aLV7ZgaPccjhyI/LC2O2GZQpykVh4A
        oJwNj1wUmqLMn48kE49cX7MaKrPkSsPWrKzJ16cvd/IwWVGLmK/07CDvu6bYQksg
        ==
X-ME-Sender: <xms:0-bqYOvAaPa6_y7oHJnTbpEA3f7bWSACAvn2zgQMkMSEHyt7I22FQg>
    <xme:0-bqYDdih_Lk3N5n1woPjU2lo_MagFF99ILtJLLzCDm-YvWbOlWitxXDA1SATyXya
    BlZ6wSyxgf0IA>
X-ME-Received: <xmr:0-bqYJyT9hlBiw_vSKysaEgCX1VodvxiNcpgA3SLjU4aQ6V8hU1Rf-FFcDGsu5ZhG6hsJIg1rtgBpA8OyaHalCqQJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0-bqYJNtTjfSymZ8hdRiyxZ-ZELHU9jW8Q90yCL2MOaBk3XLmeuZTw>
    <xmx:0-bqYO99nrwnfgKN7BswD5skI9O-tEtDvZIOchlzZ3OCa4CylE7TrA>
    <xmx:0-bqYBX12o9l5XY2xhY5W-GE7uv7y1BFIHLSduW2aCB4sOS3pMBk7Q>
    <xmx:0-bqYEl4wBXQdK-wbiXio6vAT6P2Typ6OJhqdsn-ll_AhpT_y9dACkHqxfk>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:40:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:40:49 +0200
Message-ID: <162600724959170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

