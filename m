Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1867135B225
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 09:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbhDKHUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 03:20:31 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:43021 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhDKHUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 03:20:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A3C1715D8;
        Sun, 11 Apr 2021 03:20:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 11 Apr 2021 03:20:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Xp/pD+
        pKX933fGgcY83So/A9K/1B6C9Tb3kasvx4Ofo=; b=f8GBvg0+sWsc9ANomILeiG
        RIZX3OjTo0CjlL36lCUkERamrtkUAe2x/YpQ1EvFzf0Bs1kgtKavF9Ogm2x3LQgR
        p5gztzDeUrXfyMsYoXvi8bfVqNcjht0Fu3kn8grAX6WWUHiIFCG0kKgz0nc2ti69
        eo0ruFudCiMu7dWWgwUsrB4GHlclBBR5fwybrGj9pPcU/pLLw1NZYP6uzfM0pRaZ
        K9cnWeB102RtkyHGjtA7LAcgjIl7Z3c8p7Tz4S3pt+6BmmVqeOzGyrxEhpErPPCg
        XhMvcHO+pPHYMzjBBCZfa6fjghF8csRuN06bKyFa+Bb173TiSBpAH1KtCJWx9K4g
        ==
X-ME-Sender: <xms:LqNyYAUeb8YMJTUONGpvLRprb9Q0965h-mrPbX1V9B38lpoKQRXzUQ>
    <xme:LqNyYEli2pxK8ezYUcYL1km7NevsNDNb3a7lDeo5khTC-SABz7RlY7mNqgJSH8Z1P
    7RpPXaZIiVfEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekgedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:LqNyYEbH9d0YSXyKklPFO3lNCfKIbzLkZCxfXL-lQDLcyjF2gxIIWQ>
    <xmx:LqNyYPUoGgCdedHrKoQSpXjSqay-U0Xqv856Cxz7ghyZhGtynq6EuA>
    <xmx:LqNyYKlSDwBLpRcdDbMRcmA8BBaaauiMTssP7oRmbHXLH6hyXsOFng>
    <xmx:LqNyYBtH3rL4kZ1nnMJRenOGtYTiozjwjZ3PUlkIYzVynMWwTp5639timAQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id E89C61080054;
        Sun, 11 Apr 2021 03:20:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usbip: vudc synchronize sysfs code paths" failed to apply to 4.4-stable tree
To:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Apr 2021 09:20:12 +0200
Message-ID: <161812561211936@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From bd8b82042269a95db48074b8bb400678dbac1815 Mon Sep 17 00:00:00 2001
From: Shuah Khan <skhan@linuxfoundation.org>
Date: Mon, 29 Mar 2021 19:36:50 -0600
Subject: [PATCH] usbip: vudc synchronize sysfs code paths

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to protect sysfs paths in vudc.

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/caabcf3fc87bdae970509b5ff32d05bb7ce2fb15.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/vudc_dev.c b/drivers/usb/usbip/vudc_dev.c
index c8eeabdd9b56..2bc428f2e261 100644
--- a/drivers/usb/usbip/vudc_dev.c
+++ b/drivers/usb/usbip/vudc_dev.c
@@ -572,6 +572,7 @@ static int init_vudc_hw(struct vudc *udc)
 	init_waitqueue_head(&udc->tx_waitq);
 
 	spin_lock_init(&ud->lock);
+	mutex_init(&ud->sysfs_lock);
 	ud->status = SDEV_ST_AVAILABLE;
 	ud->side = USBIP_VUDC;
 
diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index 7383a543c6d1..f7633ee655a1 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -112,6 +112,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 		dev_err(dev, "no device");
 		return -ENODEV;
 	}
+	mutex_lock(&udc->ud.sysfs_lock);
 	spin_lock_irqsave(&udc->lock, flags);
 	/* Don't export what we don't have */
 	if (!udc->driver || !udc->pullup) {
@@ -187,6 +188,8 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 
 		wake_up_process(udc->ud.tcp_rx);
 		wake_up_process(udc->ud.tcp_tx);
+
+		mutex_unlock(&udc->ud.sysfs_lock);
 		return count;
 
 	} else {
@@ -207,6 +210,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 	}
 
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return count;
 
@@ -216,6 +220,7 @@ static ssize_t usbip_sockfd_store(struct device *dev,
 	spin_unlock_irq(&udc->ud.lock);
 unlock:
 	spin_unlock_irqrestore(&udc->lock, flags);
+	mutex_unlock(&udc->ud.sysfs_lock);
 
 	return ret;
 }

