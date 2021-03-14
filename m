Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3768E33A4BE
	for <lists+stable@lfdr.de>; Sun, 14 Mar 2021 13:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhCNMXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Mar 2021 08:23:25 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:39613 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235441AbhCNMXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Mar 2021 08:23:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E692419409A8;
        Sun, 14 Mar 2021 08:23:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 14 Mar 2021 08:23:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Mi89Dy
        YX6i27PC20dNLa83Gc4sMrG7OFoXODMYKx23Y=; b=YtsHRvYJ1z9QhYMuamnwBP
        8SRQACEH45paEsqvxVWCeCRseugYGRhxfEIwhPbLERC1VesPD0FHa+Ejddnz3Zz4
        D1ihAe9ThNu1TXmcwrKNxJuZLCUQlZaRpqe4D2OgEwOXI/bSgO3w3bgtfYC3Q5vv
        KRGAOQadPGIsX52+SSEfCM0R+rwaPatsoNceGfxFkkk7kvL2YcS4hiIRJeLZzshv
        CO6h0pj93L45soMy6jYEbdW+B5zAHO+H0JzuXeKr0vVZKKQC4DAcbdsP50hBeYHO
        ZX2s9Af4XPBzoPnP5GW0018T8/XWhqztOm9ffdlfCaiYp95R2A/83O54vd9BDNyQ
        ==
X-ME-Sender: <xms:MABOYCE450nod8OxCUG9FI9s_tBjoXVZ9Q81Vrnu3yadZF7iP9mYbA>
    <xme:MABOYDWoQtjNMHJXqtvLaNXzzjakPBBZnQCSA3xvXkdY2EENQedBAwp-KDATvYovG
    vUTnnesdzJE6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvjedgudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:MABOYMKUvfUNqJBGibWMOnAQ7fvWvcfhwHPZP6wNeMAbSgdQR5KFKQ>
    <xmx:MABOYMEOGpntHqXITsizief_x82XnEsIa_ilZMl0XA0Dh6jNHZL4hQ>
    <xmx:MABOYIVyic0uvvWgagAmeBpLvwy09KJkj6WgcypK_KsHdCmS2kTBxQ>
    <xmx:MABOYDfRwQcNzHYeBaALn86oPcDC8gFUF8HUfbDKfQ_OjYjGhoS4aw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18F841080057;
        Sun, 14 Mar 2021 08:23:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usbip: fix vudc to check for stream socket" failed to apply to 4.4-stable tree
To:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        penguin-kernel@I-love.SAKURA.ne.jp
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 14 Mar 2021 13:23:09 +0100
Message-ID: <16157245893852@kroah.com>
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

From 6801854be94fe8819b3894979875ea31482f5658 Mon Sep 17 00:00:00 2001
From: Shuah Khan <skhan@linuxfoundation.org>
Date: Sun, 7 Mar 2021 20:53:28 -0700
Subject: [PATCH] usbip: fix vudc to check for stream socket

Fix usbip_sockfd_store() to validate the passed in file descriptor is
a stream socket. If the file descriptor passed was a SOCK_DGRAM socket,
sock_recvmsg() can't detect end of stream.

Cc: stable@vger.kernel.org
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/387a670316002324113ac7ea1e8b53f4085d0c95.1615171203.git.skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/vudc_sysfs.c b/drivers/usb/usbip/vudc_sysfs.c
index 100f680c572a..83a0c59a3de8 100644
--- a/drivers/usb/usbip/vudc_sysfs.c
+++ b/drivers/usb/usbip/vudc_sysfs.c
@@ -138,6 +138,13 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 			goto unlock_ud;
 		}
 
+		if (socket->type != SOCK_STREAM) {
+			dev_err(dev, "Expecting SOCK_STREAM - found %d",
+				socket->type);
+			ret = -EINVAL;
+			goto sock_err;
+		}
+
 		udc->ud.tcp_socket = socket;
 
 		spin_unlock_irq(&udc->ud.lock);
@@ -177,6 +184,8 @@ static ssize_t usbip_sockfd_store(struct device *dev, struct device_attribute *a
 
 	return count;
 
+sock_err:
+	sockfd_put(socket);
 unlock_ud:
 	spin_unlock_irq(&udc->ud.lock);
 unlock:

