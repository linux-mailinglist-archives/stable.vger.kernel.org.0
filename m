Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBAF37B7F9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhELIbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:31:23 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:54487 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230312AbhELIbV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:31:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id BBE831552;
        Wed, 12 May 2021 04:30:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 04:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=TAPRpY
        PW7wHuwlOfKe+t9L2lISRBlxOQ0cTpyS1JTKw=; b=GmehQUoiLBUZMETDm8HJWd
        oPIG36QnzNV9SNsK1jmYps1FnMiONRqxrR3PPY5mhJJ7kb+l3JmmW+nVwK2sSoVE
        DSxJiJDgNMiYeeGZ24ua+v9jauwsRhgnK58RAOqF8YaPllXbp9kX8LphSyVQDC79
        thub7zBEAssc9QdPMz7S+4LnmH2px1zqvxKi3+P/VpsOyRunvntWtUhmj0Xmlf9m
        dYjQdrBJhjHH8g5wzpRlfSyPVzfG2OMaYUcwotFTcNq9u8IVOXtrA2QJUWtGtqk5
        qamp3YRrOGT3Z2VAtJVm5uotKXLOJ7ae7HPx5N0N0s4bcZLGtLFHgJShjumpEaTw
        ==
X-ME-Sender: <xms:FJKbYCl-7N1OCm09Oj2vXq-V0oMCT0kXHfWD6TfK0_kXtyOq85Mv5Q>
    <xme:FJKbYJ2pzBrg-4ORouFP8PDH99NGkOPTP5wxxMn8sNMw2Jq1bTgyfyLCQnQsPNWGW
    S9TO1RIM3IIsw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:FJKbYAqeo8M9hrJsiiLa5Z-NcqAfTuUT86zpV4R7ia_x7Mm1u-Bwkw>
    <xmx:FJKbYGmywu7JNRdG-PVc4RDrf2KPJkEsBx3rk09_OEJlGWSN-JRPEg>
    <xmx:FJKbYA0RQFhGPB_x93g1WICTirjpFRhp_W_R53xDiQgnT53JixgTBg>
    <xmx:FJKbYF-y_gzAy4u4--tzSnfWU61FgV9FWxQ9JTrUNb-odG7lpeAAN6loef4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:30:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: fwserial: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.14-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:30:02 +0200
Message-ID: <1620808202132120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7a3791afdbd5a951b09a7689bba856bd9f6c6a9f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 7 Apr 2021 12:23:19 +0200
Subject: [PATCH] staging: fwserial: fix TIOCSSERIAL jiffies conversions

The port close_delay parameter set by TIOCSSERIAL is specified in
jiffies, while the value returned by TIOCGSERIAL is specified in
centiseconds.

Add the missing conversions so that TIOCGSERIAL works as expected also
when HZ is not 100.

Fixes: 7355ba3445f2 ("staging: fwserial: Add TTY-over-Firewire serial driver")
Cc: stable@vger.kernel.org      # 3.8
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407102334.32361-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index c368082aae1a..c963848522b1 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1223,7 +1223,7 @@ static int get_serial_info(struct tty_struct *tty,
 	ss->flags = port->port.flags;
 	ss->xmit_fifo_size = FWTTY_PORT_TXFIFO_LEN;
 	ss->baud_base = 400000000;
-	ss->close_delay = port->port.close_delay;
+	ss->close_delay = jiffies_to_msecs(port->port.close_delay) / 10;
 	mutex_unlock(&port->port.mutex);
 	return 0;
 }
@@ -1245,7 +1245,7 @@ static int set_serial_info(struct tty_struct *tty,
 			return -EPERM;
 		}
 	}
-	port->port.close_delay = ss->close_delay * HZ / 100;
+	port->port.close_delay = msecs_to_jiffies(ss->close_delay * 10);
 	mutex_unlock(&port->port.mutex);
 
 	return 0;

