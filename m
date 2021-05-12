Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DBB37B801
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhELIcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:32:02 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41807 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230217AbhELIcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:32:01 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id ED2E815AB;
        Wed, 12 May 2021 04:30:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:30:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qQ61SM
        +bVh64+tzjvrp5t6sHhZOC2ac64BDDOLB7oHI=; b=EM47oaEKW16jKb07QpzXPD
        Z+G4ZmtW/5k5XUQE7bGIuSUNejZVKphHXIZEnTMdXvNfq4cEduyoprZzv3ELP+bT
        KJwweYyTdxzzMFAzquwzfbS5BfbFeoCyfuXKiHQFMB2OjMk2X4x/p2+9gLevhNuF
        JOrQqo3BN89sdiNBC74H5ugrEm2tPQX4bvVfCeQEz08Qx3FToiyyF+3d7qTZx8u+
        KzicqZq2JtZEpE6ivoT1kvwNnFW7avAvcMUNwLtlUGgtq+VmAojtSG73zVxDfTh7
        2Y9UzNlakY0l9jaNNT0LwAE0npWMeMgtyLkpkLzlwgBL5fMSJ+oO3Ssf2A6PATuw
        ==
X-ME-Sender: <xms:PZKbYDhXVAhNvG8Ib5JCJ1_8NDKXQDNLoz_phQkNC1vICM2VN3BIuQ>
    <xme:PZKbYACP25FxnlgIp28_kh2avdzP6YlNi9qRCM7jUyhdne_SOAG03x-z8ojsuiMSk
    5lV9emeEvK1eA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:PZKbYDE7Vihj_xBACA1aaLVGsTEpOjzG8854cYn4QV37oW27iPHZZw>
    <xmx:PZKbYASm9PmlnhFUiyIcGNrntfhHc7_nGpVTc1W8OeOus3SrM-qy7g>
    <xmx:PZKbYAwMRvpsqkHgqdDlkfulQWFVCKXATrjebtTttzjUWcSWyUZmdg>
    <xmx:PZKbYGYtQ-fupx2MMSUIV8cOuzkVn99JVU6pc58PA0Qm8fYJkksHJo7w778>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:30:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: fwserial: fix TIOCSSERIAL permission check" failed to apply to 4.4-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:30:51 +0200
Message-ID: <162080825130189@kroah.com>
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

