Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F274937B7F0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhELIa2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:30:28 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53613 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbhELIa1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:30:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id E7A14158D;
        Wed, 12 May 2021 04:29:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 04:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hHsH3Q
        lS257yUi5QVSwTflJkYQ2srbcegrGtEaOCpnw=; b=nefkhQGR1yNVjNJrH6j/OV
        bvfTnGdW+eAGpgBoUkSH6aNIwdRkSC8H/eiTb5IYPcEifoXvjivNpBAoxppwhuCn
        h530t3dx79LppVpiylTBm87VDJjWHp+r357TDc4qdY96cYHd25rw0vKp96GYSMSk
        ZzcB5KC03InaEGuMTp8hhjWsW3pDZpNwx17Ms41RF6hzvCa0pC1g5rCsIeSQNtM+
        KuY5kPDYxTurIG+YhhjG06n0Krfil2kCVr+NLCDjkbInuD2yWJ5z/QN0E/Zp/LWZ
        hcmax1Da9vV0ZYAXz8Hm2Kd4Cb6AJrfXm3natBiQnDvbxlBUyixM3Zxcu5fU3+nQ
        ==
X-ME-Sender: <xms:35GbYG9yc4eDzefOpKmWVAIFF3xYbrWd8SbipU8fTxz2ZizORCsrOw>
    <xme:35GbYGuPQW3xpU8RCGg1kn0gtNIZxDKaflllaPyZsscL5kodOpmwRusiWoaRtFFBU
    I1OnONYzf9TsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:35GbYMCKyGP3Qlsi_6yQtBlWDlAKh2cJAY3duHRF8Cx3pP5de3QBnA>
    <xmx:35GbYOf_7lbOXixAym8UHYA33oTJ2CA7i6kxsu7NzDU0JGngE-azhA>
    <xmx:35GbYLND5DQzUqYclis_5XniBVoENQ72PthNf5YkcojGv0ulsunpJg>
    <xmx:35GbYNU_FOELY2ilbAQ3EyG9ryXYfmsxmjtxBmqCfRVmPwNThEA2uQ8q904>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:29:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.9-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:29:09 +0200
Message-ID: <1620808149222248@kroah.com>
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

From 3d732690d2267f4d0e19077b178dffbedafdf0c9 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 7 Apr 2021 12:39:16 +0200
Subject: [PATCH] USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions

The port close_delay and closing_wait parameters set by TIOCSSERIAL are
specified in jiffies and not milliseconds.

Add the missing conversions so that the TIOCSSERIAL works as expected
also when HZ is not 1000.

Fixes: 02303f73373a ("usb-wwan: implement TIOCGSERIAL and TIOCSSERIAL to avoid blocking close(2)")
Cc: stable@vger.kernel.org      # 2.6.38
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>

diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 46d46a4f99c9..4e9c994a972a 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -140,10 +140,10 @@ int usb_wwan_get_serial_info(struct tty_struct *tty,
 	ss->line            = port->minor;
 	ss->port            = port->port_number;
 	ss->baud_base       = tty_get_baud_rate(port->port.tty);
-	ss->close_delay	    = port->port.close_delay / 10;
+	ss->close_delay	    = jiffies_to_msecs(port->port.close_delay) / 10;
 	ss->closing_wait    = port->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				 ASYNC_CLOSING_WAIT_NONE :
-				 port->port.closing_wait / 10;
+				 jiffies_to_msecs(port->port.closing_wait) / 10;
 	return 0;
 }
 EXPORT_SYMBOL(usb_wwan_get_serial_info);
@@ -155,9 +155,10 @@ int usb_wwan_set_serial_info(struct tty_struct *tty,
 	unsigned int closing_wait, close_delay;
 	int retval = 0;
 
-	close_delay = ss->close_delay * 10;
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	closing_wait = ss->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			ASYNC_CLOSING_WAIT_NONE : ss->closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE :
+			msecs_to_jiffies(ss->closing_wait * 10);
 
 	mutex_lock(&port->port.mutex);
 

