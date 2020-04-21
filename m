Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42941B2E23
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgDURTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:19:00 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:57457 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726335AbgDURS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:18:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D4F9A194132C;
        Tue, 21 Apr 2020 13:11:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=FEzw8o
        FByh0zlGOQ1TICAds9Ia3a3yxP8FdYdMRq3+g=; b=uLPCyVivXRPxvSOu6nfggu
        xYglleukllZY87WC1RjcMEA+kEoyhv0Vgne0wyZvQ8C7r+o+trYpXyvXGyljCgry
        VdisUNQP9AumkjLYrOb4DDHvCzBvsFoM3ZjboRI4twacz1Mr+uZVSPvkfmYnwdUy
        wkTFXynEEh6nOca0FmQYX/2tS9xeiXgFuv9uNqZPCnGyHf1WHGD6WFrE5c1nJWNM
        40LWKPMDqpKhwx+8uKlNgxdbkNp67Z75yxNCmUoBdL2S/YmeWLLsC4VjJM6mUUfW
        GmdSSr2I380geup7joE9GWNig2EbA9NJeGL0hJXml0Xkhb016nDsfxcgsbbVkRdw
        ==
X-ME-Sender: <xms:WymfXkgreg6lymlc9hsqAVaigS_TjPvsYkxbDqlUCbfuT2zzWhv50g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:WymfXiDN2GReHuI6v-zavEsHZJx3U9Jus3IGwrvICAnGDQUZy7Dtyw>
    <xmx:WymfXm9hk6vzR338udQrCby6gmzBxLQKMu5tjqxBR1UWRb_1xzfM4g>
    <xmx:WymfXph6nVNshdkDotnbuFUzaSwb8eWSsX2hASrxLMsOGFdejCguEQ>
    <xmx:WymfXotVPpn0YMND3eCXYoKWOzChQBcF4iutzh3EFOIFueK-uMOn1A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 72B213065C8E;
        Tue, 21 Apr 2020 13:11:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/Hyper-V: Free hv_panic_page when fail to register kmsg" failed to apply to 5.4-stable tree
To:     Tianyu.Lan@microsoft.com, mikelley@microsoft.com,
        wei.liu@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:11:46 +0200
Message-ID: <1587489106146185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

