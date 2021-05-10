Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5515377D58
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhEJHoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:44:19 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:43317 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhEJHoS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 03:44:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3C6A3194059A;
        Mon, 10 May 2021 03:43:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 10 May 2021 03:43:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=YQu4yF
        743M6wl8DkeRCDjRMWgXsg9U/nT6ywXS7JLFo=; b=iRy3E/ojmSdZJYjHJULL15
        rtOIcosBMVo88G+opuAPiqnjdBakWL/pZ4KamQWpsy4velCWexxGp79RmBbMoI5J
        tCz7r8xCU0z4RHw3YPrZATvQG5lEcXPY2lMJnAQQmnuC70CTo0uUufsx2a6M1myI
        g32XPBbUiHizLFnZzA2HIiKtHwyuUGDUuY06AbOtTEtZ2aYzHo+GVOK1d/D2hCbQ
        wr5NxEsw9BcC67SD8usm/9hE5QHsSbzjZYMnKmJvLwMfxeijBIIutW1NrfpqvQRt
        tDeq1dhaoHme4Qldq3wod0Y6ngFTcibMBng+8N0/eQnWwHqOh4ulaysJ4WO7ZQZw
        ==
X-ME-Sender: <xms:EuSYYJeEEdYRQ_hFo6ZrrXJ1nAJWcCnHcCLCtAjDPC67umXFvLrHrQ>
    <xme:EuSYYHM6v1dypYQTiTxD26_fPguUmBdcnEsEmRfsmLHxhqWjChj3fyFd7E_Dg28rU
    AL6Z1bMVhF3Qw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EuSYYCiNU74I_6UHxqFq6qGPEn4smyjAHofnpPa0xCVQ7aSCdZQ-Bw>
    <xmx:EuSYYC92KDAbgyoY322lz9AJUDHFPLIULBA7yeauTtUUGJE2Fcz_Kg>
    <xmx:EuSYYFtQAM1mXs3Qd5G7Inwl4izS9u4QybkDHH-TX8vYnUeSzHnFTQ>
    <xmx:EuSYYD0nhtTmhruOLMjMtNTv6CY9yCueMMhK6jXs9EmUoBVVJA81ug>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 03:43:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is" failed to apply to 4.19-stable tree
To:     seanjc@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 09:43:00 +0200
Message-ID: <16206325801382@kroah.com>
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

From b6b4fbd90b155a0025223df2c137af8a701d53b3 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 4 May 2021 15:56:31 -0700
Subject: [PATCH] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is
 supported

Initialize MSR_TSC_AUX with CPU node information if RDTSCP or RDPID is
supported.  This fixes a bug where vdso_read_cpunode() will read garbage
via RDPID if RDPID is supported but RDTSCP is not.  While no known CPU
supports RDPID but not RDTSCP, both Intel's SDM and AMD's APM allow for
RDPID to exist without RDTSCP, e.g. it's technically a legal CPU model
for a virtual machine.

Note, technically MSR_TSC_AUX could be initialized if and only if RDPID
is supported since RDTSCP is currently not used to retrieve the CPU node.
But, the cost of the superfluous WRMSR is negigible, whereas leaving
MSR_TSC_AUX uninitialized is just asking for future breakage if someone
decides to utilize RDTSCP.

Fixes: a582c540ac1b ("x86/vdso: Use RDPID in preference to LSL when available")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210504225632.1532621-2-seanjc@google.com

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6bdb69a9a7dc..490bed07fe35 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1851,7 +1851,7 @@ static inline void setup_getcpu(int cpu)
 	unsigned long cpudata = vdso_encode_cpunode(cpu, early_cpu_to_node(cpu));
 	struct desc_struct d = { };
 
-	if (boot_cpu_has(X86_FEATURE_RDTSCP))
+	if (boot_cpu_has(X86_FEATURE_RDTSCP) || boot_cpu_has(X86_FEATURE_RDPID))
 		write_rdtscp_aux(cpudata);
 
 	/* Store CPU and node number in limit. */

