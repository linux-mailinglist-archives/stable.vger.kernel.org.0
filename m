Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB8337B7FB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhELIb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:31:27 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:58661 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230196AbhELIb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:31:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B69EA155F;
        Wed, 12 May 2021 04:30:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:30:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aeRxKR
        ZgMZwqO2S2Lg5lUZvz2zysR/rce+fSfNvDnVo=; b=sls4PUMfES3uEDkCIU3jl+
        h3GKZ02yGaOjAzJeLhp2ol5W1V8YGCMq9NWLFHWvspT1eTpQ44lP42gj81s3MhKw
        U8H66mwwDoi4WzUq6RRkX//GUcTd4Aaj/J0ArBquMhiG2OQGV+JVFRoFRTamQg3D
        EjZprs4odztAN9nRY99vlZgKRCFIFJcWqt2AfD4v2fiW/R8HlhKbvVxi+r5tnFkm
        EvknQcOAoGI/l/egkoRJGRMJd+z7Vmn3qHVToH9dHV+i78twig8OxavisUxajTmj
        UTYI/AGC+b4tgCm1sSJwnJiqs82n+llNqBQTpQqHrZ8Qegmhs1OFi81dSfJNxZLg
        ==
X-ME-Sender: <xms:GZKbYP524gs_KqneiG9xUaISGU8Sm4MLXFvfd6cK1uOW5QT7tEbgoQ>
    <xme:GZKbYE76csRvk_LWhr5rp5BSMw_1cu0I3gLK2_1vozHmL_Ivt-3es63g5k0IW6ezA
    uJEB8rDWWd6uA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:GZKbYGf_Hk2u9eEmSSuxTObQ33BN9C2z1fXsGiAgo5-7gGl58xAZPg>
    <xmx:GZKbYAK1gLm5Gty5048_1lyAE32OqGeSrGcKP3iQebbr4kcaxaBGIg>
    <xmx:GZKbYDKiiHQgkW4KYr8pOy53jjAUpXAaN28VEiIq3HVSge30jtldVA>
    <xmx:GZKbYFwC0Dz7RjqNm7MO06qUs4XAutF_ZtN2s2ONWkG6vv0zXXAIsX37UPk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:30:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: fwserial: fix TIOCSSERIAL jiffies conversions" failed to apply to 4.19-stable tree
To:     johan@kernel.org, gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:30:03 +0200
Message-ID: <1620808203420@kroah.com>
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

