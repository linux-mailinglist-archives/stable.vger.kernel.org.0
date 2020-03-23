Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE13918F490
	for <lists+stable@lfdr.de>; Mon, 23 Mar 2020 13:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgCWM3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 08:29:38 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:53631 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727663AbgCWM3i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 08:29:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 71A6147A;
        Mon, 23 Mar 2020 08:29:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 23 Mar 2020 08:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qFZbIg
        gDzy1pKo+XqZ9IhZ2BpsUEvdUTXI3FvII8O8Q=; b=ixyBpYYSk1lCM1IbxfKsD8
        8UNenhVZMLevsYQLtzZFrxdDlxBvclvTpNWnPX1iKyM5uxbgK72HUEuDbMqetdrA
        0qkFUdoCHrX5srNVGKusVVt1UJwU93x/Cyun1d1JQIvWu3g4KPTNOro6BgDtbrJB
        aRrtJpKerYT5B007dxZSe2OSvrb/HEbUZUmrORhsjdg9kbhouskMH/JAm1VrhsTf
        smIvk8GQwqlvvLWUrYQ6GNWH0QLgx/zuj1uiORW2mzoW1eCGIqhdqTtW8qxh8GUO
        dbBHBgpeI9LbhBWXE6LN0aFOEeG1ryRF2oeiTSyqyxwJ0z9JxFPMYwZWFGVk4LJg
        ==
X-ME-Sender: <xms:sKt4Xi-FYD36mme1apgbAte67oc_LQA3vqWeK-X30yYd3cE0ypgHFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudegkedggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sKt4XmDdplm06dN4WGXArdB3DXWLFlp30Em6wVaABEcmlhfvCOXkhg>
    <xmx:sKt4XsErqHl5P75bYb1JWij8759GNk7-gGF9RksNF7xHAhnEQxS7TA>
    <xmx:sKt4Xg1Rpcz9DIwSiUmhd06NIQECgbrQy-aSv4eM7enYYq7JLC6UTQ>
    <xmx:sat4XpqKMI_6DNMIAgjxz2LpsPeVojh86jVLi6y-UBMD50Gjz9aA7g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E04E328005E;
        Mon, 23 Mar 2020 08:29:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] USB: cdc-acm: fix close_delay and closing_wait units in" failed to apply to 4.19-stable tree
To:     anthony.mallet@laas.fr, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Mar 2020 13:29:35 +0100
Message-ID: <1584966575115159@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
 

