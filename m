Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914C437B7F5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhELIau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:30:50 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53095 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhELIat (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:30:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id CC79E1529;
        Wed, 12 May 2021 04:29:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:29:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=I6ZcAU
        fhHyd9nPrYRs9uBW/o+HOCalKuYZW1ulElAjE=; b=hfi4nQs13k0zN+KCBvx0JV
        y7YhvUpskAfuJBTNAtXoLhMHUsnJpV7Fkp8BV7VVKlgPaB4GsNU/I7XnJf2B51SJ
        r0b0HPacGLiMox0r4POZeSzL1VOHbiOdOPFy9oaMyP8plFPc74yDFTGE9eoJuY5C
        2mODnsJ5sl+1YAq9KjlVyTUckV8sM4c+NLR3uG3y9UqF1ttuIsclE2ul+BCVaROH
        YoXUCPKlD5+2mYkuGwWGYzUnTzcD+LaPH95DRwFh9qhqOgXCjhlI2HHDFsyY1iT9
        l1j4pxTMG3HryFWt5vLZBKeLZ8nHBywkkDMYzRTDvaH84bytLDFArCu0ZEqRhGCA
        ==
X-ME-Sender: <xms:9ZGbYB4ZQ6WSMKvjrCgEMu79DGXvZvEipvcs0y3KN46a5e-qi5wmFg>
    <xme:9ZGbYO7BwBlk_0phsnLjGR-OZ2PQRxx4qwqww2Yo4CbOc3ewDo-1PNq0mCBnfORnn
    qBT8jFUQQvr9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:9ZGbYIe-Fkjdcj-EZuN4jitJG9nislSVwdGB8yl-AO5c5ZGPlz5h8A>
    <xmx:9ZGbYKLVMxynPmIjWdjZyFbFYTo3pC-HWpGnC0Mp6Krb3Ni1VrPkPg>
    <xmx:9ZGbYFJGnT0MWyH8ZfR-wN5q9ORDO8_-C1F2X0od5hwOiCFrjFPwsQ>
    <xmx:9ZGbYHyFFPZBI6S929o5E6CkMYgUkR3rKw64uJ4PKYP5wLEDzwVgKUhROvA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:29:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: greybus: uart: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.14-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:29:31 +0200
Message-ID: <16208081712153@kroah.com>
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

From b71e571adaa58be4fd289abebc8997e05b4c6b40 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 7 Apr 2021 12:23:23 +0200
Subject: [PATCH] staging: greybus: uart: fix TIOCSSERIAL jiffies conversions

The port close_delay and closing_wait parameters set by TIOCSSERIAL are
specified in jiffies and not milliseconds.

Add the missing conversions so that TIOCSSERIAL works as expected also
when HZ is not 1000.

Fixes: e68453ed28c5 ("greybus: uart-gb: now builds, more framework added")
Cc: stable@vger.kernel.org	# 4.9
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-6-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index 607378bfebb7..29846dc1e1bf 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -614,10 +614,12 @@ static int get_serial_info(struct tty_struct *tty,
 	ss->line = gb_tty->minor;
 	ss->xmit_fifo_size = 16;
 	ss->baud_base = 9600;
-	ss->close_delay = gb_tty->port.close_delay / 10;
+	ss->close_delay = jiffies_to_msecs(gb_tty->port.close_delay) / 10;
 	ss->closing_wait =
 		gb_tty->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-		ASYNC_CLOSING_WAIT_NONE : gb_tty->port.closing_wait / 10;
+		ASYNC_CLOSING_WAIT_NONE :
+		jiffies_to_msecs(gb_tty->port.closing_wait) / 10;
+
 	return 0;
 }
 
@@ -629,9 +631,10 @@ static int set_serial_info(struct tty_struct *tty,
 	unsigned int close_delay;
 	int retval = 0;
 
-	close_delay = ss->close_delay * 10;
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	closing_wait = ss->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			ASYNC_CLOSING_WAIT_NONE : ss->closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE :
+			msecs_to_jiffies(ss->closing_wait * 10);
 
 	mutex_lock(&gb_tty->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {

