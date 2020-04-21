Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445E71B2DD8
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgDURMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:12:07 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:39073 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgDURMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:12:06 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Apr 2020 13:12:06 EDT
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6B815194193F;
        Tue, 21 Apr 2020 13:12:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=oWhoOk
        vOyXSwBc+CDWSSGhB3+WQF/d9UO77LKa9ncaA=; b=pUgVRYWUKUqdHRUeYGgVEM
        QT444p7YCeKhDpbrijLb56XxsDbDV8ro3lRnekoZezRAW18Ui0wEmIlJKIBAYDpP
        nnLX0VVcaPAj0uTOS/LTZj9rgpveikM9uQKZGm9+2zCOBWXKKTsfmoHBuwPed0B+
        gdW/EivzGHAXGVEkElQLPIPh1Ifrk0HTZzevp4y4L76iyfxkdHjnQsZJOWggOKGF
        jX4NbX6rFvGTnz71Ibjek74uSaJWBQ/+6Eli56ED7+ps+RZJgFzCpUSPNbFhw/na
        qwYp2uqg7MCew0zAkh9rykdj3zd+vkBYineq7n8PYaLY4QEyOpFzF8zNKhhzJnQQ
        ==
X-ME-Sender: <xms:ZSmfXlaUKyDSIFIhRdALCpCsyVLYh7YHGMZzl4Z8lOCsza5x-_Ro6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ZSmfXsOJU9FdnmZ9tvUmEfsd-ppFaBi_4UwstVLj-_OHew60qQtBlA>
    <xmx:ZSmfXqhhTdX93ZADCyAPzmATo0dlxOuGMvfAOeAfjhFeo87NnFQNtw>
    <xmx:ZSmfXgPdl3XHiiq9xtSK2F-5y_RVRQu3zCkb-QUhMdA1fniN093hXQ>
    <xmx:ZSmfXha-tvj3IJTogo9OK2uM1AHz2XA-qDmxfkluRu_4hooynA5oQA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 05735328006F;
        Tue, 21 Apr 2020 13:12:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/Hyper-V: Trigger crash enlightenment only once during" failed to apply to 4.19-stable tree
To:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:12:03 +0200
Message-ID: <1587489123120108@kroah.com>
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

From 73f26e526f19afb3a06b76b970a76bcac2cafd05 Mon Sep 17 00:00:00 2001
From: Tianyu Lan <Tianyu.Lan@microsoft.com>
Date: Mon, 6 Apr 2020 08:53:28 -0700
Subject: [PATCH] x86/Hyper-V: Trigger crash enlightenment only once during
 system crash.

When a guest VM panics, Hyper-V should be notified only once via the
crash synthetic MSRs.  Current Linux code might write these crash MSRs
twice during a system panic:
1) hyperv_panic/die_event() calling hyperv_report_panic()
2) hv_kmsg_dump() calling hyperv_report_panic_msg()

Fix this by not calling hyperv_report_panic() if a kmsg dump has been
successfully registered.  The notification will happen later via
hyperv_report_panic_msg().

Fixes: 7ed4325a44ea ("Drivers: hv: vmbus: Make panic reporting to be more useful")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-4-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 00a511f15926..333dad39b1c1 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -55,7 +55,13 @@ static int hyperv_panic_event(struct notifier_block *nb, unsigned long val,
 
 	vmbus_initiate_unload(true);
 
-	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
+	/*
+	 * Hyper-V should be notified only once about a panic.  If we will be
+	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
+	 * the notification here.
+	 */
+	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE
+	    && !hv_panic_page) {
 		regs = current_pt_regs();
 		hyperv_report_panic(regs, val);
 	}
@@ -68,7 +74,13 @@ static int hyperv_die_event(struct notifier_block *nb, unsigned long val,
 	struct die_args *die = (struct die_args *)args;
 	struct pt_regs *regs = die->regs;
 
-	hyperv_report_panic(regs, val);
+	/*
+	 * Hyper-V should be notified only once about a panic.  If we will be
+	 * doing hyperv_report_panic_msg() later with kmsg data, don't do
+	 * the notification here.
+	 */
+	if (!hv_panic_page)
+		hyperv_report_panic(regs, val);
 	return NOTIFY_DONE;
 }
 

