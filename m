Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6707437B805
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhELIcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:32:23 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:51663 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhELIcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:32:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id D1041D44;
        Wed, 12 May 2021 04:31:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=03bwMH
        saXwk0u0+9IqmkiHOe+XGOxl7EPVnMjuRayJY=; b=LYyu501ykGpNEiKwB0HriK
        5a0AjTFA+r13pah8PhmfT45cxvTdl7Q+UbrK2FWcoeIArlHqr4OodOk4ppJ76u3y
        jIHCL0p7vlBf9qgQclw7quLNmrztI/7a6l2lmtiCli2Zr7q/RiHbsMXzgcyDFxj7
        Blb/5VzUtKeW2HYku6J/2coEpDAJFYMNP9AVVFgu/K+iK/mObndadMw+Brj8+OsY
        jKXQmYXtbjvepMPQJhILn5la4yUd78ANRb3IPpmPXFEZM2KWFeF1EWlSWbOr9qVn
        91t3+ZHiwSWtc4LyQrS5MpLaO+KPPIZtNLjyfjLdzlPPXpbbIGcA28jD1/qBpZNw
        ==
X-ME-Sender: <xms:UpKbYBGy-lZfPTG_ZTF7Nw7CDShOtyyx6SDi9k-V-5SjS7OQ63IUFQ>
    <xme:UpKbYGUzW3I7cH21-HEMaSpVahZ2eJ9rqWsKSXKwvPovs948LP8jGm6_tvZuX6tnO
    -eOtUjbtCWNAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:UpKbYDL4fY8wYV0FCUYU2aq6Zv-njrorPPodVAQkbT6Ctf8x4783tw>
    <xmx:UpKbYHEFm7RVDfArbYhWYXqmUgWlnFffrvIYY-n421cZIyGPoVrknw>
    <xmx:UpKbYHWbVGshBJ2CZuRZa4ljl4-I8RxEpQ-k4vRppQYUemeZCbknNA>
    <xmx:UpKbYIcp69GZFeZLZJVYaqKLMgqEjMVA7a63jiEsXQvVDtnIjGvs41Xjwu8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:31:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tty: mxser: fix TIOCSSERIAL permission check" failed to apply to 5.4-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:31:12 +0200
Message-ID: <16208082725170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

