Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3950029EBEE
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 13:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgJ2MgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 08:36:12 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41389 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725765AbgJ2MgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 08:36:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 689BB7ED;
        Thu, 29 Oct 2020 08:36:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 08:36:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jZHK0j
        A7OuAsqc0fN0QrX1xaNqj+wP7Uxr5LfNMMELg=; b=CIwccuqwHZbijtXDStkm6U
        pat7DpAsMCiQ8MOxrZCqO6+dopblFUmLJxByEKiPjWswp06cwS9qOLFzvKf/ZhF4
        MpmPU9nKdgh00Zp3pLMBrUTTjjl0HXrL/SJXaIw56qYtQd+6slp+rq6N9A5BlY4F
        lKwo+j0w9aIiH9LXziQbicnYodM68J56t/fWgfOm5Iy/+VWk75xqIXxbIduoQj1b
        jMzBsc/afC/zV4Ix7CZ1D4DWXQV8/9YN1XBHN5JEmyrp617wMAlwHULPoUrofK6s
        GmnIFbqjmMC4/ugPArz/kfPvzPFGPL3LMvTz9Em+ZtFxwJtWEXJwhlh0Kvv4eMZw
        ==
X-ME-Sender: <xms:OreaX9_81XXMwAl9ytoPXOYQ6O0-r6n8rcSYOlie8ARDuneqb_QoPQ>
    <xme:OreaXxsh1zT8Ipp0B4VwkaWBsTanG5XWS31w6Y89D3grE6UzVAqMvLAO6pCrILYaf
    FjXB6Co0NtrPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:OreaX7Cym61J7oiznLVJDO34ViPUm5ti0Y936nXZo0PbR11c8ugmUQ>
    <xmx:OreaXxeh-GzV-ytNLPHf54rFKpd0TbWyyeCHsaR3os2CpM-yIs_dOw>
    <xmx:OreaXyMFD3buj0DLUB0KxbDBgAQCo6s9lCDN35kRD927Gfh83E56uQ>
    <xmx:O7eaX00YxCQR0UUi0uqEcLjSx1eein7jAsHZCNkklEcHEDooz9CNuwYz6M8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8829D3280060;
        Thu, 29 Oct 2020 08:36:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs" failed to apply to 4.14-stable tree
To:     maz@kernel.org, stable@vger.kernel.org, suzuki.poulose@arm.com,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 29 Oct 2020 13:37:00 +0100
Message-ID: <160397502015568@kroah.com>
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

From 18fce56134c987e5b4eceddafdbe4b00c07e2ae1 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Thu, 16 Jul 2020 17:11:09 +0100
Subject: [PATCH] arm64: Run ARCH_WORKAROUND_1 enabling code on all CPUs

Commit 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack
thereof") changed the way we deal with ARCH_WORKAROUND_1, by moving most
of the enabling code to the .matches() callback.

This has the unfortunate effect that the workaround gets only enabled on
the first affected CPU, and no other.

In order to address this, forcefully call the .matches() callback from a
.cpu_enable() callback, which brings us back to the original behaviour.

Fixes: 73f381660959 ("arm64: Advertise mitigation of Spectre-v2, or lack thereof")
Cc: <stable@vger.kernel.org>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 88966496806a..3fe64bf5a58d 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -599,6 +599,12 @@ check_branch_predictor(const struct arm64_cpu_capabilities *entry, int scope)
 	return (need_wa > 0);
 }
 
+static void
+cpu_enable_branch_predictor_hardening(const struct arm64_cpu_capabilities *cap)
+{
+	cap->matches(cap, SCOPE_LOCAL_CPU);
+}
+
 static const __maybe_unused struct midr_range tx2_family_cpus[] = {
 	MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
 	MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
@@ -890,9 +896,11 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 	},
 #endif
 	{
+		.desc = "Branch predictor hardening",
 		.capability = ARM64_HARDEN_BRANCH_PREDICTOR,
 		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
 		.matches = check_branch_predictor,
+		.cpu_enable = cpu_enable_branch_predictor_hardening,
 	},
 #ifdef CONFIG_RANDOMIZE_BASE
 	{

