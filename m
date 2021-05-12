Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA9137B803
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhELIcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:32:13 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:56059 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230216AbhELIcM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:32:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 830D5712;
        Wed, 12 May 2021 04:31:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:31:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=urZc52
        v5h8IXYxhNsjnb3LfxY/IfsjrSEV9zbFrc1Dg=; b=GFEdYXBqsdwFriEFu01ns+
        k75VNHxpEcLwatsJupMhcpx0+XS0Uycmw5RTtEId8h1bWJaNjF1QntDMoOWw7Kx9
        VAxgUvx0FwM3R8exR5YynoYkQsxl4ksiUbCElLAU75edKgypIsDZvD0uOe5mTUH/
        uNCsSxIFQDQTlPbNkkJ6o+W6Cvj0pd0n4P/wgZTVZ+A8s/RdMjtcvhKEo6YJtcJR
        aDDYVohZquq4gJzJgWE1gv9qHBvDzCV9NxfplCuzPq1esUeHgd9PxWtdXHqRYPs7
        TfeYqBw3HepojrDY8PehmDlsj7FRdFttNsEV5ltYluTCcaFH2zzBaYvkHASQmL9A
        ==
X-ME-Sender: <xms:SJKbYHVk0x0x-cJtakBzQvSREHrVlnDoC7kHD-RrTyaN9HNg7-cY4A>
    <xme:SJKbYPn_FPmTU9J-R4r-1OSNtUlgiVYG66dDdCqow0tfUIlClUSOAb7K-4o8taDCB
    xWiwBvuPQESXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SJKbYDYL18oocp0X8O0b_i_erpkUADHT6T1_9vQ6mnEUrJVmjDCQBA>
    <xmx:SJKbYCW2TQAfp8r4JnwW2kJuxN0fPFybz_Qd9Cnrsu08ugc01N6ekg>
    <xmx:SJKbYBmQGy_R6n3zgGDvSXl8IF7lQXTqexWtNcQEkZ8_5CPOOBzXrw>
    <xmx:SJKbYAsZygZ7u-vRz31Tn13bOjBORYXDElIkdMouMsLQansdxV7U8qClr0w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:31:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: fwserial: fix TIOCSSERIAL permission check" failed to apply to 4.19-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:30:52 +0200
Message-ID: <1620808252103116@kroah.com>
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

