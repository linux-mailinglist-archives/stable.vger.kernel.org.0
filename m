Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B0B37B7E5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhELI2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:28:22 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:36269 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhELI2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:28:22 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id D617A13DD;
        Wed, 12 May 2021 04:27:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 12 May 2021 04:27:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=LG/7BC
        SiDU48mUO8aLBYbP0irsQl9lNQ0LS0ZCCvxFI=; b=gBGo7VcTscWE+YLwnDmNRV
        k2OriY2o9OWdcrHuI+F0DzUBj4iPWTVL/DnH+ej/fTTeB/iDUmVaOwsOwk1Pt6Jg
        SpnEIQVvyvrWTUHrUEDaaj7DgpIbEH6dzH5McoPuSexj7fRhVCvmjihN917B4buA
        8DATLGqHKGS5H+pRqn/RTsMcZn6cd1+FSICIw3w6z59SKmNOqxlwugOkuOabQh6K
        Lx0LElJCBar/S5LRJcotJWe8hFlLfMWk7KXLoQ3e4+FOF7eTo+3H3DYXSV04svUP
        4EjdL8NE2s+B0PIxpGXT2DCLiGybiQSqRC4MvLkSfVKtOkrAGIn6XQAPuS3jkJbg
        ==
X-ME-Sender: <xms:YZGbYOuldza9nMz5KAXn9x6dH7c4kbDuSSkzTxi401qdwU49gSZdOA>
    <xme:YZGbYDfjnLaJqul8dWiL3VJoQ-O2xgkt_G4a1_62M3ReGdKqItT-ZEy5hfLArdOZU
    c82X9Zs5c3whQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvdcutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttdflne
    cuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeen
    ucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekgeefle
    egieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:YZGbYJyABNXXnK5JS64xTEB8lwQln377hoYuzbr5q43pB9dZ_PpZeQ>
    <xmx:YZGbYJNWKttTEtr0ZxDjXmMksSvTqtcfPkN3VLSWV5Wk4v15dAlygA>
    <xmx:YZGbYO-yluAlVk3DaBUt9Uld3lIagbg9EhZaOz3OtrABz_DOvT4JrQ>
    <xmx:YZGbYAKP5ZbEwzt_KKVoefjaJOLo3wvyp48-jXMWne7hWe-eEEta_MjLix8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:27:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Revert "USB: cdc-acm: fix rounding error in TIOCSSERIAL"" failed to apply to 4.4-stable tree
To:     johan@kernel.org, anthony.mallet@laas.fr,
        gregkh@linuxfoundation.org, oneukum@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:26:59 +0200
Message-ID: <1620808019105157@kroah.com>
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

From 729f7955cb987c5b7d7e54c87c5ad71c789934f7 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 8 Apr 2021 15:16:00 +0200
Subject: [PATCH] Revert "USB: cdc-acm: fix rounding error in TIOCSSERIAL"

This reverts commit b401f8c4f492cbf74f3f59c9141e5be3071071bb.

The offending commit claimed that trying to set the values reported back
by TIOCGSERIAL as a regular user could result in an -EPERM error when HZ
is 250, but that was never the case.

With HZ=250, the default 0.5 second value of close_delay is converted to
125 jiffies when set and is converted back to 50 centiseconds by
TIOCGSERIAL as expected (not 12 cs as was claimed, even if that was the
case before an earlier fix).

Comparing the internal current and new jiffies values is just fine to
determine if the value is about to change so drop the bogus workaround
(which was also backported to stable).

For completeness: With different default values for these parameters or
with a HZ value not divisible by two, the lack of rounding when setting
the default values in tty_port_init() could result in an -EPERM being
returned, but this is hardly something we need to worry about.

Cc: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable@vger.kernel.org
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210408131602.27956-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 3fda1ec961d7..96e221803fa6 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -942,7 +942,6 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 {
 	struct acm *acm = tty->driver_data;
 	unsigned int closing_wait, close_delay;
-	unsigned int old_closing_wait, old_close_delay;
 	int retval = 0;
 
 	close_delay = msecs_to_jiffies(ss->close_delay * 10);
@@ -950,17 +949,11 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 			ASYNC_CLOSING_WAIT_NONE :
 			msecs_to_jiffies(ss->closing_wait * 10);
 
-	/* we must redo the rounding here, so that the values match */
-	old_close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
-	old_closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-				ASYNC_CLOSING_WAIT_NONE :
-				jiffies_to_msecs(acm->port.closing_wait) / 10;
-
 	mutex_lock(&acm->port.mutex);
 
 	if (!capable(CAP_SYS_ADMIN)) {
-		if ((ss->close_delay != old_close_delay) ||
-		    (ss->closing_wait != old_closing_wait))
+		if ((close_delay != acm->port.close_delay) ||
+		    (closing_wait != acm->port.closing_wait))
 			retval = -EPERM;
 		else
 			retval = -EOPNOTSUPP;

