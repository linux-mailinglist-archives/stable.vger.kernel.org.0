Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E61C249A2E
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgHSKWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:22:38 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:41937 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726702AbgHSKWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:22:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9A3BB1942371;
        Wed, 19 Aug 2020 06:22:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:22:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=W79s/M
        be7FwKNpwRiDx/oGAYX1b9uGXcrQirbH3+hv0=; b=c7SjhRkautHj4LluIuy/P2
        0Pk2GUwA/7KtpwiIqGgQ5XC/95/8XPm7PL3mRCDCWZTnE4F4jkoz5xvkR0dBF/pV
        LQs18FJSWu/S229aIbOQykg+KJ9JZ9kgWFJ+oit0cwAl9a5vjjt45RR0U8iGh4Ss
        VtOLu4Shjr4AW60RJ5rvx7U8d7pz3yWNbEFSG0IcixPA/LqaiiNES+68qxhFfwZp
        ruoRsJtIYfiUXr90iK6+36j8qYhp9BEjtgp6fXhtQsPuWPf6NUhd7xaHqZ6yInW9
        TRNHwVqJMQC0RLiogiHGv4N5XIHuBnkyhMeEg0LX+qnWBDHkdnLsD9Z205wos20g
        ==
X-ME-Sender: <xms:av08Xwh-M1jqFoIp-FbxurSuN012iU4vXKaMXpqport-05VMI9b3VQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:av08X5D1fTjEjEDol1WZXyn_TqDaM-D-ySD7zp-o2GJWhhVFQ3-0NQ>
    <xmx:av08X4FGYXCrFL6lVBEohAGs-nfTcn51dN8-euWLj-r1mHTgPPTA8g>
    <xmx:av08XxRXkmCU9p7iyi6TEj7LIh26ctoaNGMfevbQkrirWrsiijXX2Q>
    <xmx:av08X7ZSRl_j5nKvadMRm1toHaMM3jv9xobHMTJ4xrtaLC3jqTuo1A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D88930600A9;
        Wed, 19 Aug 2020 06:22:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: Add device even if driver attach failed" failed to apply to 4.14-stable tree
To:     rajatja@google.com, bhelgaas@google.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:22:56 +0200
Message-ID: <1597832576184218@kroah.com>
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

From 2194bc7c39610be7cabe7456c5f63a570604f015 Mon Sep 17 00:00:00 2001
From: Rajat Jain <rajatja@google.com>
Date: Mon, 6 Jul 2020 16:32:40 -0700
Subject: [PATCH] PCI: Add device even if driver attach failed

device_attach() returning failure indicates a driver error while trying to
probe the device. In such a scenario, the PCI device should still be added
in the system and be visible to the user.

When device_attach() fails, merely warn about it and keep the PCI device in
the system.

This partially reverts ab1a187bba5c ("PCI: Check device_attach() return
value always").

Link: https://lore.kernel.org/r/20200706233240.3245512-1-rajatja@google.com
Signed-off-by: Rajat Jain <rajatja@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org	# v4.6+

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 8e40b3e6da77..3cef835b375f 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -322,12 +322,8 @@ void pci_bus_add_device(struct pci_dev *dev)
 
 	dev->match_driver = true;
 	retval = device_attach(&dev->dev);
-	if (retval < 0 && retval != -EPROBE_DEFER) {
+	if (retval < 0 && retval != -EPROBE_DEFER)
 		pci_warn(dev, "device attach failed (%d)\n", retval);
-		pci_proc_detach_device(dev);
-		pci_remove_sysfs_dev_files(dev);
-		return;
-	}
 
 	pci_dev_assign_added(dev, true);
 }

