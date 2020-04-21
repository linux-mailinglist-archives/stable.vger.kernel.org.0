Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880DD1B2E26
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgDURTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:19:01 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46683 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729003AbgDURTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:19:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3B05A19415B1;
        Tue, 21 Apr 2020 13:11:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=x2QAZb
        U/+hV651U0wqhU9By4+mQwAnSgJ3mgrWFdFME=; b=D9wpJ6WAme8jZkEkSItjkJ
        uSlI1tAfkK52rltkdlQAnYqGvGMlBQScRcWzSS59wFZMkK6EbxiEcg0BK/9ym601
        9nK6HOnWpRRy3zks4KoFDWUnNJ0LJunZnWqz+f1ukZ0zwXgb0FYSDLFEnI+Q0M9Q
        oIvSopuAlZmAXsuiR2DA7ofRIJQ5aNuH6ly4nJ4+aZHEnpDJid8V2WInRG/iUWUr
        ECE0lypOthQF1LZXsKHNYakKoRsUJQ4eUi+345GFWebcXiUIUfCYgg6vLFKdkizM
        5q5xIYCSr2pAUb9KOlw6008OLqtIFslOygjVc9BRjQyCggbkHarX5hzmGlLJyZ/Q
        ==
X-ME-Sender: <xms:QSmfXoR9wf8LkP_mPABM5v84HUPID6Q8Buj9uW2cXW1prqAlwwqXHA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:QSmfXtc4nBf-Cr5KiJ9ZUjrqPlhMw69QHWpSFpofBqsbkUWpAUa1zQ>
    <xmx:QSmfXrrzZ4YzgrexCB6cY1MtQ8ZSlGy6LDk2lNlCpOO4Ya5mOrjfUg>
    <xmx:QSmfXtYkhnVNdBHECd3l8Xt_MLbkAk4G_QDBsvadhAuk_foHtJx4WQ>
    <xmx:QimfXuXfDYhAG42C_TC-rGklkJ2q-9sMU3Tk54w-_W7tNQ1SLTHGQQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 268913065C8E;
        Tue, 21 Apr 2020 13:11:29 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/Hyper-V: Unload vmbus channel in hv panic callback" failed to apply to 4.19-stable tree
To:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:11:27 +0200
Message-ID: <158748908722690@kroah.com>
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

From 74347a99e73ae00b8385f1209aaea193c670f901 Mon Sep 17 00:00:00 2001
From: Tianyu Lan <Tianyu.Lan@microsoft.com>
Date: Mon, 6 Apr 2020 08:53:26 -0700
Subject: [PATCH] x86/Hyper-V: Unload vmbus channel in hv panic callback

When kdump is not configured, a Hyper-V VM might still respond to
network traffic after a kernel panic when kernel parameter panic=0.
The panic CPU goes into an infinite loop with interrupts enabled,
and the VMbus driver interrupt handler still works because the
VMbus connection is unloaded only in the kdump path.  The network
responses make the other end of the connection think the VM is
still functional even though it has panic'ed, which could affect any
failover actions that should be taken.

Fix this by unloading the VMbus connection during the panic process.
vmbus_initiate_unload() could then be called twice (e.g., by
hyperv_panic_event() and hv_crash_handler(), so reset the connection
state in vmbus_initiate_unload() to ensure the unload is done only
once.

Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-2-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 0370364169c4..501c43c5851d 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -839,6 +839,9 @@ void vmbus_initiate_unload(bool crash)
 {
 	struct vmbus_channel_message_header hdr;
 
+	if (xchg(&vmbus_connection.conn_state, DISCONNECTED) == DISCONNECTED)
+		return;
+
 	/* Pre-Win2012R2 hosts don't support reconnect */
 	if (vmbus_proto_version < VERSION_WIN8_1)
 		return;
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 029378c27421..6478240d11ab 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -53,9 +53,12 @@ static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 {
 	struct pt_regs *regs;
 
-	regs = current_pt_regs();
+	vmbus_initiate_unload(true);
 
-	hyperv_report_panic(regs, val);
+	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
+		regs = current_pt_regs();
+		hyperv_report_panic(regs, val);
+	}
 	return NOTIFY_DONE;
 }
 
@@ -1391,10 +1394,16 @@ static int vmbus_bus_init(void)
 		}
 
 		register_die_notifier(&hyperv_die_block);
-		atomic_notifier_chain_register(&panic_notifier_list,
-					       &hyperv_panic_block);
 	}
 
+	/*
+	 * Always register the panic notifier because we need to unload
+	 * the VMbus channel connection to prevent any VMbus
+	 * activity after the VM panics.
+	 */
+	atomic_notifier_chain_register(&panic_notifier_list,
+			       &hyperv_panic_block);
+
 	vmbus_request_offers();
 
 	return 0;
@@ -2204,8 +2213,6 @@ static int vmbus_bus_suspend(struct device *dev)
 
 	vmbus_initiate_unload(false);
 
-	vmbus_connection.conn_state = DISCONNECTED;
-
 	/* Reset the event for the next resume. */
 	reinit_completion(&vmbus_connection.ready_for_resume_event);
 
@@ -2289,7 +2296,6 @@ static void hv_kexec_handler(void)
 {
 	hv_stimer_global_cleanup();
 	vmbus_initiate_unload(false);
-	vmbus_connection.conn_state = DISCONNECTED;
 	/* Make sure conn_state is set as hv_synic_cleanup checks for it */
 	mb();
 	cpuhp_remove_state(hyperv_cpuhp_online);
@@ -2306,7 +2312,6 @@ static void hv_crash_handler(struct pt_regs *regs)
 	 * doing the cleanup for current CPU only. This should be sufficient
 	 * for kdump.
 	 */
-	vmbus_connection.conn_state = DISCONNECTED;
 	cpu = smp_processor_id();
 	hv_stimer_cleanup(cpu);
 	hv_synic_disable_regs(cpu);

