Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C4737B7F2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhELIad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:30:33 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:55489 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhELIad (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:30:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id DD191155F;
        Wed, 12 May 2021 04:29:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 12 May 2021 04:29:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I5Ib+u
        XBzmBPfcYeqXMEl26pBdXPJePYyTOGDJkFwKI=; b=nSLmLcKNAAc472gBPZrj0t
        7FuoK7j+cy6uxUYG5RJg55KN6b0/dgKcyZnPoAM9jkwbjM7Hl2jaSevrKLWsgTjr
        93i32yG61qcx+fQkF8jfQR+tFScBqoOzHUBQDxu3zSjKBbDeHRxnFh73Zm6frNM4
        DN5wDJbqeh23p3qUchx0nZR8+n3VLupVrNi2Szux+VeI7nAbj1WU/IHzmKzUcMYc
        Aj5rbqWzwKxCykNIb1kP/4QO52OEnpvEt4yqYpWkoxeHAVfBQa5kKwSA6BXlTDri
        9ez1J12+MoRf3dD1dW/ZsA6Vc00aTbEoziSng/k/pio043KnW/KQynNY+fWYxl2Q
        ==
X-ME-Sender: <xms:5JGbYJCoEZ2FtjlZ9-umX_Paorp-WPvglVdztTm137vcX5iwQ87DOA>
    <xme:5JGbYHhBrEpE_JqJgUEhom0XTWbS8E-_uvRsWNcf3lgHhiz8vfZ5g-jWnfPzwnzsB
    qBbWXp5kGlcEA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:5JGbYEkIKvBQM2eSFEHtg5YFUthv7SpHUXDlCFz50A7m8_1Zv-VP4Q>
    <xmx:5JGbYDyJhjtEyOjb-8NrALLW4YyLjWbnEr-IY97ytOyPfqcWey184w>
    <xmx:5JGbYOQaKP_LJpa__KkQ_o8inwZSA9dNxtwR2JYp5Yf-csjBoc0pjw>
    <xmx:5JGbYH6FasJuysZ8G9V2_YE3TjW1lemKi5BVpDQrfLx8XGGAyMtRQJ9A3Vc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:29:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.4-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:29:10 +0200
Message-ID: <1620808150186178@kroah.com>
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
 

