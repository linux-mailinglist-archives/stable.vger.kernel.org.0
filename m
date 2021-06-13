Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037743A580F
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhFMLuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:50:05 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:34099 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMLuF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:50:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B07B111E7;
        Sun, 13 Jun 2021 07:48:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 13 Jun 2021 07:48:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IYObEF
        aP6eepHRGwvh1F1etSwMV04aQz05xNSGs53gQ=; b=n3JffHaho/IC+SOH5uxpay
        Hxsk/QwwpmfiEioaVzojErYK0HJItNj3g2i+Z5hb0yAOfc4abXD3nKk7wzRlPMXP
        enxdhDJAaDIxbmMpWJk/ZN4TKNh20YV5y/ujJSNviE++jh1xMwHNNytC2h/1QP3X
        sIuahWOPoY8Z+d4wdkg5zAZHmIuDJNJYXOFKQXnLpLEsU37dXYqAP5RFQDhRiP1i
        y/ySoi7prIEc0F4s91Oy8Zk41isOADVrve8rqtwv+y3nBJQIfVJ/XkhDbdXwPEFq
        ZHySzmJg3UqGNyaoeJ+XU0yMqNjWMlTkymJY2PbZhi/dv+n7J9HoD+vR/OHo44Gg
        ==
X-ME-Sender: <xms:cvDFYDgcj2Pv_qPLbsI051J2l9RK6Tqy8qsifH4OI9fbn96PLiaQnw>
    <xme:cvDFYABw39KwZHA0-YcuWMpjV8_9lk-zcVkL_Bdd3GdtWKHHCvQL7JfDX505dIpRA
    GOall371A8U6Q>
X-ME-Received: <xmr:cvDFYDEII7_mT6alu3PE9Hli1jT5w7_pdl458po3eUBqNBqQIUPOoBLHLqHP7IuoPDISEiH-TPcOkZO7oKHBsYQj_EEgIkr2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:cvDFYATvVSv6__WFHTQDF4mnJImsQB4AaaUjEnPIuW4_eNAN5-qRUA>
    <xmx:cvDFYAwhSLR555qbwx3Godyh8xUrmb02vpxKdNrbQDNmUGrY2qu9lQ>
    <xmx:cvDFYG52XfC3wBsiBiIo46BIypHILVYjZ-Tt3VNSPFwu-zOJ02mDBg>
    <xmx:c_DFYKvQFmfP0HfhVARbaody7roUUPzr9GNLl0DWLHw7PIjDyaETuZzrsl8>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:48:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bus: mhi: pci-generic: Fix hibernation" failed to apply to 5.10-stable tree
To:     loic.poulain@linaro.org, gregkh@linuxfoundation.org,
        manivannan.sadhasivam@linaro.org, stable@vger.kernel.org,
        wsj20369@163.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:48:00 +0200
Message-ID: <162358488089203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5f0c2ee1fe8de700dd0d1cdc63e1a7338e2d3a3d Mon Sep 17 00:00:00 2001
From: Loic Poulain <loic.poulain@linaro.org>
Date: Sun, 6 Jun 2021 21:07:41 +0530
Subject: [PATCH] bus: mhi: pci-generic: Fix hibernation

This patch fixes crash after resuming from hibernation. The issue
occurs when mhi stack is builtin and so part of the 'restore-kernel',
causing the device to be resumed from 'restored kernel' with a no
more valid context (memory mappings etc...) and leading to spurious
crashes.

This patch fixes the issue by implementing proper freeze/restore
callbacks.

Link: https://lore.kernel.org/r/1622571445-4505-1-git-send-email-loic.poulain@linaro.org
Reported-by: Shujun Wang <wsj20369@163.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210606153741.20725-4-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 0a6619ad292c..b3357a8a2fdb 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -935,9 +935,43 @@ static int __maybe_unused mhi_pci_resume(struct device *dev)
 	return ret;
 }
 
+static int __maybe_unused mhi_pci_freeze(struct device *dev)
+{
+	struct mhi_pci_device *mhi_pdev = dev_get_drvdata(dev);
+	struct mhi_controller *mhi_cntrl = &mhi_pdev->mhi_cntrl;
+
+	/* We want to stop all operations, hibernation does not guarantee that
+	 * device will be in the same state as before freezing, especially if
+	 * the intermediate restore kernel reinitializes MHI device with new
+	 * context.
+	 */
+	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
+		mhi_power_down(mhi_cntrl, false);
+		mhi_unprepare_after_power_down(mhi_cntrl);
+	}
+
+	return 0;
+}
+
+static int __maybe_unused mhi_pci_restore(struct device *dev)
+{
+	struct mhi_pci_device *mhi_pdev = dev_get_drvdata(dev);
+
+	/* Reinitialize the device */
+	queue_work(system_long_wq, &mhi_pdev->recovery_work);
+
+	return 0;
+}
+
 static const struct dev_pm_ops mhi_pci_pm_ops = {
 	SET_RUNTIME_PM_OPS(mhi_pci_runtime_suspend, mhi_pci_runtime_resume, NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(mhi_pci_suspend, mhi_pci_resume)
+#ifdef CONFIG_PM_SLEEP
+	.suspend = mhi_pci_suspend,
+	.resume = mhi_pci_resume,
+	.freeze = mhi_pci_freeze,
+	.thaw = mhi_pci_restore,
+	.restore = mhi_pci_restore,
+#endif
 };
 
 static struct pci_driver mhi_pci_driver = {

