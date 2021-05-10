Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17B9377D55
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230056AbhEJHoG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:44:06 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:57235 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhEJHoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 03:44:05 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4686219405A1;
        Mon, 10 May 2021 03:43:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 03:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9s2l9m
        Yfi44uMscHc2WaiWlQqWnzQ02RuwseOPQuXog=; b=YSnNaPqcgM5RgR8CVQklPP
        pFPObXpR26km4GLEhSjqWuo3iNxDL8DHea6GTsgZYgxWJn4CZP+vJ/cS10ybvWE2
        FPhFmSsCaugHOERJXHS4iyixjjVvoe0WUIBsfcxbTwwYeVq8upat39EUE+xVdoCo
        m21mJ9P4dB+1TI6BVZdIurT64ayB71XUsp7jEpYgA5uJqRBUywnOoVlLyonOEzzB
        RKOc+tX7Ha9oohwOd18qiNvFQn989Nao3f5m85Hbj900CMdof849meUWtufwtzyS
        AUsIL+MmeN4Pwb/M2D7ed71DnZCUryIfLJ+liZt3CYvZcxISxj6F/PBKp6n2VMjA
        ==
X-ME-Sender: <xms:BOSYYMZ_8c8KB0vlF4rbptAY9qXx1pQZ1KWFTFNNA76ePal7bGFO_g>
    <xme:BOSYYHZnHUnfJJadwzZBu6ZsmOEA-WlSnQtJ6eO3oadSqf9hLLZKyU8X5_fEqFQ8G
    nizUkLKHjt_Ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegjedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BOSYYG9poTg6v9b1B0eKWcwxEePyLdUL0nCq-HfRTblTSP-vPu7gOw>
    <xmx:BOSYYGoKq9rml8Tzb5itLWIPXMgeZksG38wJOr9tRVkF2maa41Ia9w>
    <xmx:BOSYYHpvKoiJzQz67HSXwrZ6AieRX-WsDXx7hTmKP0ZHUteD2Lr-5w>
    <xmx:BeSYYGSlouNvUJjHjMXfG5LFVKDnIjAHAAlEWtfxmT2tFimB2d70UA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 03:43:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/cpu: Initialize MSR_TSC_AUX if RDTSCP *or* RDPID is" failed to apply to 4.4-stable tree
To:     seanjc@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 09:42:58 +0200
Message-ID: <1620632578184221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

