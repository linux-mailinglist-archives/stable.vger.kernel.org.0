Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913CF35B228
	for <lists+stable@lfdr.de>; Sun, 11 Apr 2021 09:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhDKHVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 03:21:08 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46689 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229792AbhDKHVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Apr 2021 03:21:08 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3DD1515E0;
        Sun, 11 Apr 2021 03:20:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Apr 2021 03:20:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U/Z/fU
        fhmqtjsOgmcQqjkWdtEbTszosUlmfbVwGaGpw=; b=ldQF/rJZBfYi+3tg6/9r1l
        TDT3QIjs1mQHWsYrnZBMdhl1yytshRM/K/pxDm8YFi3Jov6MbLkdz3u6SC8LFOeT
        gAhGoyMyzGm9/Nm1b5T8iAgK6Z2MF+PmYdoOxVzv9Mv+FDG8jgKzICE0/B40hCE6
        c2yPfLvbmXIH7eJ2eUdt/UzaDsCRo35kjIELpE+EUz+2Tgl7cHSvwJ+RfMLgQ5aq
        YhYcu3QCRalH9b1cBI+oj0Wv2nLDImub9auc0QG3hjVPxmWLZSpb/jQSLHTmuYSU
        6FbWYyHfwk0bPtiz4BEQZsIwBdhj7LhF2c3gKYD4l5178X3/RtTgpXQ2nNpWY2jA
        ==
X-ME-Sender: <xms:U6NyYM9NhejMnyfgWbloyJMUiyZbMD0Yz4ffX73anlGPVuYpICUFgA>
    <xme:U6NyYEs3dElTgT8fC5qR8jmrGZaOBb9p9NmQn47W0CD239zjUmHmx5_6tib809UVZ
    eb4vGpYA2HS4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekgedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:U6NyYCBFraqs6ZI7nAf3s3E1sYRLUjpLXdOJCHNXWnjV1W3T0BC-Xw>
    <xmx:U6NyYMeaRBbaQy9WPMWN4IcWpCrez6MbtpzzQIOFsw4t74vifU0Fxw>
    <xmx:U6NyYBN1_JtiSfDzr0T4rWHnVtFC30rSwxQ84mJ6n4S0JxkNAKqVEA>
    <xmx:U6NyYDXmMaQW0wpGAFe2zQkfudMmXnT76qlwj3ShANlSSPFJ_cQPXb_PKOQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 69F85240054;
        Sun, 11 Apr 2021 03:20:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usbip: add sysfs_lock to synchronize sysfs code paths" failed to apply to 4.9-stable tree
To:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Apr 2021 09:20:49 +0200
Message-ID: <16181256491051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 4e9c93af7279b059faf5bb1897ee90512b258a12 Mon Sep 17 00:00:00 2001
From: Shuah Khan <skhan@linuxfoundation.org>
Date: Mon, 29 Mar 2021 19:36:48 -0600
Subject: [PATCH] usbip: add sysfs_lock to synchronize sysfs code paths

Fuzzing uncovered race condition between sysfs code paths in usbip
drivers. Device connect/disconnect code paths initiated through
sysfs interface are prone to races if disconnect happens during
connect and vice versa.

This problem is common to all drivers while it can be reproduced easily
in vhci_hcd. Add a sysfs_lock to usbip_device struct to protect the paths.

Use this in vhci_hcd to protect sysfs paths. For a complete fix, usip_host
and usip-vudc drivers and the event handler will have to use this lock to
protect the paths. These changes will be done in subsequent patches.

Cc: stable@vger.kernel.org
Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/b6568f7beae702bbc236a545d3c020106ca75eac.1616807117.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index d60ce17d3dd2..ea2a20e6d27d 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -263,6 +263,9 @@ struct usbip_device {
 	/* lock for status */
 	spinlock_t lock;
 
+	/* mutex for synchronizing sysfs store paths */
+	struct mutex sysfs_lock;
+
 	int sockfd;
 	struct socket *tcp_socket;
 
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index a20a8380ca0c..4ba6bcdaa8e9 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -1101,6 +1101,7 @@ static void vhci_device_init(struct vhci_device *vdev)
 	vdev->ud.side   = USBIP_VHCI;
 	vdev->ud.status = VDEV_ST_NULL;
 	spin_lock_init(&vdev->ud.lock);
+	mutex_init(&vdev->ud.sysfs_lock);
 
 	INIT_LIST_HEAD(&vdev->priv_rx);
 	INIT_LIST_HEAD(&vdev->priv_tx);
diff --git a/drivers/usb/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
index c4b4256e5dad..e2847cd3e6e3 100644
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -185,6 +185,8 @@ static int vhci_port_disconnect(struct vhci_hcd *vhci_hcd, __u32 rhport)
 
 	usbip_dbg_vhci_sysfs("enter\n");
 
+	mutex_lock(&vdev->ud.sysfs_lock);
+
 	/* lock */
 	spin_lock_irqsave(&vhci->lock, flags);
 	spin_lock(&vdev->ud.lock);
@@ -195,6 +197,7 @@ static int vhci_port_disconnect(struct vhci_hcd *vhci_hcd, __u32 rhport)
 		/* unlock */
 		spin_unlock(&vdev->ud.lock);
 		spin_unlock_irqrestore(&vhci->lock, flags);
+		mutex_unlock(&vdev->ud.sysfs_lock);
 
 		return -EINVAL;
 	}
@@ -205,6 +208,8 @@ static int vhci_port_disconnect(struct vhci_hcd *vhci_hcd, __u32 rhport)
 
 	usbip_event_add(&vdev->ud, VDEV_EVENT_DOWN);
 
+	mutex_unlock(&vdev->ud.sysfs_lock);
+
 	return 0;
 }
 
@@ -349,30 +354,36 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 	else
 		vdev = &vhci->vhci_hcd_hs->vdev[rhport];
 
+	mutex_lock(&vdev->ud.sysfs_lock);
+
 	/* Extract socket from fd. */
 	socket = sockfd_lookup(sockfd, &err);
 	if (!socket) {
 		dev_err(dev, "failed to lookup sock");
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 	if (socket->type != SOCK_STREAM) {
 		dev_err(dev, "Expecting SOCK_STREAM - found %d",
 			socket->type);
 		sockfd_put(socket);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 
 	/* create threads before locking */
 	tcp_rx = kthread_create(vhci_rx_loop, &vdev->ud, "vhci_rx");
 	if (IS_ERR(tcp_rx)) {
 		sockfd_put(socket);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 	tcp_tx = kthread_create(vhci_tx_loop, &vdev->ud, "vhci_tx");
 	if (IS_ERR(tcp_tx)) {
 		kthread_stop(tcp_rx);
 		sockfd_put(socket);
-		return -EINVAL;
+		err = -EINVAL;
+		goto unlock_mutex;
 	}
 
 	/* get task structs now */
@@ -397,7 +408,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 		 * Will be retried from userspace
 		 * if there's another free port.
 		 */
-		return -EBUSY;
+		err = -EBUSY;
+		goto unlock_mutex;
 	}
 
 	dev_info(dev, "pdev(%u) rhport(%u) sockfd(%d)\n",
@@ -423,7 +435,15 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 
 	rh_port_connect(vdev, speed);
 
+	dev_info(dev, "Device attached\n");
+
+	mutex_unlock(&vdev->ud.sysfs_lock);
+
 	return count;
+
+unlock_mutex:
+	mutex_unlock(&vdev->ud.sysfs_lock);
+	return err;
 }
 static DEVICE_ATTR_WO(attach);
 

