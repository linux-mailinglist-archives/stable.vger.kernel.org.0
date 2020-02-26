Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD2F16FC55
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 11:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgBZKfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 05:35:05 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35717 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726057AbgBZKfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 05:35:05 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6177821AC2;
        Wed, 26 Feb 2020 05:35:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 26 Feb 2020 05:35:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AaQVOx
        Co92Qriw61cpFU5Dq/p7f5YIaUdz3WXPilWzg=; b=R/V0VpF+vD0BawIkp731r+
        bRqcbfE3cgTC6tV8OFgOWCfpkGYQE5gS1/zgg9FX9ZRxMqC1h32AzWNiylotgjyE
        BpWqajjwRHvewgIP9Jg6C4GMT6nnnnnDseIk9m61Mz79YbgWtDhAMVg8MtOTwfG3
        06ByM2FXQW5PfsLnPh2q2KHlsZDyjIi+su3+AtIU0a/Eop7lMACP1QOhT6PtMY7m
        YNmHyI8T0/cLCmteJauT+1+X8+AFVhxmQN1G4h2au96zm3JhdYaC8RBxQe77SSE2
        o+lYBrFUn/OwmC1PFQO+siGieZl2aQMvJAQKPxnrILLn9P/Yxb0vLdXyjOeK4QZw
        ==
X-ME-Sender: <xms:1klWXnoIQxAfdlveaxmn-pCke9MZ_GSTntKlIZbnl0dVY-hDSmr-3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrleeggddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:10lWXrGebHIjURd2gJIjvBpPIYQHZMbmcpTFy0jlqHFaLmyKFrcTAA>
    <xmx:10lWXq3tq9BaEEpTSpl22h-bFFqauh4lMRtrjgZGxqYawbaWEl7oIA>
    <xmx:10lWXtT9Q2rZLHhJ8XCViCTJIuqbXNdpgNkoKrXWPQJl_v2l-p363w>
    <xmx:2ElWXuz9emoqew6Pnpv8oR0Hxs28UM6pI7qBVGA_5ey2tidblLKN_A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AFB293060FCB;
        Wed, 26 Feb 2020 05:35:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] x86/cpu/amd: Enable the fixed Instructions Retired counter" failed to apply to 4.14-stable tree
To:     kim.phillips@amd.com, bp@suse.de, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Feb 2020 11:35:00 +0100
Message-ID: <1582713300108186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 21b5ee59ef18e27d85810584caf1f7ddc705ea83 Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Wed, 19 Feb 2020 18:52:43 +0100
Subject: [PATCH] x86/cpu/amd: Enable the fixed Instructions Retired counter
 IRPERF

Commit

  aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions Retired)
		  performance counter")

added support for access to the free-running counter via 'perf -e
msr/irperf/', but when exercised, it always returns a 0 count:

BEFORE:

  $ perf stat -e instructions,msr/irperf/ true

   Performance counter stats for 'true':

             624,833      instructions
                   0      msr/irperf/

Simply set its enable bit - HWCR bit 30 - to make it start counting.

Enablement is restricted to all machines advertising IRPERF capability,
except those susceptible to an erratum that makes the IRPERF return
bad values.

That erratum occurs in Family 17h models 00-1fh [1], but not in F17h
models 20h and above [2].

AFTER (on a family 17h model 31h machine):

  $ perf stat -e instructions,msr/irperf/ true

   Performance counter stats for 'true':

             621,690      instructions
             622,490      msr/irperf/

[1] Revision Guide for AMD Family 17h Models 00h-0Fh Processors
[2] Revision Guide for AMD Family 17h Models 30h-3Fh Processors

The revision guides are available from the bugzilla Link below.

 [ bp: Massage commit message. ]

Fixes: aaf248848db50 ("perf/x86/msr: Add AMD IRPERF (Instructions Retired) performance counter")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537
Link: http://lkml.kernel.org/r/20200214201805.13830-1-kim.phillips@amd.com

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ebe1685e92dd..d5e517d1c3dd 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -512,6 +512,8 @@
 #define MSR_K7_HWCR			0xc0010015
 #define MSR_K7_HWCR_SMMLOCK_BIT		0
 #define MSR_K7_HWCR_SMMLOCK		BIT_ULL(MSR_K7_HWCR_SMMLOCK_BIT)
+#define MSR_K7_HWCR_IRPERF_EN_BIT	30
+#define MSR_K7_HWCR_IRPERF_EN		BIT_ULL(MSR_K7_HWCR_IRPERF_EN_BIT)
 #define MSR_K7_FID_VID_CTL		0xc0010041
 #define MSR_K7_FID_VID_STATUS		0xc0010042
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ac83a0fef628..1f875fbe1384 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -28,6 +28,7 @@
 
 static const int amd_erratum_383[];
 static const int amd_erratum_400[];
+static const int amd_erratum_1054[];
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum);
 
 /*
@@ -972,6 +973,15 @@ static void init_amd(struct cpuinfo_x86 *c)
 	/* AMD CPUs don't reset SS attributes on SYSRET, Xen does. */
 	if (!cpu_has(c, X86_FEATURE_XENPV))
 		set_cpu_bug(c, X86_BUG_SYSRET_SS_ATTRS);
+
+	/*
+	 * Turn on the Instructions Retired free counter on machines not
+	 * susceptible to erratum #1054 "Instructions Retired Performance
+	 * Counter May Be Inaccurate".
+	 */
+	if (cpu_has(c, X86_FEATURE_IRPERF) &&
+	    !cpu_has_amd_erratum(c, amd_erratum_1054))
+		msr_set_bit(MSR_K7_HWCR, MSR_K7_HWCR_IRPERF_EN_BIT);
 }
 
 #ifdef CONFIG_X86_32
@@ -1099,6 +1109,10 @@ static const int amd_erratum_400[] =
 static const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
 
+/* #1054: Instructions Retired Performance Counter May Be Inaccurate */
+static const int amd_erratum_1054[] =
+	AMD_OSVW_ERRATUM(0, AMD_MODEL_RANGE(0x17, 0, 0, 0x2f, 0xf));
+
 
 static bool cpu_has_amd_erratum(struct cpuinfo_x86 *cpu, const int *erratum)
 {

