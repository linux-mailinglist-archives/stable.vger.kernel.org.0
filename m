Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC29837B807
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbhELIcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:32:33 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54121 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhELIcd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:32:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 4F3B630D;
        Wed, 12 May 2021 04:31:25 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 04:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3ZorIo
        8iMf8XJmPLu7pAOn8ptsVEaKMlbDxOdAGS6fM=; b=to5+CrN1jt1fDjc1YC4Lgi
        lEcvfOTFuTdAd7+Aj30OOru0C1F8VxN6VrZZS3oCzqKF9my19HhEcD4h5xU0XJAJ
        8wEwB+AFu0VgOPGsbGsWA7Rh7A/HCx7WKz9chQMyUhpjZAVl+5lJI3CrL6NqxiEc
        KNiE2fR/T0DkeppUmiAypLgTUuAmCPLFx0U7i76eP1yTk6M6l/0PGWqO68jYigGh
        rBvkQ/mjQqPw4TPZFVgDHnYO6GWqYBRw/KU5jdzVuUsviSB5EtcTbVWtKaQvnWQC
        3/vEXzyNei7GFAUSLExkAn79Q3qVOIIzwqAInqX6fneQUomAOOPj5abEZN4f+Pjw
        ==
X-ME-Sender: <xms:XJKbYJEN8qRbQavTDFSLAwKYpBWooISRxihV9F2qxiuCzDDLUA6OQw>
    <xme:XJKbYOUo4jpThuCAvQwPRqrG9VP59Gh_4GD0FqGE_oUOQ9ACIoZxLeWOmpRmJ-psE
    N86XmyljS-Bfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:XJKbYLJ_hYNSw2taMy7JE3wOchRYbOR8E1y2FPQ6YMZv8fw7uyrV4g>
    <xmx:XJKbYPG2jEndJ2pLbfYFqciwu9QPaUcaA7lwzPtnYLLJZOye9wsDaQ>
    <xmx:XJKbYPUutp27UoaAiURgOigZISHlkIqix9d9DYapIKDQdkHoHBuN1g>
    <xmx:XJKbYAchjAmURXQhB5JDwrj2zm9xK5ivMLC-Iu5MvnIBZdiFV9nR1Uzdiqs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:31:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tty: mxser: fix TIOCSSERIAL permission check" failed to apply to 5.11-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:31:13 +0200
Message-ID: <162080827311131@kroah.com>
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

