Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C1718F496
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 13:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgCWM3t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 08:29:49 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:60175 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727548AbgCWM3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 08:29:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 873D84C2;
        Mon, 23 Mar 2020 08:29:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 08:29:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lwEXkx
        cAriNyajcixzQsfTv9IvMEiDpVAIkOAg0B9G8=; b=2cro3+xkU3A4nP0Vtzf1ME
        27bmSRIm2l5wMu7m5MxoHlOh0mEaanVcjpmkhM0CxGuSl7hj+BuVxFx+4YQQfTsC
        OXjh3t0UoQ+bmSAlzRFUs+uSvkwCoiXy4yxHX8VrJf+Rq0we+C8N8O1GeG7Y07uK
        czXIqVY2zwEM8289ZBDj05So3e2aPgSyqGHoB32AGJPMoUaAz69GVp70RjTHNL5L
        GPblsgH/VczR6MFBgt0T9GIjNLFEqHxPYZrRSJ4emfewSFFFYXXovjNXDEY0aFON
        m1C+XIOfZBcTWs5BHpwugY9w7xyoQx+pRtjl/Bd37ruqln6ewZuzGh7iw+k1hqIw
        ==
X-ME-Sender: <xms:vKt4XnTSWpBaiKjKEciH8dTFX160NA8wnSo1Z-5TQbakEhE4XtRAsQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:vKt4XhvfNVepEBHzg2Mu3UEJLGzvk1Uat0n-mNsx6VXvAIWLBzyfQg>
    <xmx:vKt4XhMQTk_SCZut3j3862p5_3ioXRlwy0S3GLgZN9VgFdiC2m3E6w>
    <xmx:vKt4XsRDAwV-FpYfYzK0BkEDRtmOYVpBgcdG2pdNhVmm4rCXZHU-Zg>
    <xmx:vKt4XikTEE1CoR0vVXdhbC-Ts-F9o7EtssZ_oY9kvjlWIQu7451BMg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5D1C3060FE7;
        Mon, 23 Mar 2020 08:29:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: cdc-acm: fix close_delay and closing_wait units in" failed to apply to 4.4-stable tree
To:     anthony.mallet@laas.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 13:29:36 +0100
Message-ID: <158496657625549@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 633e2b2ded739a34bd0fb1d8b5b871f7e489ea29 Mon Sep 17 00:00:00 2001
From: Anthony Mallet <anthony.mallet@laas.fr>
Date: Thu, 12 Mar 2020 14:31:00 +0100
Subject: [PATCH] USB: cdc-acm: fix close_delay and closing_wait units in
 TIOCSSERIAL

close_delay and closing_wait are specified in hundredth of a second but stored
internally in jiffies. Use the jiffies_to_msecs() and msecs_to_jiffies()
functions to convert from each other.

Signed-off-by: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200312133101.7096-1-anthony.mallet@laas.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 62f4fb9b362f..da619176deca 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -896,10 +896,10 @@ static int get_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 
 	ss->xmit_fifo_size = acm->writesize;
 	ss->baud_base = le32_to_cpu(acm->line.dwDTERate);
-	ss->close_delay	= acm->port.close_delay / 10;
+	ss->close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
 	ss->closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
-				acm->port.closing_wait / 10;
+				jiffies_to_msecs(acm->port.closing_wait) / 10;
 	return 0;
 }
 
@@ -909,9 +909,10 @@ static int set_serial_info(struct tty_struct *tty, struct serial_struct *ss)
 	unsigned int closing_wait, close_delay;
 	int retval = 0;
 
-	close_delay = ss->close_delay * 10;
+	close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	closing_wait = ss->closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			ASYNC_CLOSING_WAIT_NONE : ss->closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE :
+			msecs_to_jiffies(ss->closing_wait * 10);
 
 	mutex_lock(&acm->port.mutex);
 

