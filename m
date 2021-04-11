Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326FF35B22B
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 09:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235079AbhDKHVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 03:21:54 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41803 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhDKHVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 03:21:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 6C4B014BF;
        Sun, 11 Apr 2021 03:21:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Apr 2021 03:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EaUyqx
        Xq9uNHaCObHN88k+VmctOXvugQ2dZphbomA/s=; b=cqrqD1uVtz0mkNCMzo6Kgc
        B9hlu8MS8en+oFoFF895pBLoJg1pTRY4hiA5g+FL4AHNjMUDnZyS3rVFPBNiljIB
        Mjm2bXuZiytuP5Ip4OnNr15wTAbqA7HIngdnXNAhbqFMpoMvIPKoBQHoII5ruK82
        sMjcLHEiyAdPt7T6YQDIn7r+65PZ0Qff80hxotcp13BB4rVTB4ZrxHFNSCkb7Vq3
        xCh6HZG5zp8KSF8IVkPB2I5SbjgflVE/7Q8pCUYAi1Auuv+VHvHdWfsct/z6TC5w
        1pwjeUMmfrMTe2wAREdzxPBQ6+kwUMAHsezaC5u6XDLfhKibAEWMg+6UZgBQRn3A
        ==
X-ME-Sender: <xms:gaNyYPG2CmGDvvnBGlA7ETxR6emk_M4kZH65rUp0G_fwVz-fR5CspQ>
    <xme:gaNyYMWGDt5OIgbLw6Gpu2oLuY8bWEJDd344BPkLDIAUZ7b5IOgoubkFRBy-WRbZd
    DiljmcLN-PHeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekgedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:gqNyYBK4QKSBCv34_5GrOJxcy-sBnqB0f2pSp1OwrYIqnzuSVGMD2Q>
    <xmx:gqNyYNH3aaZqz-IMAt0yre3TCJ2VDykHAAI0G_N62dRKbrowDsCjZg>
    <xmx:gqNyYFUOtP5qI7_0Iy80YfUSUUt-IT2NDfXkg8RsW1r_ybT6vvJ_HA>
    <xmx:gqNyYGcFkk_bagcCZdMgPk88M1qwrLhXvMbhZ2iqqYx9IZxoXqVEE-W5ZUA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF22B240054;
        Sun, 11 Apr 2021 03:21:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usbip: stub-dev synchronize sysfs code paths" failed to apply to 4.4-stable tree
To:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Apr 2021 09:21:36 +0200
Message-ID: <16181256965393@kroah.com>
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

From 9dbf34a834563dada91366c2ac266f32ff34641a Mon Sep 17 00:00:00 2001
From: Shuah Khan <skhan@linuxfoundation.org>
Date: Mon, 29 Mar 2021 19:36:49 -0600
Subject: [PATCH] usbip: stub-dev synchronize sysfs code paths

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

Use sysfs_lock to protect sysfs paths in stub-dev.

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/2b182f3561b4a065bf3bf6dce3b0e9944ba17b3f.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index 8f1de1fbbeed..d8d3892e5a69 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -63,6 +63,7 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 
 		dev_info(dev, "stub up\n");
 
+		mutex_lock(&sdev->ud.sysfs_lock);
 		spin_lock_irq(&sdev->ud.lock);
 
 		if (sdev->ud.status != SDEV_ST_AVAILABLE) {
@@ -87,13 +88,13 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 		tcp_rx = kthread_create(stub_rx_loop, &sdev->ud, "stub_rx");
 		if (IS_ERR(tcp_rx)) {
 			sockfd_put(socket);
-			return -EINVAL;
+			goto unlock_mutex;
 		}
 		tcp_tx = kthread_create(stub_tx_loop, &sdev->ud, "stub_tx");
 		if (IS_ERR(tcp_tx)) {
 			kthread_stop(tcp_rx);
 			sockfd_put(socket);
-			return -EINVAL;
+			goto unlock_mutex;
 		}
 
 		/* get task structs now */
@@ -112,6 +113,8 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 		wake_up_process(sdev->ud.tcp_rx);
 		wake_up_process(sdev->ud.tcp_tx);
 
+		mutex_unlock(&sdev->ud.sysfs_lock);
+
 	} else {
 		dev_info(dev, "stub down\n");
 
@@ -122,6 +125,7 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 		spin_unlock_irq(&sdev->ud.lock);
 
 		usbip_event_add(&sdev->ud, SDEV_EVENT_DOWN);
+		mutex_unlock(&sdev->ud.sysfs_lock);
 	}
 
 	return count;
@@ -130,6 +134,8 @@ sock_err:
 	sockfd_put(socket);
 err:
 	spin_unlock_irq(&sdev->ud.lock);
+unlock_mutex:
+	mutex_unlock(&sdev->ud.sysfs_lock);
 	return -EINVAL;
 }
 static DEVICE_ATTR_WO(usbip_sockfd);
@@ -270,6 +276,7 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev)
 	sdev->ud.side		= USBIP_STUB;
 	sdev->ud.status		= SDEV_ST_AVAILABLE;
 	spin_lock_init(&sdev->ud.lock);
+	mutex_init(&sdev->ud.sysfs_lock);
 	sdev->ud.tcp_socket	= NULL;
 	sdev->ud.sockfd		= -1;
 

