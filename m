Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC262D994D
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 14:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408059AbgLNN5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 08:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403852AbgLNN5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 08:57:17 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EB6C0613CF
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 05:56:36 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id e25so15345871wme.0
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 05:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=JeRGzMYkfrgcAX+72iJ7MD90GdmocGOA9ult9kTbgXo=;
        b=uykiUM4c51UpeP/Rd99iKB9CoOUahJTv81dH5JtH0u0J8iQgMAlpoDZcQHAap2qqlB
         BcI8rqm8WrSHqDU+c2wd8KC42HpEIGc65imT/YHKWY6KqvhGG90WB01RpFWHLg0T5kad
         QlJoTjS8fr/qSxaZAfqj9ykK9fVs28WW6xNHueH2c6qe9jJV5bdC7TWd0kYWJDZ6MF1p
         x5LZUJ2zWV01eNJry9YqleguoxohPpfW32LXDl3EjI9W1RYCZOcXrbyjOzmJRPqLEvDS
         V5w8oRYKxJNZ7+HdAIfRB7yaAqnVulTB8XNMdlNG6WfTUetPlEB4CTOi5GWL0RROpwJo
         NL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=JeRGzMYkfrgcAX+72iJ7MD90GdmocGOA9ult9kTbgXo=;
        b=q/9E80d+7OuYTC8+aa4fuEBRyAl03fvSzOXm8KcsJFdgssLzkgjXjyMKut3UUF/Z42
         h9607fuqZSHOuHFCXogZxHEK55pKPT7gs0+7ezRtl3Sc/f/ym5zZ2L7e1LiOP0Nb70pN
         YkGLQ13wE6XFBGpE1BpBVOyar7c0zlqhEkOUlO2J9xWv4dC2i/hV2/LcCzpVa2dw5cdo
         jNhSeqmQT0oxareFWisRu1SVf68SWef6tl9t+rh4L22S51MV0gG4iwOKXMGlKwWnXpgB
         JCnDj/RNsGKDMvQ/zxYuhm3sWk2SzAosc4RodbyZxNQwuWC+KF8NGuWwZt0ZJCpfy52b
         E+EA==
X-Gm-Message-State: AOAM533eNoE2CejQGCBeuubK0UaYexSl6WfoFxPVZ8L8XfKsgZ5dNbN+
        qf53oC1jFnHNRlf8da5HExnna2EIiFLZLw==
X-Google-Smtp-Source: ABdhPJyNzGGEfqgTA6hYPj1ezlbXoNUq/uNRqJlYga84/fFqddI2NTaFrSiEtnGD4ft+quqOWaeK6g==
X-Received: by 2002:a7b:c8c5:: with SMTP id f5mr28017430wml.106.1607954195359;
        Mon, 14 Dec 2020 05:56:35 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id s205sm31997374wmf.46.2020.12.14.05.56.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 14 Dec 2020 05:56:34 -0800 (PST)
Date:   Mon, 14 Dec 2020 13:56:32 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sashal@kernel.org
Cc:     stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Octavian Purdila <octavian.purdila@intel.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Mark Brown <broonie@kernel.org>
Subject: request for 4.9-stable and 4.4-stable: ddf75be47ca7 ("spi: Prevent
 adding devices below an unregistering controller")
Message-ID: <20201214135632.2qt4rokovnxjoujj@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vice3opgpb7xv5qi"
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--vice3opgpb7xv5qi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg, Sasha,

This was missing in 4.9-stable and 4.4-stable. Please apply to your queue.


--
Regards
Sudip

--vice3opgpb7xv5qi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-spi-Prevent-adding-devices-below-an-unregistering-co.patch"

From dd91772b0a8523e9f3d24b60dcb8f005ab62aba6 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 3 Aug 2020 13:09:01 +0200
Subject: [PATCH] spi: Prevent adding devices below an unregistering controller

commit ddf75be47ca748f8b12d28ac64d624354fddf189 upstream

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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/spi/Kconfig |  3 +++
 drivers/spi/spi.c   | 21 ++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index b7995474148c..e9576658ff3f 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -763,4 +763,7 @@ endif # SPI_MASTER
 
 # (slave support would go here)
 
+config SPI_DYNAMIC
+	def_bool ACPI || OF_DYNAMIC || SPI_SLAVE
+
 endif # SPI
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index e0632ee1723b..f0ba5eb26128 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -422,6 +422,12 @@ static LIST_HEAD(spi_master_list);
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
  * @master: Controller to which device is connected
@@ -500,7 +506,6 @@ static int spi_dev_check(struct device *dev, void *data)
  */
 int spi_add_device(struct spi_device *spi)
 {
-	static DEFINE_MUTEX(spi_add_lock);
 	struct spi_master *master = spi->master;
 	struct device *dev = master->dev.parent;
 	int status;
@@ -529,6 +534,13 @@ int spi_add_device(struct spi_device *spi)
 		goto done;
 	}
 
+	/* Controller may unregister concurrently */
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC) &&
+	    !device_is_registered(&master->dev)) {
+		status = -ENODEV;
+		goto done;
+	}
+
 	if (master->cs_gpios)
 		spi->cs_gpio = master->cs_gpios[spi->chip_select];
 
@@ -2070,6 +2082,10 @@ static int __unregister(struct device *dev, void *null)
  */
 void spi_unregister_master(struct spi_master *master)
 {
+	/* Prevent addition of new devices, unregister existing ones */
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
+		mutex_lock(&spi_add_lock);
+
 	device_for_each_child(&master->dev, NULL, __unregister);
 
 	if (master->queued) {
@@ -2089,6 +2105,9 @@ void spi_unregister_master(struct spi_master *master)
 	if (!devres_find(master->dev.parent, devm_spi_release_master,
 			 devm_spi_match_master, master))
 		put_device(&master->dev);
+
+	if (IS_ENABLED(CONFIG_SPI_DYNAMIC))
+		mutex_unlock(&spi_add_lock);
 }
 EXPORT_SYMBOL_GPL(spi_unregister_master);
 
-- 
2.11.0


--vice3opgpb7xv5qi--
