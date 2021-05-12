Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AB237B806
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhELIcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:32:31 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52853 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhELIca (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:32:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D5CFC1369;
        Wed, 12 May 2021 04:31:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rg7cEF
        EKhHaUNiXdB4RVkpviYc0AlXInsKT7GDEahtM=; b=coAQl3kAomPNhH3p5APw1N
        JjswvplMy4xkZE6MtZsdq62NrAYw7wjO9hO8f4pjZPIUUOC3D5piKvpmZO2fsa7D
        gldVAQ7ztPb2GmTijORBXpCnvyBaMejHaiiPXhhliwSqg5yLtn7InsThnCghbts6
        g3prS1P4VgqIBmRKGNVxJlFZSgVhej4yPOzgbK8xCaOUxJOjBJJVoeY6PBP1F8PG
        pEkrqvDd9O+s88lD+dx98MgdRKhYoDeVRQMv14QthvsU++UG/QYOt8DDsxxSC/Lx
        WpSVgPUT8H+kJnJbvd3I5FiUMZN9mK00Nqbe2c4oy5k36VurSkB6IxFbc6Z69snQ
        ==
X-ME-Sender: <xms:WpKbYM1qIBLZSJq6NSOGd9zOq6xxqhTp-30VljVqUOtmt4EC7bUVMg>
    <xme:WpKbYHHDs1rwSW9UjeRzQw39WDrN-R3V2Vp6OQUz1hRaC6s1QQr7lgjfYfhuzm2nM
    WRtDK_AkvLqAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WpKbYE4VrkGKgr5jmW5_6Tag_KoKc9SN4Udbhn_DnTRtfykZzXjm0A>
    <xmx:WpKbYF2SDuv34jtbC5BPs3Mv3PYpMxlUJqEo-waCbWdRu0pOGNVrKA>
    <xmx:WpKbYPGjs_yyxJ-pdSkjFTM8q4XSLRnwuo-bP9ASY4eYhVkiuHUDuw>
    <xmx:WpKbYCNOP0VG719QCz_l-DpND0KfPwBEwi8mIo6E-NZyy86l_zifBOR9SUU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:31:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tty: mxser: fix TIOCSSERIAL permission check" failed to apply to 5.10-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:31:12 +0200
Message-ID: <162080827212627@kroah.com>
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

From b91cfb2573aeb5ab426fc3c35bcfe9e0d2a7ecbc Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 7 Apr 2021 12:23:32 +0200
Subject: [PATCH] tty: mxser: fix TIOCSSERIAL permission check

Changing the port type and closing_wait parameter are privileged
operations so make sure to return -EPERM if a regular user tries to
change them.

Note that the closing_wait parameter would not actually have been
changed but the return value did not indicate that.

Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-15-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 914b23071961..2d8e76263a25 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -1270,6 +1270,7 @@ static int mxser_set_serial_info(struct tty_struct *tty,
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((ss->baud_base != info->baud_base) ||
 				(close_delay != info->port.close_delay) ||
+				(closing_wait != info->port.closing_wait) ||
 				((ss->flags & ~ASYNC_USR_MASK) != (info->port.flags & ~ASYNC_USR_MASK))) {
 			mutex_unlock(&port->mutex);
 			return -EPERM;
@@ -1296,11 +1297,11 @@ static int mxser_set_serial_info(struct tty_struct *tty,
 			baud = ss->baud_base / ss->custom_divisor;
 			tty_encode_baud_rate(tty, baud, baud);
 		}
-	}
 
-	info->type = ss->type;
+		info->type = ss->type;
 
-	process_txrx_fifo(info);
+		process_txrx_fifo(info);
+	}
 
 	if (tty_port_initialized(port)) {
 		if (flags != (port->flags & ASYNC_SPD_MASK)) {

