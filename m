Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B55311F750
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 12:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfLOLEW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 06:04:22 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48133 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726083AbfLOLEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 06:04:22 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 23DCC222C9;
        Sun, 15 Dec 2019 06:04:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 06:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=jQfaRj
        jHYgDQ6sNUAULCnhHnp19WL8tl/t4L+n2S+Hw=; b=ZaKIe1cp9dvfeFw26cHRzC
        X5V16eZ/KO08vqf+zTIHp7qZroO8KcjkwAvTbPQpsVMD1cyzUQmIYhPQfu3Oj+8F
        YNjvtmibYPwS0Tp7E3sbbQU1X6GF7OpqNk1806Dt1tVbmx6kPCfH0kMpYqk6T4qi
        Z9w7arjk/5euQBP9Kk2Ke03zn0afalNzjAJ3GXkg1ArNfQYgZ4tA9XTwdj6vwbUz
        n1UYIilSBPm0Y6GcNAaRGXuqezp0Fiwhmvb7z8x1F/h9iGElflGKBFgDalYWnQFH
        EV+oIxls6tB7xSJKujeNd5dUTwXmTlv+n2AtFRnkiQl6CypI0ut55djr7WjfjtHg
        ==
X-ME-Sender: <xms:NBP2XTH9YvwTdHBhEDQi3wbKwC1cOkwJwHlxOZYiPFFzio5SG3EYgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:NBP2XXtK1FoxDFYCbuiY42KORfoxp5hRacDyRc0DEs3-glpOdSpFPw>
    <xmx:NBP2Xas8gLnOeFQM265QGizTdipTZXg9WDAtXCOHtejOLZ7mF-Jcqg>
    <xmx:NBP2XdBSA1UkWK3zgmxxn2CBsCtgYtuo6Ge8ztLcyQsA5-cstNEl0w>
    <xmx:NRP2XVIuztaZj7q67TPn8-4qVdaZQcmM326VemTHr4akXO0Pz7ml9Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A7118005B;
        Sun, 15 Dec 2019 06:04:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"" failed to apply to 4.14-stable tree
To:     yoshihiro.shimoda.uh@renesas.com, geert+renesas@glider.be,
        kishon@ti.com, pavel@denx.de, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 12:04:16 +0100
Message-ID: <15764078564151@kroah.com>
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

From 4bd5ead82d4b877ebe41daf95f28cda53205b039 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Mon, 7 Oct 2019 16:55:10 +0900
Subject: [PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"

Since the role_store() uses strncmp(), it's possible to refer
out-of-memory if the sysfs data size is smaller than strlen("host").
This patch fixes it by using sysfs_streq() instead of strncmp().

Reported-by: Pavel Machek <pavel@denx.de>
Fixes: 9bb86777fb71 ("phy: rcar-gen3-usb2: add sysfs for usb role swap")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

diff --git a/drivers/phy/renesas/phy-rcar-gen3-usb2.c b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
index 49ec67d46ccc..bfb22f868857 100644
--- a/drivers/phy/renesas/phy-rcar-gen3-usb2.c
+++ b/drivers/phy/renesas/phy-rcar-gen3-usb2.c
@@ -21,6 +21,7 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/regulator/consumer.h>
+#include <linux/string.h>
 #include <linux/usb/of.h>
 #include <linux/workqueue.h>
 
@@ -320,9 +321,9 @@ static ssize_t role_store(struct device *dev, struct device_attribute *attr,
 	if (!ch->is_otg_channel || !rcar_gen3_is_any_rphy_initialized(ch))
 		return -EIO;
 
-	if (!strncmp(buf, "host", strlen("host")))
+	if (sysfs_streq(buf, "host"))
 		new_mode = PHY_MODE_USB_HOST;
-	else if (!strncmp(buf, "peripheral", strlen("peripheral")))
+	else if (sysfs_streq(buf, "peripheral"))
 		new_mode = PHY_MODE_USB_DEVICE;
 	else
 		return -EINVAL;

