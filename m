Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA5224ED1E
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgHWMCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:02:37 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:46569 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726090AbgHWMCf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:02:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 79D7419401EB;
        Sun, 23 Aug 2020 08:02:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:02:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=615fsN
        IH9f5GM6cgvxcjz6IkeaWgd+7okYWCXIU8CdE=; b=XrFe4FXxWTR4GqztqDVqDm
        wKN+qi6o5WomMbTSlqGvFJFPCYSM9cQyP3ArNZDN43ci8jGS3frLA/ORp4h2zdNS
        4uwvzYqpTub1gVFzXNl4Bzx8at0Ep+rz24JRe1gP4PR9eh00eDHrPx8TJ+UDOH7P
        OCuf6qxLG98j7oJYUXZGQwAzH2kbywuhKD/atjlar/VBHCEL5DuW3uxHPC60PS6h
        s+blETXk5YTg8VQlxBxmOxrdiyk/P/uR4ZMv6DcVTh/X9S3ug1CDE8Jzbht84BhO
        PxohPcUDzrzHFVmJ2/nEUtmW/sP6TmWpXn4q1v1hbF/jUqM2ywGK5uw7dg/KrBjg
        ==
X-ME-Sender: <xms:2VpCX94gz085fhegmiEJlLE3ExsHXcdLBXGAQz3pqIelDn5UwlFUog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2VpCX66OVisE7XgxyVV5wVVA_-09AHsNOwofllT_p_YaGVw25U0Pyg>
    <xmx:2VpCX0ds05ttK7jCzmI5eTvLCMo4Ko7xl10G-zai-vmQKpIwU0j0oA>
    <xmx:2VpCX2JQpPQOdB272eht_irIUJL4dB9xNwRrC1Hc1o8zfW0E5kkdZQ>
    <xmx:2lpCX4WHsZGrxg0KiVCqFHmIXqjCDGotXcUKADRkY_0lr6_BVNU0mw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 407A5328005A;
        Sun, 23 Aug 2020 08:02:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: Prevent adding devices below an unregistering controller" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, broonie@kernel.org, geert+renesas@glider.be,
        octavian.purdila@intel.com, pantelis.antoniou@konsulko.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:02:53 +0200
Message-ID: <1598184173156139@kroah.com>
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

From ddf75be47ca748f8b12d28ac64d624354fddf189 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 3 Aug 2020 13:09:01 +0200
Subject: [PATCH] spi: Prevent adding devices below an unregistering controller

CONFIG_OF_DYNAMIC and CONFIG_ACPI allow adding SPI devices at runtime
using a DeviceTree overlay or DSDT patch.  CONFIG_SPI_SLAVE allows the
same via sysfs.

But there are no precautions to prevent adding a device below a
controller that's being removed.  Such a device is unusable and may not
even be able to unbind cleanly as it becomes inaccessible once the
controller has been torn down.  E.g. it is then impossible to quiesce
the device's interrupt.

of_spi_notify() and acpi_spi_notify() do hold a ref on the controller,
but otherwise run lockless against spi_unregister_controller().

Fix by holding the spi_add_lock in spi_unregister_controller() and
bailing out of spi_add_device() if the controller has been unregistered
concurrently.

Fixes: ce79d54ae447 ("spi/of: Add OF notifier handler")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.19+
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Link: https://lore.kernel.org/r/a8c3205088a969dc8410eec1eba9aface60f36af.1596451035.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index c3008e423f59..c6ea760ea5f0 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -1017,4 +1017,7 @@ config SPI_SLAVE_SYSTEM_CONTROL
 
 endif # SPI_SLAVE
 
+config SPI_DYNAMIC
+	def_bool ACPI || OF_DYNAMIC || SPI_SLAVE
+
 endif # SPI
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 0b260484b4f5..92b8fb416dca 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -475,6 +475,12 @@ static LIST_HEAD(spi_controller_list);
  */
 static DEFINE_MUTEX(board_lock);
 
+/*
+ * Prevents addition of devices with same chip select and
+ * addition of devices below an unregistering controller.
+ */
+static DEFINE_MUTEX(spi_add_lock);
+
 /**
  * spi_alloc_device - Allocate a new SPI device
  * @ctlr: Controller to which device is connected
@@ -554,7 +560,6 @@ static int spi_dev_check(struct device *dev, void *data)
  */
 int spi_add_device(struct spi_device *spi)
 {
-	static DEFINE_MUTEX(spi_add_lock);
 	struct spi_controller *ctlr = spi->controller;
 	struct device *dev = ctlr->dev.parent;
 	int status;
@@ -582,6 +587,13 @@ int spi_add_device(struct spi_device *spi)
 		goto done;
 	}
 
+	/* Controller may unregister concurrently */
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC) &&
+	    !device_is_registered(&ctlr->dev)) {
+		status = -ENODEV;
+		goto done;
+	}
+
 	/* Descriptors take precedence */
 	if (ctlr->cs_gpiods)
 		spi->cs_gpiod = ctlr->cs_gpiods[spi->chip_select];
@@ -2797,6 +2809,10 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 	struct spi_controller *found;
 	int id = ctlr->bus_num;
 
+	/* Prevent addition of new devices, unregister existing ones */
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
+		mutex_lock(&spi_add_lock);
+
 	device_for_each_child(&ctlr->dev, NULL, __unregister);
 
 	/* First make sure that this controller was ever added */
@@ -2817,6 +2833,9 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 	if (found == ctlr)
 		idr_remove(&spi_master_idr, id);
 	mutex_unlock(&board_lock);
+
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
+		mutex_unlock(&spi_add_lock);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_controller);
 

