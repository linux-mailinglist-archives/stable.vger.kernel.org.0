Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07215249A2F
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHSKWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:22:52 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:45283 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727817AbgHSKWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 06:22:44 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D9B61194228C;
        Wed, 19 Aug 2020 06:22:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 06:22:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+J/78q
        QpfwL2DtSYSo+pm+C2IAF2z8mZbphd/Z/3BX0=; b=YLL1F3LUya5GYLTQvoiTq8
        oN+ApgkhcOzk26RDDF+Xm+yrg4VBCWFa6oZrGTTLGcMdyrqk9yluEdtL/yyO6Rzk
        5tCWeCs7T82rnyCiIkgpEoiWmpZzTKDu0idAtIhs3gzKM7/NEPuJU0Xv1K8ykfV0
        wuYjMRKbu58q0VifhbHBcw2hJjUtNHeYNiDgiqhMTV9Cyixsaw01ya2XdPfWad0i
        aCzUb0trzDwTMOqoEI+Y0iNsZtpVyc6IQzTay1x3ldJfXuKWhXaBIz1QvuOrLRM+
        d0qSIrwKwP0jzV7Qk+076T0gUUMMxptW0L10EuuF9mFPvnCLAIdRBgidQDnwJ0DA
        ==
X-ME-Sender: <xms:cv08X0Mn6uDfYwswHUlh2J7rUV6JWzgCXLp43WgoiEIUpRqw1qX0Bg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:cv08X68Fs7bYZUxCnE6yt741zwWx3ojknp4E0T3vJDPAthURQ5iFrA>
    <xmx:cv08X7T9CJiEolTLdK5fJ7hB4_HXlfNax7RoSQ8dHz_dGqEqCOjRiw>
    <xmx:cv08X8splw4C1mdbckzetjH48wz2m-TCcJSGvEtItsUkMyJyO1dqcA>
    <xmx:cv08X0mdDM7sdc8Hd7hr0sDI0xO0YAIOqp-PjusV5iWlpwVtCwYO1Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 796C33280060;
        Wed, 19 Aug 2020 06:22:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] PCI: Add device even if driver attach failed" failed to apply to 4.9-stable tree
To:     rajatja@google.com, bhelgaas@google.com, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 12:22:57 +0200
Message-ID: <159783257796182@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

