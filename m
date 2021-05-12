Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE2237B7FF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhELIbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:31:52 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:34967 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhELIbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:31:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8E187155F;
        Wed, 12 May 2021 04:30:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3UGyDo
        9uEQ4D8r6zsr3RKPxTBeUeOVnJj1LcL6p/r8E=; b=sdjeY4Hc+ivve43FYDia4d
        pWtaYl9d5f+lLQz5HFQ2J5pNW09MpK2tc6coYWQOmM8MwY0yEDYOwnZlO3JO0Yx7
        60xaa2hr2BUBC8VjYx85F3QFRJVSsUHVYnTgfRhP8IIffuWW55sBUXC/QEk3STRb
        JkwF3FjgSefpLhTq9d5fAiCaoRpx5W8aa9WndUBiEZk0TL3oGuFNxgfZ24guuwNC
        N26Lep4sBqBhKvdFea5kKLYFfGudTvLDZMHty7JU+Np494JYRS/poZ+X+qXDAjz7
        GmZl6YBxsvqb5fEKRMP1lHzE14bTOjViezJsw0hzG0bvfK6LZKt1+/uFESwBhwTw
        ==
X-ME-Sender: <xms:M5KbYB4zyoag9kZ2gzSrjrQ2gPfZyB4XFnoRcZNwfBhv3e2UqrcMIw>
    <xme:M5KbYO7TonmmPyFv5w-9MmcYd_j69OvckpbvN3-R299K7ZOnsq4IiisWbnvKKRS9y
    0A_F90vspkNYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:M5KbYIdohM_pI5IvKFLMOLRZnt9lVAnpv7jCbadnqh3bkIx-L7SczA>
    <xmx:M5KbYKI3oQT4Wyz9iF6qX2_vBpIPH3xkyzINK7saY27y_EGQOH2qYg>
    <xmx:M5KbYFIAPNLtcFYqXzG-IuZ7k1W-c_ydz-rxqKUR0aVzmlPKVdnS_Q>
    <xmx:M5KbYHxvzRmr9VR7z3yCTFG5kHCJutajgd6gNXtZF8TFZz1KkSc13LdHXDU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:30:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tty: mxser: fix TIOCSSERIAL jiffies conversions" failed to apply to 5.10-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:30:33 +0200
Message-ID: <16208082336675@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
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

