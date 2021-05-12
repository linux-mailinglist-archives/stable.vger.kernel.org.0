Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C3A37B7F4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhELIal (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:30:41 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:50459 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhELIal (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:30:41 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 54198157E;
        Wed, 12 May 2021 04:29:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 12 May 2021 04:29:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NI0F6a
        dDBDtGmvHhsTx8sZVchToYvTarzuuLu+WqGFM=; b=K081o30FJoXtQKmIj/Bo2l
        KNw3Fs75D2U83DlCmX3xIFVIW19oGmSdkpmd9p4BVmalnscZJem/5mK9+4lOMc3I
        kSJecphIM5uuZpcF8vJv1mtIAewxA+41piAZmXWjUU9HT8hkLtNyBaBQ6OMUpi2E
        kmJDng0QdGX4MIInbkgfMCFmCQs/yjziXJ9d+vO5OmbIPXRqpGC+mUTIumDLJsfO
        FAk0lu5dxbnkvOIWISXZGQrJtBvWzcuDs/nHh9Tia58BaGz17fDwEWxiCE/iQw4p
        FXF8wftnyUIU+Ep31oSzsVXz+H4WIi/IiibMyohwk8XvQ34R1KNj9uoV3Un1JLJQ
        ==
X-ME-Sender: <xms:7JGbYCIMNw-nru4N_Tt2URFd7LpjwZQmRnMASHVs44PxHs-FeMdcOg>
    <xme:7JGbYKLSpOInz0pRJ_WK06HsEWoSSJL4RvT2Lv1Khr6K7wAjmRN1DAWJy88MqIj7_
    oLhjg84uwM1MA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7JGbYCuTIzZV5clWRwr2FhKYLgHk4_IzCFqTsboXwjwE9ikw52tIjg>
    <xmx:7JGbYHa35T3mWMp3C-wtmJZV--JcPxWTOqkgnsgJj9UO_bFhbQl7JQ>
    <xmx:7JGbYJblrm6IJmVD81e8WMKrfKOeoySIzWbuOKQPnpmAFBsUM5qF0A>
    <xmx:7JGbYKDKgTX7_4X27gS6tS0zjP-Ms17l5dYuFHJB77konqu_6jwIo007nCM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:29:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: greybus: uart: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.9-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:29:31 +0200
Message-ID: <1620808171145222@kroah.com>
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

