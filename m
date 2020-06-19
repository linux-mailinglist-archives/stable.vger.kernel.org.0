Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5B1200448
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbgFSIrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:47:05 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:52647 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731369AbgFSIrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 04:47:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8ECDA1944420;
        Fri, 19 Jun 2020 04:47:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 04:47:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=U+uneE
        T4gL1YVIJNvqMaznLXc2PJVtdB7E001sugGSE=; b=ELKfHrqK6uxB+b8lYy6IQS
        C27OXwdXHhtDbwQJFN/vz73cqcV/iKBUEcA7QOUHuifl1n4JNxAzDFE2jDoUdbIQ
        Sztqmj+eQPvaKJ1ZCZ2wIZ/4K67GemnvT2MVTSfBexwS48b0g0xqwHZRtNvoOMRd
        8jmrAJo4tXi5QPPZojt676rIZbPuUcunUZns9DUalHsItgeNjGTbmd4hpDBQlvBp
        4KOMELDB49t6BQQKFRb4I30GbiDRE5lKU8QtrPKC8rr5SRT59jf3Kb1/lvY8YN+l
        Tk47V84Zw22kfwiF4iCYNqdcKcVxvOJrPkf0oCtoU2akFkAiWCSHegCLtNdnKkSw
        ==
X-ME-Sender: <xms:hHvsXi3dtshnhLWKeoFfJD84d0zs4i4tvD2sCnU9LUDuZaPfZNCrmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:hHvsXlG2BPTIMB1u5X1JKiF6fpn-pBw80GCqpj1MN8eTyBDY6gIXdw>
    <xmx:hHvsXq6-2mmRFLxMKXdUSVqOX8exbWICuYKu9qZPORUt_YGbtcwzVg>
    <xmx:hHvsXj3wvopCmCOdfbZFscMmcrUfTsCACneqs3Aezy3IaqWSdKmDdw>
    <xmx:hHvsXkwCUXqeCChzzUA6sMqUJuXj6u7PdjjiwX-iW-W5xQAn0cHVlQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2E21D3280059;
        Fri, 19 Jun 2020 04:47:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Bluetooth: hci_bcm: fix freeing not-requested IRQ" failed to apply to 4.9-stable tree
To:     mirq-linux@rere.qmqm.pl, marcel@holtmann.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 10:46:57 +0200
Message-ID: <159255641715762@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 81bd5d0c62437c02caac6b3f942fcda874063cb0 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Date: Thu, 2 Apr 2020 14:55:20 +0200
Subject: [PATCH] Bluetooth: hci_bcm: fix freeing not-requested IRQ
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When BT module can't be initialized, but it has an IRQ, unloading
the driver WARNs when trying to free not-yet-requested IRQ. Fix it by
noting whether the IRQ was requested.

WARNING: CPU: 2 PID: 214 at kernel/irq/devres.c:144 devm_free_irq+0x49/0x4ca
[...]
WARNING: CPU: 2 PID: 214 at kernel/irq/manage.c:1746 __free_irq+0x8b/0x27c
Trying to free already-free IRQ 264
Modules linked in: hci_uart(-) btbcm bluetooth ecdh_generic ecc libaes
CPU: 2 PID: 214 Comm: rmmod Tainted: G        W         5.6.1mq-00044-ga5f9ea098318-dirty #928
[...]
[<b016aefb>] (devm_free_irq) from [<af8ba1ff>] (bcm_close+0x97/0x118 [hci_uart])
[<af8ba1ff>] (bcm_close [hci_uart]) from [<af8b736f>] (hci_uart_unregister_device+0x33/0x3c [hci_uart])
[<af8b736f>] (hci_uart_unregister_device [hci_uart]) from [<b035930b>] (serdev_drv_remove+0x13/0x20)
[<b035930b>] (serdev_drv_remove) from [<b037093b>] (device_release_driver_internal+0x97/0x118)
[<b037093b>] (device_release_driver_internal) from [<b0370a0b>] (driver_detach+0x2f/0x58)
[<b0370a0b>] (driver_detach) from [<b036f855>] (bus_remove_driver+0x41/0x94)
[<b036f855>] (bus_remove_driver) from [<af8ba8db>] (bcm_deinit+0x1b/0x740 [hci_uart])
[<af8ba8db>] (bcm_deinit [hci_uart]) from [<af8ba86f>] (hci_uart_exit+0x13/0x30 [hci_uart])
[<af8ba86f>] (hci_uart_exit [hci_uart]) from [<b01900bd>] (sys_delete_module+0x109/0x1d0)
[<b01900bd>] (sys_delete_module) from [<b0101001>] (ret_fast_syscall+0x1/0x5a)
[...]

Cc: stable@vger.kernel.org
Fixes: 6cc4396c8829 ("Bluetooth: hci_bcm: Add wake-up capability")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

diff --git a/drivers/bluetooth/hci_bcm.c b/drivers/bluetooth/hci_bcm.c
index 36b7f0d00c4b..19e4587f366c 100644
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -118,6 +118,7 @@ struct bcm_device {
 	u32			oper_speed;
 	int			irq;
 	bool			irq_active_low;
+	bool			irq_acquired;
 
 #ifdef CONFIG_PM
 	struct hci_uart		*hu;
@@ -333,6 +334,8 @@ static int bcm_request_irq(struct bcm_data *bcm)
 		goto unlock;
 	}
 
+	bdev->irq_acquired = true;
+
 	device_init_wakeup(bdev->dev, true);
 
 	pm_runtime_set_autosuspend_delay(bdev->dev,
@@ -514,7 +517,7 @@ static int bcm_close(struct hci_uart *hu)
 	}
 
 	if (bdev) {
-		if (IS_ENABLED(CONFIG_PM) && bdev->irq > 0) {
+		if (IS_ENABLED(CONFIG_PM) && bdev->irq_acquired) {
 			devm_free_irq(bdev->dev, bdev->irq, bdev);
 			device_init_wakeup(bdev->dev, false);
 			pm_runtime_disable(bdev->dev);

