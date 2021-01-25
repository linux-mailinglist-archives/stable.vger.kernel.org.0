Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B0F30266D
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 15:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728508AbhAYOpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:45:11 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:34875 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729666AbhAYOno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:43:44 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 035E3EC4;
        Mon, 25 Jan 2021 09:42:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:42:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=JppwoB
        N+fS+F+YJ8f9NVU5wekCRbeDOarrwKWkdMODo=; b=IoBqfMrbLyPXen58lXHkji
        zVgZ3RDZ1G5+SoBcOPEjPiRZXfQn95gFp4H4lUr7m8GXv9D8BkTn9cZysb9MWr7v
        eXkwklTtEBEieDM17x1IIQsUTpnnpp1IgVUvFuOEIECYTmcsd/GWBOjWl0akx/Go
        kjyWCHMz2Zweu73hOOe+TDfDSX8h84RGq93LfotxPujxa5iul9jzjVxNu6IHD8yG
        clJcS0PwYCPlIFglRgviQhZNQ+l4gdeejjz4RguZNABlupsdWO3Bg3sCwZZVuTD9
        PVTEBK0kqsOakXiDKhqG9dTds1jRnUKgFurJ9YwWHwhNjuUZfB3tOriT1C9YjGCg
        ==
X-ME-Sender: <xms:0NgOYIvyRtC0K-z0FEsmqjnNC7c-lnvEud7wDaCJDLDzS3DnGjbNxg>
    <xme:0NgOYFdDONY4R_Mt_1lu3ryco-9yduItnronMIsI8poSn7-hHGuRq6UV2GVz93iUi
    Z07F8x4CyqWTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0NgOYDwuCUBxIS5rncUUJvyJYMkRatQ7YVkN7Lyf48rqDIZhWDRLsg>
    <xmx:0NgOYLMDpm9POGdj4Unjqg3Ch6PYoi_mSmAP6C09NxFh3Sv6iEW4dg>
    <xmx:0NgOYI8pSpCFVMZRj4-5hVAcFv4e9cbcLUNNkqiXTov4Uq6P0_J9EA>
    <xmx:0NgOYGmy6FFrOOYsyGv1KCdoTwijw5mCesh0hEAT2TbaTrgNtsvvr1nO1sw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D2B771080069;
        Mon, 25 Jan 2021 09:42:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86: PM: Register syscore_ops for scale invariance" failed to apply to 5.10-stable tree
To:     rafael.j.wysocki@intel.com, ggherdovich@suse.cz,
        peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:42:22 +0100
Message-ID: <1611585742254212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9c7d9017a49fb8516c13b7bff59b7da2abed23e1 Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 8 Jan 2021 19:05:59 +0100
Subject: [PATCH] x86: PM: Register syscore_ops for scale invariance

On x86 scale invariace tends to be disabled during resume from
suspend-to-RAM, because the MPERF or APERF MSR values are not as
expected then due to updates taking place after the platform
firmware has been invoked to complete the suspend transition.

That, of course, is not desirable, especially if the schedutil
scaling governor is in use, because the lack of scale invariance
causes it to be less reliable.

To counter that effect, modify init_freq_invariance() to register
a syscore_ops object for scale invariance with the ->resume callback
pointing to init_counter_refs() which will run on the CPU starting
the resume transition (the other CPUs will be taken care of the
"online" operations taking place later).

Fixes: e2b0d619b400 ("x86, sched: check for counters overflow in frequency invariant accounting")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Giovanni Gherdovich <ggherdovich@suse.cz>
Link: https://lkml.kernel.org/r/1803209.Mvru99baaF@kreacher

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8ca66af96a54..117e24fbfd8a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -56,6 +56,7 @@
 #include <linux/numa.h>
 #include <linux/pgtable.h>
 #include <linux/overflow.h>
+#include <linux/syscore_ops.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -2083,6 +2084,23 @@ static void init_counter_refs(void)
 	this_cpu_write(arch_prev_mperf, mperf);
 }
 
+#ifdef CONFIG_PM_SLEEP
+static struct syscore_ops freq_invariance_syscore_ops = {
+	.resume = init_counter_refs,
+};
+
+static void register_freq_invariance_syscore_ops(void)
+{
+	/* Bail out if registered already. */
+	if (freq_invariance_syscore_ops.node.prev)
+		return;
+
+	register_syscore_ops(&freq_invariance_syscore_ops);
+}
+#else
+static inline void register_freq_invariance_syscore_ops(void) {}
+#endif
+
 static void init_freq_invariance(bool secondary, bool cppc_ready)
 {
 	bool ret = false;
@@ -2109,6 +2127,7 @@ static void init_freq_invariance(bool secondary, bool cppc_ready)
 	if (ret) {
 		init_counter_refs();
 		static_branch_enable(&arch_scale_freq_key);
+		register_freq_invariance_syscore_ops();
 		pr_info("Estimated ratio of average max frequency by base frequency (times 1024): %llu\n", arch_max_freq_ratio);
 	} else {
 		pr_debug("Couldn't determine max cpu frequency, necessary for scale-invariant accounting.\n");

