Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E304737B7F8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhELIbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:31:13 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:39673 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230284AbhELIbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:31:13 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id EDF6213FF;
        Wed, 12 May 2021 04:30:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 12 May 2021 04:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7G4htr
        hmyATC/1XPYlIzxShPqP4MG2XEbgwaCiDazn8=; b=c6S9PBFnrI8BsGSNkVhcQx
        NIkWMT0M0NpP0ZA2LNcbZ5cwTeo0btxNwQis1+drDHn+O9dNxiX2vvd+IGbfYrTw
        vP5CKTvKbnPsynBMoV428WKrjTvreOkp5iVDz7O8B+Ty0qlIyOQ2bCH9JNyasQOS
        kw8Beyvl8+Qxh5uqx0gjFjSejhRAlAuKN+YfbwDwSIzPE8JoYvUdHWC/q45dyncD
        ZZJkWplapDaxyyXF8X9xJkJlr38mPlVPntTOXBrn1ReDEckjv+qqARb12QHwQV16
        1J02386/GMZgBnCMEC7owde4lre8NdQCPXYdejOvsgzWnmg4U5V0TPZewMSz5qKA
        ==
X-ME-Sender: <xms:DJKbYIH9U4ieoOEU4anQcGJJT8b3x088aeOx9XcsUcU3etCI4HJ72Q>
    <xme:DJKbYBXyZloxfsBqc8qNXuSQ4ooFpGV-m1gQMK21IG1dcEswfYYqYxojVq5agR5fY
    KdDyFsjf87qXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:DJKbYCJJEFQx1XRT7YI5ZyGPMR_-2IOHNo2cXBLKRjr5Y8nLOT2jAw>
    <xmx:DJKbYKEb35ily8Hzx7XFwtvpJvvM8E-t0X2pjGYPPJkWCSzLjZ7PJw>
    <xmx:DJKbYOUtgdyC3JaA6AwNY4XP-GQZ_dOG_5P0HLmbhu1a-DAIKiu22Q>
    <xmx:DJKbYHeovMuM5B9-vqNuZjOUwFVnGalSWhWNii7M9h-QDxQRuTpJgpuFKjI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:30:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: fwserial: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.4-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:30:01 +0200
Message-ID: <162080820111587@kroah.com>
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

