Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9877637B804
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhELIcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:32:17 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:50115 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhELIcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:32:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A4219258;
        Wed, 12 May 2021 04:31:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:31:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xOxih0
        94mCezlZR/jPEzdHeRQ3WeW0eKwuGuZ7JWbGA=; b=AzYnGA+kmrUMm3lXcgcxu6
        EOTJ25BU3Hf1M9Lat2m/UsFFJxqggo9i6pGXRdyZLADne3H41fBZLmUPmMJnRF3T
        kSGgWNZwMbYep6JjLmcb5h26ZDq/Ci+fWTZdmD/buvfvWc5tWN4boRZHNbFscWqx
        uLKffvV/5rhtEPl5ueFuv6JKZ2mqGDgnFBJFjVvTanycy8K6H2cR+5hb1mu9F2rq
        r0MYuapLAZr02XdkzDR7U9c72NTn/w7qe60kYriTZ1W5zRuInVgXAS3ynLwOqM99
        ybWV0eBvnNGBA+R/utGlgFaFThei9DoW6wN4X9LNjsFKMlelxKT4iGcXvilUnhyg
        ==
X-ME-Sender: <xms:S5KbYLukJ7lx4wOrfoij8FLXIYLOBIQTtwJWqZtt71hEcb4HDUIapw>
    <xme:S5KbYMdBO8LLS82-mz9Vwhon5qVHrq185JeV780jM09axUEjMPV1bWoGrCANL1U_q
    K-wo0LaSS1IHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S5KbYOwjKB3lEf5AA_owjWOaxOvIM58cIgVFlfwwgxX-oLFEgxayGQ>
    <xmx:S5KbYKO_0ITaLGL3rH4OLTbTlxs1YfiuzwCh9xS5AdykAKwm1mMtKg>
    <xmx:S5KbYL_OlVnoJRMTwu1WOfmq4Z304JpkMP2qAzcDJ3TUMGBeVr3RhA>
    <xmx:S5KbYIFS5Z0y47Fun1QO_wiZz_1KE9XusWyy8o10EhEu0xm5-k9eOotD_Z4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:31:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: fwserial: fix TIOCSSERIAL permission check" failed to apply to 4.9-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:30:52 +0200
Message-ID: <1620808252142159@kroah.com>
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

From 2104eb283df66a482b60254299acbe3c68c03412 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 7 Apr 2021 12:23:20 +0200
Subject: [PATCH] staging: fwserial: fix TIOCSSERIAL permission check

Changing the port close-delay parameter is a privileged operation so
make sure to return -EPERM if a regular user tries to change it.

Fixes: 7355ba3445f2 ("staging: fwserial: Add TTY-over-Firewire serial driver")
Cc: stable@vger.kernel.org      # 3.8
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index c963848522b1..440d11423812 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1232,20 +1232,24 @@ static int set_serial_info(struct tty_struct *tty,
 			   struct serial_struct *ss)
 {
 	struct fwtty_port *port = tty->driver_data;
+	unsigned int cdelay;
 
 	if (ss->irq != 0 || ss->port != 0 || ss->custom_divisor != 0 ||
 	    ss->baud_base != 400000000)
 		return -EPERM;
 
+	cdelay = msecs_to_jiffies(ss->close_delay * 10);
+
 	mutex_lock(&port->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {
-		if (((ss->flags & ~ASYNC_USR_MASK) !=
+		if (cdelay != port->port.close_delay ||
+		    ((ss->flags & ~ASYNC_USR_MASK) !=
 		     (port->port.flags & ~ASYNC_USR_MASK))) {
 			mutex_unlock(&port->port.mutex);
 			return -EPERM;
 		}
 	}
-	port->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
+	port->port.close_delay = cdelay;
 	mutex_unlock(&port->port.mutex);
 
 	return 0;

