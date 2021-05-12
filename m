Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9A37B7F1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhELIaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:30:30 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:48235 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230213AbhELIaa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:30:30 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 56E8615AB;
        Wed, 12 May 2021 04:29:22 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:29:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NvmkY8
        jRUk99f/Nr1wC+McRr72461uv7J4K2dFR2ErQ=; b=uWBUW+FaUWhJ3E9Qd3AK5L
        8KIwnCD8yAGu85G2wtZnwXbqHW5vB7VepeyTn1pkGil85zNBfLkbZx6R4FxfKqzB
        D3F4rv27UQDZ/sFOv8MCceEUj6U5y2GZtOvNYuobgBtPhvZubxF2LLJfp4udR1nt
        Mc7KHvsrX5Bzx9BGQWBHSwpfEO/4mOxa0ff68TSH8k+IBgfW3U49Tf3UE/8YoJ74
        1E+fPRqUA+5IbfOjPbfYTrpvwiExXszaQalvT/eR4Qe2eNzuGT4sMPsG+7oyKlGv
        yT2GdkZ68vCAbE/tYEdtemWcx2Y7Op8XkTgjaKpDyVrej4NAEHzs396Ap822kukA
        ==
X-ME-Sender: <xms:4ZGbYK25HmnbKtm4BXD4AbtoSIR0yRmTCyCUNChStg7MvNH7LzjAGg>
    <xme:4ZGbYNGYWNYC8YRFwJjbI88BPANJyESnYIArcH17alU3F8HKu8yws-b2Ef4jp3_r6
    T_zFKEYbKN1RA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:4ZGbYC4vEfPRAc9822Z8ko082byD_TyLZ4d16m2r7GHAx8Mc8lpEbw>
    <xmx:4ZGbYL3W_5UPt9SEOTRO1-OvCzLj-2-kOKgeWoVhQcEQ1VaTmMhdeg>
    <xmx:4ZGbYNEAXNH7TLzAptBui9kKpQAyEjB0PPSMXWDsMeK75vwrW34Djw>
    <xmx:4ZGbYAPEd436YN3pc7mZTBZ_B3en0li03nw1sxNOHbcIkpjGRwQnxKfJJt4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:29:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.14-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:29:09 +0200
Message-ID: <1620808149220179@kroah.com>
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
 

