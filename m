Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D1E33A4BF
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 13:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbhCNMX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 08:23:57 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:46927 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235441AbhCNMXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 08:23:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7A9FF19409A2;
        Sun, 14 Mar 2021 08:23:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 14 Mar 2021 08:23:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Vm7dOr
        GT/m8zfAErgz/Jtj3x29110vmdMEbW1CgxrxE=; b=pnetsDcmzuJohLeL94UsN6
        45v8Hp1GNI30RSMkVBSQAtOse3xpZdNiRAGzXlw1a6hqhe2hYpw4d1q3bI3ohtJJ
        8cZu/5pPpzDBGyxRqXfrykIHi2pGGcCCSUKJO/TYm8JQzeQEOpQB0QMoWT5EmKID
        w7NHVn1u6oa/kmMjnw8ME6EI6gzYkMzHWV7Y5CFAKabULkAyqvz0NKtHjQRJvUCw
        ECYLHbDDyPixoeb9MpSyk++BAHiqPlwE0ppQH8kNHqI6ldVXFo/VDxOkwY7Hofd0
        IG4VZC0KbXFqCuEsdqg2kG5vLRF5SeiBMgBtL4oX5Gang8vT926fmnXNMnVHpK7g
        ==
X-ME-Sender: <xms:SQBOYGboqCjHJSOxUesBjndONNTi27WaHJel43l_tzjLq1_DF4owGg>
    <xme:SQBOYJaztAoDA2_Gm6HOfeUY5ug33VmdCQukhtUUkVE9ACsCiFu4INU9opIem-yD3
    hw_5Dfe95C6Pw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SQBOYA-T8YFdjDg5RR_3GshlXn1X5dCFsX0Fnw-w6PeFWw0fC7Y3LQ>
    <xmx:SQBOYIqDsja6DZTjyWR8NDPUhkjwq6dc2BjNhbDPRJL7HBTYSt_KoQ>
    <xmx:SQBOYBrCq9ds-I8usxr8xS4qu9UqedmXmGXLM1eEXSpjaxwBKlvT2Q>
    <xmx:SQBOYCnFA3KJyctYlQ_osTolwMyS8t8Ipsk-zcECVKrXkIvYnxWwwQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1DBF7240054;
        Sun, 14 Mar 2021 08:23:37 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usbip: fix vudc usbip_sockfd_store races leading to gpf" failed to apply to 4.14-stable tree
To:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        penguin-kernel@I-love.SAKURA.ne.jp,
        syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Mar 2021 13:23:34 +0100
Message-ID: <1615724614221237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 46613c9dfa964c0c60b5385dbdf5aaa18be52a9c Mon Sep 17 00:00:00 2001
From: Shuah Khan <skhan@linuxfoundation.org>
Date: Sun, 7 Mar 2021 20:53:31 -0700
Subject: [PATCH] usbip: fix vudc usbip_sockfd_store races leading to gpf

usbip_sockfd_store() is invoked when user requests attach (import)
detach (unimport) usb gadget device from usbip host. vhci_hcd sends
import request and usbip_sockfd_store() exports the device if it is
free for export.

Export and unexport are governed by local state and shared state
- Shared state (usbip device status, sockfd) - sockfd and Device
  status are used to determine if stub should be brought up or shut
  down. Device status is shared between host and client.
- Local state (tcp_socket, rx and tx thread task_struct ptrs)
  A valid tcp_socket controls rx and tx thread operations while the
  device is in exported state.
- While the device is exported, device status is marked used and socket,
  sockfd, and thread pointers are valid.

Export sequence (stub-up) includes validating the socket and creating
receive (rx) and transmit (tx) threads to talk to the client to provide
access to the exported device. rx and tx threads depends on local and
shared state to be correct and in sync.

Unexport (stub-down) sequence shuts the socket down and stops the rx and
tx threads. Stub-down sequence relies on local and shared states to be
in sync.

There are races in updating the local and shared status in the current
stub-up sequence resulting in crashes. These stem from starting rx and
tx threads before local and global state is updated correctly to be in
sync.

1. Doesn't handle kthread_create() error and saves invalid ptr in local
   state that drives rx and tx threads.
2. Updates tcp_socket and sockfd,  starts stub_rx and stub_tx threads
   before updating usbip_device status to SDEV_ST_USED. This opens up a
   race condition between the threads and usbip_sockfd_store() stub up
   and down handling.

Fix the above problems:
- Stop using kthread_get_run() macro to create/start threads.
- Create threads and get task struct reference.
- Add kthread_create() failure handling and bail out.
- Hold usbip_device lock to update local and shared states after
  creating rx and tx threads.
- Update usbip_device status to SDEV_ST_USED.
- Update usbip_device tcp_socket, sockfd, tcp_rx, and tcp_tx
- Start threads after usbip_device (tcp_socket, sockfd, tcp_rx, tcp_tx,
  and status) is complete.

Credit goes to syzbot and Tetsuo Handa for finding and root-causing the
kthread_get_run() improper error handling problem and others. This is a
hard problem to find and debug since the races aren't seen in a normal
case. Fuzzing forces the race window to be small enough for the
kthread_get_run() error path bug and starting threads before updating the
local and shared state bug in the stub-up sequence.

Fixes: 9720b4bc76a83807 ("staging/usbip: convert to kthread")
Cc: stable@vger.kernel.org
Reported-by: syzbot <syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+bf1a360e305ee719e364@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+95ce4b142579611ef0a9@syzkaller.appspotmail.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/b1c08b983ffa185449c9f0f7d1021dc8c8454b60.1615171203.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index 83a0c59a3de8..a3ec39fc6177 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -90,8 +90,9 @@ static ssize_t dev_desc_read(struct file *file, struct kobject *kobj,
 }
 static BIN_ATTR_RO(dev_desc, sizeof(struct usb_device_descriptor));
 
-static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *attr,
-		     const char *in, size_t count)
+static ssize_t usbip_sockfd_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *in, size_t count)
 {
 	struct vudc *udc = (struct vudc *) dev_get_drvdata(dev);
 	int rv;
@@ -100,6 +101,8 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 	struct socket *socket;
 	unsigned long flags;
 	int ret;
+	struct task_struct *tcp_rx = NULL;
+	struct task_struct *tcp_tx = NULL;
 
 	rv = kstrtoint(in, 0, &sockfd);
 	if (rv != 0)
@@ -145,24 +148,47 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 			goto sock_err;
 		}
 
-		udc->ud.tcp_socket = socket;
-
+		/* unlock and create threads and get tasks */
 		spin_unlock_irq(&udc->ud.lock);
 		spin_unlock_irqrestore(&udc->lock, flags);
 
-		udc->ud.tcp_rx = kthread_get_run(&v_rx_loop,
-						    &udc->ud, "vudc_rx");
-		udc->ud.tcp_tx = kthread_get_run(&v_tx_loop,
-						    &udc->ud, "vudc_tx");
+		tcp_rx = kthread_create(&v_rx_loop, &udc->ud, "vudc_rx");
+		if (IS_ERR(tcp_rx)) {
+			sockfd_put(socket);
+			return -EINVAL;
+		}
+		tcp_tx = kthread_create(&v_tx_loop, &udc->ud, "vudc_tx");
+		if (IS_ERR(tcp_tx)) {
+			kthread_stop(tcp_rx);
+			sockfd_put(socket);
+			return -EINVAL;
+		}
+
+		/* get task structs now */
+		get_task_struct(tcp_rx);
+		get_task_struct(tcp_tx);
 
+		/* lock and update udc->ud state */
 		spin_lock_irqsave(&udc->lock, flags);
 		spin_lock_irq(&udc->ud.lock);
+
+		udc->ud.tcp_socket = socket;
+		udc->ud.tcp_rx = tcp_rx;
+		udc->ud.tcp_rx = tcp_tx;
 		udc->ud.status = SDEV_ST_USED;
+
 		spin_unlock_irq(&udc->ud.lock);
 
 		ktime_get_ts64(&udc->start_time);
 		v_start_timer(udc);
 		udc->connected = 1;
+
+		spin_unlock_irqrestore(&udc->lock, flags);
+
+		wake_up_process(udc->ud.tcp_rx);
+		wake_up_process(udc->ud.tcp_tx);
+		return count;
+
 	} else {
 		if (!udc->connected) {
 			dev_err(dev, "Device not connected");

