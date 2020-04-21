Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037C41B2DDB
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDURNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:13:13 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:35119 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgDURNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:13:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1DF5B194149D;
        Tue, 21 Apr 2020 13:13:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lvlUjk
        yutq5GWDmbbUyUIL7i10wjjezXaUyJVWXwYVI=; b=AwCZLrGp2X30INwoFLo5Ri
        jmOPlnik0TIdq3tymB5R+gb0R8znZjZibqDovegMNUGawWBjq5e2ZGACH2q9nUGv
        4ByF2nsq2wx6DRHU+wcXYPoXPokubhI4EmbHRRuNlxg16ygfGF/+dUI4ZqduUwb1
        Ld9ImlurY4ikOC7EC2VpdxBpCP31nozuwIXPz3azOQUZ2Fi/iqQ2CR6GDIWbncQ1
        yDwFIsQKZ8//QP54RXa0EvdNjLcU95YjkGD3zHYxNQ7YHpCfd6Dieuj2Cz+jueuV
        NYAoePfyzroHf/slGOrAPMMtnTmTI2QWbFCdJeJN69m701fXqbkwHvvkODVi1dkA
        ==
X-ME-Sender: <xms:pymfXi_e2Dap4gzaf9kYVA1Yq2DngszPi0_D2GGUnTOgfFxiWy_1Wg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:qCmfXhYyMegQTQ91sCGCpR2SJyqEZ-goaKNiTXXvBI5_Oxxv2vxDbw>
    <xmx:qCmfXrX57RDXv48pwczCKaWzHE56XyfqLclg-jRupuhIK1hYrFzFhg>
    <xmx:qCmfXnVXVlEnT9R37UFc6htIagpZMuhrZm24yARTdEO5ewwdQYG5IA>
    <xmx:qCmfXlBUqYHIlNLzrtE7NnqjMORM1Huxb1dk0VA1AaVIvsExzrEvaA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B26D1328006A;
        Tue, 21 Apr 2020 13:13:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/Hyper-V: Report crash data in die() when panic_on_oops is" failed to apply to 4.19-stable tree
To:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:13:10 +0200
Message-ID: <1587489190114108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From f3a99e761efa616028b255b4de58e9b5b87c5545 Mon Sep 17 00:00:00 2001
From: Tianyu Lan <Tianyu.Lan@microsoft.com>
Date: Mon, 6 Apr 2020 08:53:31 -0700
Subject: [PATCH] x86/Hyper-V: Report crash data in die() when panic_on_oops is
 set

When oops happens with panic_on_oops unset, the oops
thread is killed by die() and system continues to run.
In such case, guest should not report crash register
data to host since system still runs. Check panic_on_oops
and return directly in hyperv_report_panic() when the function
is called in the die() and panic_on_oops is unset. Fix it.

Fixes: 7ed4325a44ea ("Drivers: hv: vmbus: Make panic reporting to be more useful")
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-7-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index b0da5320bcff..624f5d9b0f79 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/hyperv.h>
 #include <linux/slab.h>
+#include <linux/kernel.h>
 #include <linux/cpuhotplug.h>
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
@@ -419,11 +420,14 @@ void hyperv_cleanup(void)
 }
 EXPORT_SYMBOL_GPL(hyperv_cleanup);
 
-void hyperv_report_panic(struct pt_regs *regs, long err)
+void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die)
 {
 	static bool panic_reported;
 	u64 guest_id;
 
+	if (in_die && !panic_on_oops)
+		return;
+
 	/*
 	 * We prefer to report panic on 'die' chain as we have proper
 	 * registers to report, but if we miss it (e.g. on BUG()) we need
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 172ceae69abb..a68bce4d0ddb 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -31,6 +31,7 @@
 #include <linux/kdebug.h>
 #include <linux/efi.h>
 #include <linux/random.h>
+#include <linux/kernel.h>
 #include <linux/syscore_ops.h>
 #include <clocksource/hyperv_timer.h>
 #include "hyperv_vmbus.h"
@@ -75,7 +76,7 @@ static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
 	    && hyperv_report_reg()) {
 		regs = current_pt_regs();
-		hyperv_report_panic(regs, val);
+		hyperv_report_panic(regs, val, false);
 	}
 	return NOTIFY_DONE;
 }
@@ -92,7 +93,7 @@ static int hyperv_die_event(struct notifier_block *nb, unsigned long val,
 	 * the notification here.
 	 */
 	if (hyperv_report_reg())
-		hyperv_report_panic(regs, val);
+		hyperv_report_panic(regs, val, true);
 	return NOTIFY_DONE;
 }
 
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index b3f1082cc435..1c4fd950f091 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -163,7 +163,7 @@ static inline int cpumask_to_vpset(struct hv_vpset *vpset,
 	return nr_bank;
 }
 
-void hyperv_report_panic(struct pt_regs *regs, long err);
+void hyperv_report_panic(struct pt_regs *regs, long err, bool in_die);
 void hyperv_report_panic_msg(phys_addr_t pa, size_t size);
 bool hv_is_hyperv_initialized(void);
 bool hv_is_hibernation_supported(void);

