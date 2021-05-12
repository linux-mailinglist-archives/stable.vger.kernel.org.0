Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721B937B7EF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhELIaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:30:24 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:39749 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhELIaU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:30:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A1BB5157E;
        Wed, 12 May 2021 04:29:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:29:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=eOIAkR
        ehqPQtbfRbzBG1h6rjvV9k4iryrYhi9WDEvrI=; b=IZNtyUUNsf6Cp6Sroei8SP
        5Cx9lMxpwiGyXouF4/DIaD+tz3MIUHoLV8l7PdpEYA/WpmgmQMpED51QlJ5+yRHP
        JHO6SLg25cbaBUgm/zaj/z1M/As7NJFqz1LWmWt3+XdyJVMfukcrAXVtWyRRWbbs
        QA4NokcicB8ACrPjrAzmbo1tZa/pbFuAtxCdWR3rBEpMsFI9rx8bGA+P1eQZRK2y
        Q5Alo8PIzOFkw1YJEPjmASO1SUeQfY2Zd9d5SvMUGd2KQPrkFPvWnX9Ct3Zk09fO
        5w1kzVFPzlRBV+L8tBQq8tVNkU56jL4tgVufl88vrUSskdOtIfvTwIvyd/twNaBg
        ==
X-ME-Sender: <xms:15GbYOIejxjhG2rG30ttfjGyTiDTktNn2oWy8FQ5zhSEAB_xVllP_w>
    <xme:15GbYGJO_caR11c9sceYKfa-uUR8Cp-BGi5fZ-akuooznv4kbZnx5Rp7ocCppAT1p
    i1ngx0FGczcxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:15GbYOvD_oPVnjgWjBtSnLCEYWfNxSbJsJH3_SKIM8YamScF6yrIvg>
    <xmx:15GbYDb5BcOCQbjr6BeplhkfKn9sz6fNm8wzoxNM44fEha1rlcOynw>
    <xmx:15GbYFZkfTX3m4W5-4PnEyc9qCJN9lG9A0x4j9VzKacYyUv9r4MmNw>
    <xmx:15GbYGBTyq1BddXI40WNBhTkTVaj82Za0vYvKZKnEZuT0oDv74-LBYeKhfE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:29:10 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.19-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:29:08 +0200
Message-ID: <162080814882252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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
 

