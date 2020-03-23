Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B223A18F48B
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 13:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgCWM2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 08:28:38 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:56603 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727380AbgCWM2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 08:28:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 6A9D2476;
        Mon, 23 Mar 2020 08:28:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 08:28:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LiGIaZ
        NKp95QJ4Ffn8f2FMxU2O/+10bSapLLoyy283I=; b=cDOe1djZO0sZBXD6gQV/H8
        UbN5LQB/it3/+UoVbltiiXH9k61nOt9NX7rwWxZBHIhzZ6mcNnlVaz9PRkT2eG9z
        HTi7um7uVIdWg+FlFbgneGUdb0mnVYC1ztWhZCvu9L/pGTdXcwjetqZ5qEk1GebP
        j/yCJlbFlNtmE2zqSgU2EN0fW2kPTjX7i04txS4wWrwuJqyxzgEhjmaJFe9mpUM4
        /WrsUTtdVgbIpRkZMZcdWZIcJDEguEvuYLL0jxnLDvJ7dmWkqMBZo9VTaZbxByDF
        7G9T20kUP1/PPerBDrIaLHz6G90CxqSXnDy1M8zxyES5rCbih2nm8DeAIz1QUWiw
        ==
X-ME-Sender: <xms:dKt4Xpfy_MFr2ktHYZIbJh9dX5j2eKjwsyd6GGkPD__tLmWaYk7vxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgnecukf
    hppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dKt4XqOwgqd0n_yWaQcmTE_VEz4yS-_xYK_qpbFqUuBp4wfbqjC_wQ>
    <xmx:dKt4XlEMdAczkB0L747v56ng6pNRY2WpXA7fWq1H7xlQsaiT6ybNcw>
    <xmx:dKt4XtZ323UYPL0bpewJz2o4pxIwq6NNRBZoka58frhm_9jx9-77ow>
    <xmx:dat4Xj3li1cPmbaJEqPxMnt0gc3kbe5XAJ2Er2n1X-8ufM8IY2qxWg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 743193062C4B;
        Mon, 23 Mar 2020 08:28:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: cdc-acm: fix rounding error in TIOCSSERIAL" failed to apply to 4.19-stable tree
To:     anthony.mallet@laas.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 13:28:34 +0100
Message-ID: <1584966514129218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b401f8c4f492cbf74f3f59c9141e5be3071071bb Mon Sep 17 00:00:00 2001
From: Anthony Mallet <anthony.mallet@laas.fr>
Date: Thu, 12 Mar 2020 14:31:01 +0100
Subject: [PATCH] USB: cdc-acm: fix rounding error in TIOCSSERIAL

By default, tty_port_init() initializes those parameters to a multiple
of HZ. For instance in line 69 of tty_port.c:
   port->close_delay = (50 * HZ) / 100;
https://github.com/torvalds/linux/blob/master/drivers/tty/tty_port.c#L69

With e.g. CONFIG_HZ = 250 (as this is the case for Ubuntu 18.04
linux-image-4.15.0-37-generic), the default setting for close_delay is
thus 125.

When ioctl(fd, TIOCGSERIAL, &s) is executed, the setting returned in
user space is '12' (125/10). When ioctl(fd, TIOCSSERIAL, &s) is then
executed with the same setting '12', the value is interpreted as '120'
which is different from the current setting and a EPERM error may be
raised by set_serial_info() if !CAP_SYS_ADMIN.
https://github.com/torvalds/linux/blob/master/drivers/usb/class/cdc-acm.c#L919

Fixes: ba2d8ce9db0a6 ("cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)")
Signed-off-by: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200312133101.7096-2-anthony.mallet@laas.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index da619176deca..47f09a6ce7bd 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -907,6 +907,7 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 {
 	struct acm *acm = tty->driver_data;
 	unsigned int closing_wait, close_delay;
+	unsigned int old_closing_wait, old_close_delay;
 	int retval = 0;
 
 	close_delay = msecs_to_jiffies(ss->close_delay * 10);
@@ -914,18 +915,24 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 			ASYNC_CLOSING_WAIT_NONE :
 			msecs_to_jiffies(ss->closing_wait * 10);
 
+	/* we must redo the rounding here, so that the values match */
+	old_close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
+	old_closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
+				ASYNC_CLOSING_WAIT_NONE :
+				jiffies_to_msecs(acm->port.closing_wait) / 10;
+
 	mutex_lock(&acm->port.mutex);
 
-	if (!capable(CAP_SYS_ADMIN)) {
-		if ((close_delay != acm->port.close_delay) ||
-		    (closing_wait != acm->port.closing_wait))
+	if ((ss->close_delay != old_close_delay) ||
+            (ss->closing_wait != old_closing_wait)) {
+		if (!capable(CAP_SYS_ADMIN))
 			retval = -EPERM;
-		else
-			retval = -EOPNOTSUPP;
-	} else {
-		acm->port.close_delay  = close_delay;
-		acm->port.closing_wait = closing_wait;
-	}
+		else {
+			acm->port.close_delay  = close_delay;
+			acm->port.closing_wait = closing_wait;
+		}
+	} else
+		retval = -EOPNOTSUPP;
 
 	mutex_unlock(&acm->port.mutex);
 	return retval;

