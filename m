Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7500A377D57
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhEJHoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:44:17 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:33781 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhEJHoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 03:44:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7ABA41940226;
        Mon, 10 May 2021 03:43:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 10 May 2021 03:43:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oUV2gv
        qUtwfYgJNnZLBZ5hiF7BXCrnfQy3JQsG6YJXc=; b=BzX70suWII/BAcT0g16OnD
        gNkQW9HkqlBhf6bqXq3zMbt9uNMl/tQoZB9KXP0JQRUTUekXEB1Jct0p5J10BuyN
        m2Pte2eGrtUxPqZzU9a8x3lUZasJ17i8KAEmRGj2Fr/IN0GregBd8Kv1KeNDOr4q
        rgHPOipNR+BavEdjc/EYWFteBr1x2oSOMQpLN8R4vo1T4J5jbmkK5QIaDLF97v41
        5pU34VBOGwMi/SpnncTKchtAO8/xXKOEu/IHiFjFlXO+UNAGMJdV56rHT+sRm9ub
        QcW9mv6WorpaxjQIHgPxFniirJ/ZPHlXb1eBokGSVRGOBsbRAMCjefwLuDvFMbnQ
        ==
X-ME-Sender: <xms:EOSYYOuEZLjt_KD0lVvI0xz9B7y0NN1mwKtPaKzUJuSgrmBojmljIg>
    <xme:EOSYYDfW0Wx-nlwuAjlNIXSNufUL-5wr4khJVyUNXuqZPHwb2L9DHSGA6AGO0v2hw
    D0QEqtdJ3tTTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:EOSYYJz34f9NaCVuNJcS1UFOqRkAyytpCtC3W2pzDbGOfdES85SQqw>
    <xmx:EOSYYJMBYMjRpe8xWL6xhXqE3evAbAYHdff5Arnd7hIuVuuO95VRGA>
    <xmx:EOSYYO-BEryLV2biVg_RRRLVuAxZ5lWebcPuL8-btjg3Pg22rWkbhQ>
    <xmx:EOSYYDHswypORlI2PtjwtSjtHKQaxuJ7k9ZDjYe4XLC5BmbxgpJ7Bg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 03:43:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is" failed to apply to 4.9-stable tree
To:     seanjc@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 09:42:59 +0200
Message-ID: <1620632579163131@kroah.com>
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

