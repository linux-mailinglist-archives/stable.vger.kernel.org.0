Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45AC2205180
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 13:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732604AbgFWL6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 07:58:45 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:37913 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732600AbgFWL6p (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 23 Jun 2020 07:58:45 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id BE6A6A3E;
        Tue, 23 Jun 2020 07:58:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 07:58:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xLvwAI
        JIE7G0KOECRP+d2sWkfo5KCq0ThB4uaE3FbpY=; b=ZzkySH2QRIjRGySyyp5pbn
        2TiTBlpEMuwmmpy4xoCyu60Oz1y+azUakytm0lnGryyhmxZAeF9dvcXrEv0uY11T
        AyGm0omb9b6YMH6e+CFSBlB8CzfcrfFOoRzm54NTB3rsfY2HJQSYaDxi8DvjKbID
        voYOyMkGFawnGznn3YvBe1tFgmqaipgviEtb+2AojJcCKJEaJQGp9GidJ3XAOdyD
        9P6/OVo1o4n0vpaxKXv6RJ0EGWTRmwbfnV72sgP0jZl1nWXKDVRWqJNfuHVUouFk
        V1kVdxPwn/TO/qaDcwijbX/yGYYxq6XBBz6cusghCreFiR7S3jxIdHpbduDLlbUw
        ==
X-ME-Sender: <xms:c-7xXr4JiEenaVHnhfJK9gN1EtWwT7LOznuwuXieJ07p9v-qlKYslw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:c-7xXg72yrSFWbs04fZ2APn-0YHWu_fEoKfBuZeqJmFeAeBq1Ug-nw>
    <xmx:c-7xXieww0Mck90TNk6vWsgBcJZC-7vWZtx1FtuCdNg92Nf9vbLrnQ>
    <xmx:c-7xXsJ2bCWfGj237aCSPBj8I9UblirZ0SRVRNIFO81x9zyUXY_vRg>
    <xmx:c-7xXmUaTCoHcnacPHnqtdLbtvS28mI60p_LAl_mNqss-9Fn4nCgHU00dMI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 07F953280060;
        Tue, 23 Jun 2020 07:58:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] e1000e: Do not wake up the system via WOL if device wakeup is" failed to apply to 4.4-stable tree
To:     yu.c.chen@intel.com, Stable@vger.kernel.org,
        aaron.f.brown@intel.com, andriy.shevchenko@linux.intel.com,
        jeffrey.t.kirsher@intel.com, rafael.j.wysocki@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 13:58:30 +0200
Message-ID: <159291351071145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6bf6be1127f7e6d4bf39f84d56854e944d045d74 Mon Sep 17 00:00:00 2001
From: Chen Yu <yu.c.chen@intel.com>
Date: Fri, 22 May 2020 01:59:00 +0800
Subject: [PATCH] e1000e: Do not wake up the system via WOL if device wakeup is
 disabled

Currently the system will be woken up via WOL(Wake On LAN) even if the
device wakeup ability has been disabled via sysfs:
 cat /sys/devices/pci0000:00/0000:00:1f.6/power/wakeup
 disabled

The system should not be woken up if the user has explicitly
disabled the wake up ability for this device.

This patch clears the WOL ability of this network device if the
user has disabled the wake up ability in sysfs.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver")
Reported-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a279f4fa9962..e2ad3f38c75c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6611,11 +6611,17 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
-	u32 ctrl, ctrl_ext, rctl, status;
-	/* Runtime suspend should only enable wakeup for link changes */
-	u32 wufc = runtime ? E1000_WUFC_LNKC : adapter->wol;
+	u32 ctrl, ctrl_ext, rctl, status, wufc;
 	int retval = 0;
 
+	/* Runtime suspend should only enable wakeup for link changes */
+	if (runtime)
+		wufc = E1000_WUFC_LNKC;
+	else if (device_may_wakeup(&pdev->dev))
+		wufc = adapter->wol;
+	else
+		wufc = 0;
+
 	status = er32(STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -6672,7 +6678,7 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 	if (adapter->hw.phy.type == e1000_phy_igp_3) {
 		e1000e_igp3_phy_powerdown_workaround_ich8lan(&adapter->hw);
 	} else if (hw->mac.type >= e1000_pch_lpt) {
-		if (!(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
+		if (wufc && !(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
 			/* ULP does not support wake from unicast, multicast
 			 * or broadcast.
 			 */

