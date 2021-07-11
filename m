Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316E93C3C7A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232768AbhGKMns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:43:48 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:48769 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232730AbhGKMns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:43:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D09411AC0DB3;
        Sun, 11 Jul 2021 08:41:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 11 Jul 2021 08:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=x6mGAr
        4SXp98u04SIeBnaSsOGIGdt4NxvDBDMln4iSU=; b=eE6qtBswt2RV50bPuCqKNU
        j4YXO4lgJvuf8EaZsbqVTPu9X9dsmtgRyfcddCo5n7ZkHufCGKHZfA2cGKt/O0M6
        zLTK95xZMKJi4G9P5zSt7l9LItKUMltxlPNMyyreqrvjfhj/of1CqTyv+DIKoA+V
        i4rlsUAAl+jAPOAeCaM21GJg5Z2GOLJ4bu4cHw459RAUrq7F8gyeXb1unArelzq3
        W/xOdzZrhJZRvFghUW1InlH+U5EH8nWsXlY+41jeBqikp0vLnOeHo8Z1Lryw8ADj
        9OFkeEZmSbVSbV9B4TOslGibF3V9mjIbpuWCY1pt8fe08FWV2g28LcZ3VWNXgziA
        ==
X-ME-Sender: <xms:3ebqYPTGcfXgJXsYZWOWg5P_Yuf6dVsH4klSm_WZ_hRB3lFZ0NxXxQ>
    <xme:3ebqYAwKFwObG6FOM9fNll00ZelzMSNokorHEWIt4msSYSw1qTxjNw0cA7I9dJgGj
    mlexkOn26djEQ>
X-ME-Received: <xmr:3ebqYE1nRqanPHOr9EeAtnzz8FaoTlm8QwfvY95Jepu-gAA5WIDJIMdSMN1SRNAd-8llCL_VaHALhJqXbdlR1CGanQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:3ebqYPCVqFJ37stVmgAwmRoKcuZkuQp4PdxFdwE3oVffcqkleW94kw>
    <xmx:3ebqYIg7AT4LpYBxRxppByUnXGkkV0Q9E0ZP1IX8p4c1yy_fmrkT1Q>
    <xmx:3ebqYDolSdS9w7pId4Mi12Fsoatu0-GYSAZDqtf4sRyOqaMptw890Q>
    <xmx:3ebqYEZv4jOsQqRRQEjOat7XxhAun2LQj4tlyuhUavaJlDudoX-Xk3_gxME>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:41:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP" failed to apply to 4.9-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:40:59 +0200
Message-ID: <162600725917152@kroah.com>
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

