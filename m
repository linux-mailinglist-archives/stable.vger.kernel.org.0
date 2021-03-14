Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4933A4BD
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 13:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235327AbhCNMWx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 08:22:53 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:48813 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235438AbhCNMWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 08:22:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 860C219409A2;
        Sun, 14 Mar 2021 08:22:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 14 Mar 2021 08:22:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+ESMiJ
        wVfLYxxmw951UgHOg+uiyFk+Ay7sc7Vf5DqIM=; b=LjrTCRvxGeEAbP82q4pj5K
        RTOoCejI8mVL2XDp06B6rCtos4wxLMlNCSbnfME6Nyuu0f9j75ga7skbTs2agHJv
        N8K7labHd0L+zuYpGrNNUVf1SK11+dqJ0awdKpyLz4em2eCYUTYE69NosZ8Qll3l
        bi7q8w5YAeg6aL1ijeFuvubqeABz4El6GUlVXfN9Ze+iaSrJxSUDjSCbdBZIOO6X
        rfpsm0jQaNO1dQoOQ9J+xYhKCzdtRQ+1gS1Zf4gVBsddHlmrAIOZPgqLrM8olF+6
        2mAJvhECtxErluQlRkzMie3gk7Si2pu33MGNT1RdIrba0qKnV7TYkpgeRzqD0v3Q
        ==
X-ME-Sender: <xms:FwBOYG1AOkzAoGPFehlvT3BNILFeu5xCJFFZ0y3WdkjctFK0UhxY5w>
    <xme:FwBOYJDdoB0Q78TXd5U5a3H08ofRZoafyKJIr3TM6CEdCpBJyGM13rwtypIgJUY9d
    9t4I_2M_Kv3ig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgffhfffffedtkedvkeeiteehheetkefffefhtddvhf
    egudefvddtvedvheegheevnecuffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhp
    ohhtrdgtohhmpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomh
X-ME-Proxy: <xmx:FwBOYLyrcua9pFMslewbDDH9BNJj01KmRpWfjGJtR_s271_lo10kKg>
    <xmx:FwBOYPnzGECtTTAtM3Nz4x6_hMZ7NgAtmPDg4My3pqBX-YkkwTa1Lw>
    <xmx:FwBOYIGgXJxjzp0UfqxPDGoJo1mA2-gqXgzHXAHdp9Z07e8p1dRwww>
    <xmx:GABOYArT1aNXJjmSv7n7jMA4n9Zy8hyMoYkVfwq0n0xaGlTnrnnLeA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 82ED0240054;
        Sun, 14 Mar 2021 08:22:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usbip: fix vhci_hcd attach_store() races leading to gpf" failed to apply to 4.4-stable tree
To:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        penguin-kernel@I-love.SAKURA.ne.jp,
        syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Mar 2021 13:22:45 +0100
Message-ID: <161572456560156@kroah.com>
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

From 718ad9693e3656120064b715fe931f43a6201e67 Mon Sep 17 00:00:00 2001
From: Shuah Khan <skhan@linuxfoundation.org>
Date: Sun, 7 Mar 2021 20:53:30 -0700
Subject: [PATCH] usbip: fix vhci_hcd attach_store() races leading to gpf

attach_store() is invoked when user requests import (attach) a device
from usbip host.

Attach and detach are governed by local state and shared state
- Shared state (usbip device status) - Device status is used to manage
  the attach and detach operations on import-able devices.
- Local state (tcp_socket, rx and tx thread task_struct ptrs)
  A valid tcp_socket controls rx and tx thread operations while the
  device is in exported state.
- Device has to be in the right state to be attached and detached.

Attach sequence includes validating the socket and creating receive (rx)
and transmit (tx) threads to talk to the host to get access to the
imported device. rx and tx threads depends on local and shared state to
be correct and in sync.

Detach sequence shuts the socket down and stops the rx and tx threads.
Detach sequence relies on local and shared states to be in sync.

There are races in updating the local and shared status in the current
attach sequence resulting in crashes. These stem from starting rx and
tx threads before local and global state is updated correctly to be in
sync.

1. Doesn't handle kthread_create() error and saves invalid ptr in local
   state that drives rx and tx threads.
2. Updates tcp_socket and sockfd,  starts stub_rx and stub_tx threads
   before updating usbip_device status to VDEV_ST_NOTASSIGNED. This opens
   up a race condition between the threads, port connect, and detach
   handling.

Fix the above problems:
- Stop using kthread_get_run() macro to create/start threads.
- Create threads and get task struct reference.
- Add kthread_create() failure handling and bail out.
- Hold vhci and usbip_device locks to update local and shared states after
  creating rx and tx threads.
- Update usbip_device status to VDEV_ST_NOTASSIGNED.
- Update usbip_device tcp_socket, sockfd, tcp_rx, and tcp_tx
- Start threads after usbip_device (tcp_socket, sockfd, tcp_rx, tcp_tx,
  and status) is complete.

Credit goes to syzbot and Tetsuo Handa for finding and root-causing the
kthread_get_run() improper error handling problem and others. This is
hard problem to find and debug since the races aren't seen in a normal
case. Fuzzing forces the race window to be small enough for the
kthread_get_run() error path bug and starting threads before updating the
local and shared state bug in the attach sequence.
- Update usbip_device tcp_rx and tcp_tx pointers holding vhci and
  usbip_device locks.

Tested with syzbot reproducer:
- https://syzkaller.appspot.com/text?tag=ReproC&x=14801034d00000

Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
Cc: stable@vger.kernel.org
Reported-by: syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/bb434bd5d7a64fbec38b5ecfb838a6baef6eb12b.1615171203.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
index 1e1ae9bd06ab..c4b4256e5dad 100644
--- a/drivers/usb/usbip/vhci_sysfs.c
+++ b/drivers/usb/usbip/vhci_sysfs.c
@@ -312,6 +312,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 	struct vhci *vhci;
 	int err;
 	unsigned long flags;
+	struct task_struct *tcp_rx = NULL;
+	struct task_struct *tcp_tx = NULL;
 
 	/*
 	 * @rhport: port number of vhci_hcd
@@ -360,9 +362,24 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	}
 
-	/* now need lock until setting vdev status as used */
+	/* create threads before locking */
+	tcp_rx = kthread_create(vhci_rx_loop, &vdev->ud, "vhci_rx");
+	if (IS_ERR(tcp_rx)) {
+		sockfd_put(socket);
+		return -EINVAL;
+	}
+	tcp_tx = kthread_create(vhci_tx_loop, &vdev->ud, "vhci_tx");
+	if (IS_ERR(tcp_tx)) {
+		kthread_stop(tcp_rx);
+		sockfd_put(socket);
+		return -EINVAL;
+	}
+
+	/* get task structs now */
+	get_task_struct(tcp_rx);
+	get_task_struct(tcp_tx);
 
-	/* begin a lock */
+	/* now begin lock until setting vdev status set */
 	spin_lock_irqsave(&vhci->lock, flags);
 	spin_lock(&vdev->ud.lock);
 
@@ -372,6 +389,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 		spin_unlock_irqrestore(&vhci->lock, flags);
 
 		sockfd_put(socket);
+		kthread_stop_put(tcp_rx);
+		kthread_stop_put(tcp_tx);
 
 		dev_err(dev, "port %d already used\n", rhport);
 		/*
@@ -390,6 +409,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 	vdev->speed         = speed;
 	vdev->ud.sockfd     = sockfd;
 	vdev->ud.tcp_socket = socket;
+	vdev->ud.tcp_rx     = tcp_rx;
+	vdev->ud.tcp_tx     = tcp_tx;
 	vdev->ud.status     = VDEV_ST_NOTASSIGNED;
 	usbip_kcov_handle_init(&vdev->ud);
 
@@ -397,8 +418,8 @@ static ssize_t attach_store(struct device *dev, struct device_attribute *attr,
 	spin_unlock_irqrestore(&vhci->lock, flags);
 	/* end the lock */
 
-	vdev->ud.tcp_rx = kthread_get_run(vhci_rx_loop, &vdev->ud, "vhci_rx");
-	vdev->ud.tcp_tx = kthread_get_run(vhci_tx_loop, &vdev->ud, "vhci_tx");
+	wake_up_process(vdev->ud.tcp_rx);
+	wake_up_process(vdev->ud.tcp_tx);
 
 	rh_port_connect(vdev, speed);
 

