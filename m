Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9E12E352E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 09:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgL1ImV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 03:42:21 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40349 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbgL1ImV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 03:42:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8683D757;
        Mon, 28 Dec 2020 03:41:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 03:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4np9Ce
        XG1ZyKDn9RmuWWXU0ni+YkTXNwXZeEHIaqcRQ=; b=LIhBt/O6jge9OL0qGGtsjW
        qJspdj7j7njp1GtadgzKh1CP8euSBzhuKkVXs7mCazGzw+1PAfB2SNyBxuHCfHN0
        IaFHoFLo65kc0b8LeoKQrQNFFkHLZdEuPrkBT24JTSpUWWXfEcNRznsrMU28JVXF
        kg4bZ/SGpvAl4Bx8yZ0gIs96bGrEIqRjbgSMpoKc3lF6DQbzm/Xk7XAuo09uCpwI
        CMrHgMDp4Q+3BZYmvRFg+EMb2SoWJwwXypElunJS2MLIfWn1Dww3qEiuEsiDmRWI
        RSexwsNr9pxXmlB74AryXRK0TkpuFjPks//QVy6aZ8kW4djy93zhAwqei2xS9Rpg
        ==
X-ME-Sender: <xms:P5rpX7FvrHN75E8-LfGrn5A5g1lFeqHaCVjebSidIdIkxQdCllfWwA>
    <xme:P5rpX4Ww5ukbtYCOYOJRJqaTfvfQwZpSrSZDgLqZcvRyIcTCbTLeaSPUiwdzOyvPW
    aza9mY5DkAZOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddukedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:P5rpX9L-zOHZcdWugKn36uPcGtjZgdw-vPxoJzycjvpuJU8E_hUpDw>
    <xmx:P5rpX5GXtJvSUhbFUywG46YsxhMxCqZD2Nxg7dgKv5UdzAgZO4QcEQ>
    <xmx:P5rpXxWTAEDfOWjshTsAjDWzq1YQ2sA766I16ZJWLOZS7UqfkgSSDg>
    <xmx:P5rpXydkWNgTSGrGL0D6ELVZWvroy8pAfBSV1ByvgU6b8DePv7P7t6ZeOMU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B6662108005C;
        Mon, 28 Dec 2020 03:41:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] USB: serial: digi_acceleport: fix write-wakeup deadlocks" failed to apply to 4.9-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 09:42:49 +0100
Message-ID: <160914496955152@kroah.com>
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

From 5098e77962e7c8947f87bd8c5869c83e000a522a Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 26 Oct 2020 11:43:06 +0100
Subject: [PATCH] USB: serial: digi_acceleport: fix write-wakeup deadlocks

The driver must not call tty_wakeup() while holding its private lock as
line disciplines are allowed to call back into write() from
write_wakeup(), leading to a deadlock.

Also remove the unneeded work struct that was used to defer wakeup in
order to work around a possible race in ancient times (see comment about
n_tty write_chan() in commit 14b54e39b412 ("USB: serial: remove
changelogs and old todo entries")).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>

diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 016e7dec3196..968e08cdcb09 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -19,7 +19,6 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/workqueue.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/wait.h>
@@ -198,14 +197,12 @@ struct digi_port {
 	int dp_throttle_restart;
 	wait_queue_head_t dp_flush_wait;
 	wait_queue_head_t dp_close_wait;	/* wait queue for close */
-	struct work_struct dp_wakeup_work;
 	struct usb_serial_port *dp_port;
 };
 
 
 /* Local Function Declarations */
 
-static void digi_wakeup_write_lock(struct work_struct *work);
 static int digi_write_oob_command(struct usb_serial_port *port,
 	unsigned char *buf, int count, int interruptible);
 static int digi_write_inb_command(struct usb_serial_port *port,
@@ -356,26 +353,6 @@ __releases(lock)
 	return timeout;
 }
 
-
-/*
- *  Digi Wakeup Write
- *
- *  Wake up port, line discipline, and tty processes sleeping
- *  on writes.
- */
-
-static void digi_wakeup_write_lock(struct work_struct *work)
-{
-	struct digi_port *priv =
-			container_of(work, struct digi_port, dp_wakeup_work);
-	struct usb_serial_port *port = priv->dp_port;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->dp_port_lock, flags);
-	tty_port_tty_wakeup(&port->port);
-	spin_unlock_irqrestore(&priv->dp_port_lock, flags);
-}
-
 /*
  *  Digi Write OOB Command
  *
@@ -985,6 +962,7 @@ static void digi_write_bulk_callback(struct urb *urb)
 	unsigned long flags;
 	int ret = 0;
 	int status = urb->status;
+	bool wakeup;
 
 	/* port and serial sanity check */
 	if (port == NULL || (priv = usb_get_serial_port_data(port)) == NULL) {
@@ -1011,6 +989,7 @@ static void digi_write_bulk_callback(struct urb *urb)
 	}
 
 	/* try to send any buffered data on this port */
+	wakeup = true;
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 	priv->dp_write_urb_in_use = 0;
 	if (priv->dp_out_buf_len > 0) {
@@ -1026,19 +1005,18 @@ static void digi_write_bulk_callback(struct urb *urb)
 		if (ret == 0) {
 			priv->dp_write_urb_in_use = 1;
 			priv->dp_out_buf_len = 0;
+			wakeup = false;
 		}
 	}
-	/* wake up processes sleeping on writes immediately */
-	tty_port_tty_wakeup(&port->port);
-	/* also queue up a wakeup at scheduler time, in case we */
-	/* lost the race in write_chan(). */
-	schedule_work(&priv->dp_wakeup_work);
-
 	spin_unlock_irqrestore(&priv->dp_port_lock, flags);
+
 	if (ret && ret != -EPERM)
 		dev_err_console(port,
 			"%s: usb_submit_urb failed, ret=%d, port=%d\n",
 			__func__, ret, priv->dp_port_num);
+
+	if (wakeup)
+		tty_port_tty_wakeup(&port->port);
 }
 
 static int digi_write_room(struct tty_struct *tty)
@@ -1238,7 +1216,6 @@ static int digi_port_init(struct usb_serial_port *port, unsigned port_num)
 	init_waitqueue_head(&priv->dp_transmit_idle_wait);
 	init_waitqueue_head(&priv->dp_flush_wait);
 	init_waitqueue_head(&priv->dp_close_wait);
-	INIT_WORK(&priv->dp_wakeup_work, digi_wakeup_write_lock);
 	priv->dp_port = port;
 
 	init_waitqueue_head(&port->write_wait);
@@ -1507,13 +1484,14 @@ static int digi_read_oob_callback(struct urb *urb)
 			rts = C_CRTSCTS(tty);
 
 		if (tty && opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
+			bool wakeup = false;
+
 			spin_lock_irqsave(&priv->dp_port_lock, flags);
 			/* convert from digi flags to termiox flags */
 			if (val & DIGI_READ_INPUT_SIGNALS_CTS) {
 				priv->dp_modem_signals |= TIOCM_CTS;
-				/* port must be open to use tty struct */
 				if (rts)
-					tty_port_tty_wakeup(&port->port);
+					wakeup = true;
 			} else {
 				priv->dp_modem_signals &= ~TIOCM_CTS;
 				/* port must be open to use tty struct */
@@ -1532,6 +1510,9 @@ static int digi_read_oob_callback(struct urb *urb)
 				priv->dp_modem_signals &= ~TIOCM_CD;
 
 			spin_unlock_irqrestore(&priv->dp_port_lock, flags);
+
+			if (wakeup)
+				tty_port_tty_wakeup(&port->port);
 		} else if (opcode == DIGI_CMD_TRANSMIT_IDLE) {
 			spin_lock_irqsave(&priv->dp_port_lock, flags);
 			priv->dp_transmit_idle = 1;

