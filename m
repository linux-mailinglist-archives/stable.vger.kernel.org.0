Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3BB37B800
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhELIbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:31:55 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:48585 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230217AbhELIby (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:31:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id F1FF4155F;
        Wed, 12 May 2021 04:30:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iwRyR3
        QTl9HbtiR6/buuxU7zEN4MkY4zGA70Um59ho4=; b=T3mAL/I8ggwgNZ2xhN7jzS
        +COWwPFK1P9VqnBg+Z0xItSAOygNAR+ZrT+9i3C1de4WxSFrezqPuOTkrAXDv11e
        6Ed3pO3QbFvVIqcqMBrI4TGWenfFhDPd88jUL5r4JGHYwTdsomaa71y8BjtKN7Ky
        nQdl+D2mYruFI/Jzba5ihtvsGT3DUu4wc+1CD6XFr2esiqIpwRiNZGglY/iPaQcj
        uJGCAoMXniW6Ccgd7DRStPbl0WB48NfymbAJ7N2LI4T1nb9cqN7TDhI4FKaHA35H
        b/unlgqgyW0Z/vi90hs62JnvsxREspADBZLNlEQa6GiSW/uJVl/4EGrkfX1N0z5w
        ==
X-ME-Sender: <xms:NZKbYHdoNSTK_y-rjbhlJ7SyjLswn2BjWegPwviXniDF1fTOXjXg5A>
    <xme:NZKbYNOAQi4y-uZyk-lUyfYMHW9tiGe4NJgt3sxd3aSKhSf1c2dWr-73Vunvog1ac
    yKbd94xBZWhlg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NZKbYAjE8iXlHTfQB16Q9GGrti_Pw8oKjAn-4L0g_qmrV8d1x1ZRTw>
    <xmx:NZKbYI8TwDAMwqYSC79nqBVXHawpmLitCc6CrAt_7KSP6Q_OQi-LXw>
    <xmx:NZKbYDuScplK0a0NSaPHKfi-ET08JRn0A-jCHl97oqLCp_Ne5AZ9uw>
    <xmx:NZKbYB1agSFY5jpdR0E4KQX-4h8Zvlv26S0gcu1I0xlEKX_jN6PAGAEuQ38>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:30:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tty: mxser: fix TIOCSSERIAL jiffies conversions" failed to apply to 5.11-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:30:34 +0200
Message-ID: <1620808234192128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From be6cf583d24dfe87324dd2830d90fc056e0a6648 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 7 Apr 2021 12:23:31 +0200
Subject: [PATCH] tty: mxser: fix TIOCSSERIAL jiffies conversions

The port close_delay and closing wait parameters set by TIOCSSERIAL are
specified in jiffies, while the values returned by TIOCGSERIAL are
specified in centiseconds.

Add the missing conversions so that TIOCSSERIAL works as expected also
when HZ is not 100.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-14-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 4203b64bccdb..914b23071961 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1208,19 +1208,26 @@ static int mxser_get_serial_info(struct tty_struct *tty,
 {
 	struct mxser_port *info = tty->driver_data;
 	struct tty_port *port = &info->port;
+	unsigned int closing_wait, close_delay;
 
 	if (tty->index == MXSER_PORTS)
 		return -ENOTTY;
 
 	mutex_lock(&port->mutex);
+
+	close_delay = jiffies_to_msecs(info->port.close_delay) / 10;
+	closing_wait = info->port.closing_wait;
+	if (closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		closing_wait = jiffies_to_msecs(closing_wait) / 10;
+
 	ss->type = info->type,
 	ss->line = tty->index,
 	ss->port = info->ioaddr,
 	ss->irq = info->board->irq,
 	ss->flags = info->port.flags,
 	ss->baud_base = info->baud_base,
-	ss->close_delay = info->port.close_delay,
-	ss->closing_wait = info->port.closing_wait,
+	ss->close_delay = close_delay;
+	ss->closing_wait = closing_wait;
 	ss->custom_divisor = info->custom_divisor,
 	mutex_unlock(&port->mutex);
 	return 0;
@@ -1233,7 +1240,7 @@ static int mxser_set_serial_info(struct tty_struct *tty,
 	struct tty_port *port = &info->port;
 	speed_t baud;
 	unsigned long sl_flags;
-	unsigned int flags;
+	unsigned int flags, close_delay, closing_wait;
 	int retval = 0;
 
 	if (tty->index == MXSER_PORTS)
@@ -1255,9 +1262,14 @@ static int mxser_set_serial_info(struct tty_struct *tty,
 
 	flags = port->flags & ASYNC_SPD_MASK;
 
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
+	closing_wait = ss->closing_wait;
+	if (closing_wait != ASYNC_CLOSING_WAIT_NONE)
+		closing_wait = msecs_to_jiffies(closing_wait * 10);
+
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((ss->baud_base != info->baud_base) ||
-				(ss->close_delay != info->port.close_delay) ||
+				(close_delay != info->port.close_delay) ||
 				((ss->flags & ~ASYNC_USR_MASK) != (info->port.flags & ~ASYNC_USR_MASK))) {
 			mutex_unlock(&port->mutex);
 			return -EPERM;
@@ -1271,8 +1283,8 @@ static int mxser_set_serial_info(struct tty_struct *tty,
 		 */
 		port->flags = ((port->flags & ~ASYNC_FLAGS) |
 				(ss->flags & ASYNC_FLAGS));
-		port->close_delay = ss->close_delay * HZ / 100;
-		port->closing_wait = ss->closing_wait * HZ / 100;
+		port->close_delay = close_delay;
+		port->closing_wait = closing_wait;
 		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST &&
 				(ss->baud_base != info->baud_base ||
 				ss->custom_divisor !=

