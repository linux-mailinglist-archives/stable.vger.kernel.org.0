Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85BE1B2DD9
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgDURMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:12:53 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:42593 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgDURMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:12:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id AF18E19422FE;
        Tue, 21 Apr 2020 13:12:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:12:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cWIJ7R
        RkQlIQETYAytZrABETqjaVcGzO5RFL1ziNPJM=; b=tAFQDFuDiZ/twTPUCNNruW
        xuEEMvynoHRFKkUZwk1zHscWLpbeBw7raPu4L6H3TbaSzN21NxvhWMNEOlJBdz/J
        +a46Sq7CpAbUOGwof9w43G+rjWezZXzlD7yXlRWVdAnSiD5HMg473IrJaA9Z1zJL
        MZqlObefE1C2hPO6SplKnF6QPhDS7Q1ckaqfJHcHNLo8/7gxhs3EGcZCCsiVnaSx
        w7ml+cjm2zp2ScqhypjGGhy0LyerPji5EaHJKK6faOIWu/qyvBgWhP1issG3HJer
        DEtdgiI2Y+S0S3xjIWHBQwEPtqLyeWiTTzeIlLElspjPOS+OJ4nLIaFps9ag7org
        ==
X-ME-Sender: <xms:kymfXrHWUcv5si9MrHRWWvmkY4chv6DoQChjrHvjxHDY-9Q5WznM3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:kymfXslkDCOugoPsvpgcyUTLY1qZZGE8X4K_4o6bgVIzsGqd1x0nrA>
    <xmx:kymfXoJsygcIQnbWm0RSSEv7zwGUmRNqYcE2_nArjV_QCeJD-pARag>
    <xmx:kymfXtYIhAH-64J-NF015BIRu1FCqQ-_lfxA_7r5cXn-O8gWygLhDw>
    <xmx:kymfXn3s7q620TOYQmNA75EBjm1MgGDsWpgN2qRMTllJ0_AoA0DHAA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2AC643065C73;
        Tue, 21 Apr 2020 13:12:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/Hyper-V: Report crash register data when" failed to apply to 4.19-stable tree
To:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:12:49 +0200
Message-ID: <158748916921284@kroah.com>
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

From 040026df7088c56ccbad28f7042308f67bde63df Mon Sep 17 00:00:00 2001
From: Tianyu Lan <Tianyu.Lan@microsoft.com>
Date: Mon, 6 Apr 2020 08:53:30 -0700
Subject: [PATCH] x86/Hyper-V: Report crash register data when
 sysctl_record_panic_msg is not set

When sysctl_record_panic_msg is not set, the panic will
not be reported to Hyper-V via hyperv_report_panic_msg().
So the crash should be reported via hyperv_report_panic().

Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-6-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 333dad39b1c1..172ceae69abb 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -48,6 +48,18 @@ static int hyperv_cpuhp_online;
 
 static void *hv_panic_page;
 
+/*
+ * Boolean to control whether to report panic messages over Hyper-V.
+ *
+ * It can be set via /proc/sys/kernel/hyperv/record_panic_msg
+ */
+static int sysctl_record_panic_msg = 1;
+
+static int hyperv_report_reg(void)
+{
+	return !sysctl_record_panic_msg || !hv_panic_page;
+}
+
 static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 			      void *args)
 {
@@ -61,7 +73,7 @@ static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 	 * the notification here.
 	 */
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
-	    && !hv_panic_page) {
+	    && hyperv_report_reg()) {
 		regs = current_pt_regs();
 		hyperv_report_panic(regs, val);
 	}
@@ -79,7 +91,7 @@ static int hyperv_die_event(struct notifier_block *nb, unsigned long val,
 	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
 	 * the notification here.
 	 */
-	if (!hv_panic_page)
+	if (hyperv_report_reg())
 		hyperv_report_panic(regs, val);
 	return NOTIFY_DONE;
 }
@@ -1267,13 +1279,6 @@ static void vmbus_isr(void)
 	add_interrupt_randomness(HYPERVISOR_CALLBACK_VECTOR, 0);
 }
 
-/*
- * Boolean to control whether to report panic messages over Hyper-V.
- *
- * It can be set via /proc/sys/kernel/hyperv/record_panic_msg
- */
-static int sysctl_record_panic_msg = 1;
-
 /*
  * Callback from kmsg_dump. Grab as much as possible from the end of the kmsg
  * buffer and call into Hyper-V to transfer the data.

