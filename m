Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35921B2E27
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729003AbgDURTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:19:02 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:42325 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725963AbgDURTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:19:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 702BF1941970;
        Tue, 21 Apr 2020 13:11:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UN/e5m
        AvMv/XCC7FCfQ45R64t+sYWupwcxP9BJmoZnI=; b=j83zj1SGxShjlr2Y0wItf9
        eP3XCtuBtm+UkEDLVsRrZgaupJncMPLbNQfkOLIM/o3giRg5yuPXDf/p5Dui4ubl
        t+6mX+mJsqdq3N81p4Ra0Bg80WvKzUtWLUfzhQXZcWZfPshQlduQYGKCrh5ESWFg
        tc8Is5sktpqlWynwGiCrXgfIs/Luhiwp9rzBCmt+pL3GwoGC2bRvhZWtuBwu3HSX
        FgX20mVatqmR4n3TOd7tgwAbsA8QFokJoSXeGbCw86LrCgXQjRGVuUovS/Ze+YbT
        5YjJQ3EzDzjNeAy9cPRcv2GP0e6vpAIJtquFxZYC/e9uvxEK2nTV46zyPp/cMxjw
        ==
X-ME-Sender: <xms:UymfXp00-6HncdWH-a8N-R_QFqYgfvVghXRpZJqlCaf4s36WBVbI3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UymfXmiwd5WkDTZZWXW9bzFT-BEnOCYllaMpHqLEdIqZea7uG6HjOQ>
    <xmx:UymfXiuf7ebm-ENGPasi3t1kwqTcdKcgYffCf1D2Vih2904IwHDAkQ>
    <xmx:UymfXptMPdodrXSI9FjhRrfeVKZ5j__l192ruSibB8i5lMTlyUCB3g>
    <xmx:UymfXgzdsAUb1u-vF4avgCOQb_p_Mh-OtQy9ISyFMGWZCCdkK8vMKw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DDB13065C73;
        Tue, 21 Apr 2020 13:11:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/Hyper-V: Free hv_panic_page when fail to register kmsg" failed to apply to 4.19-stable tree
To:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:11:46 +0200
Message-ID: <158748910694159@kroah.com>
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

From 7f11a2cc10a4ae3a70e2c73361f4a9a33503539b Mon Sep 17 00:00:00 2001
From: Tianyu Lan <Tianyu.Lan@microsoft.com>
Date: Mon, 6 Apr 2020 08:53:27 -0700
Subject: [PATCH] x86/Hyper-V: Free hv_panic_page when fail to register kmsg
 dump

If kmsg_dump_register() fails, hv_panic_page will not be used
anywhere.  So free and reset it.

Fixes: 81b18bce48af ("Drivers: HV: Send one page worth of kmsg dump over Hyper-V during panic")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
Link: https://lore.kernel.org/r/20200406155331.2105-3-Tianyu.Lan@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 6478240d11ab..00a511f15926 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1385,9 +1385,13 @@ static int vmbus_bus_init(void)
 			hv_panic_page = (void *)hv_alloc_hyperv_zeroed_page();
 			if (hv_panic_page) {
 				ret = kmsg_dump_register(&hv_kmsg_dumper);
-				if (ret)
+				if (ret) {
 					pr_err("Hyper-V: kmsg dump register "
 						"error 0x%x\n", ret);
+					hv_free_hyperv_page(
+					    (unsigned long)hv_panic_page);
+					hv_panic_page = NULL;
+				}
 			} else
 				pr_err("Hyper-V: panic message page memory "
 					"allocation failed");
@@ -1416,7 +1420,6 @@ static int vmbus_bus_init(void)
 	hv_remove_vmbus_irq();
 
 	bus_unregister(&hv_bus);
-	hv_free_hyperv_page((unsigned long)hv_panic_page);
 	unregister_sysctl_table(hv_ctl_table_hdr);
 	hv_ctl_table_hdr = NULL;
 	return ret;

