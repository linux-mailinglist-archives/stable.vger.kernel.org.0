Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5BA12C2A3
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 15:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfL2OT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 09:19:26 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46881 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbfL2OTZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 09:19:25 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A441144D;
        Sun, 29 Dec 2019 09:19:24 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 09:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=b63E8V
        kNS/HbFXAMkEQF7gwi4xVXkgEZmBFm+UDMv3k=; b=nNE0hIRBTYv8qJWAi0s3S1
        y+nXiMVwY7Q0lsrpBvMF865Sc0RTdvRLB8x1SUtyKtrkFx1pZ16Z/SxVSRUKNJpz
        KA7kMR1nmBIE99JSblbzFuXMPiMRZ/1A13u31UY0WMs4ppjFLTIFhQWX8LD91rBC
        1dxPxnPfsozCLcTWlHsh1o9XBjToGS1d+5pwlwmWxHCJXB80wElNMjrnMx9Yuwbm
        MGZdKcOca80rXkhyX6KaBHQXZeyYWHn7JAw5V/YiHTHoql1gSzjjReLjn853yp5n
        uOqwwPsUhPqr063lM5i2W4cXyJ7VekfRX8y0wxH0dcOuD8wOMNuMoynjjkTjxexA
        ==
X-ME-Sender: <xms:7LUIXvpNc8fimJVZqSAJsHgAHCWgGfSn4NL6wOR3_7I9KBlbEeIA7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:7LUIXrVq-8Um3rPsJ61XEdR4CjABZuo8RcIHlctX2AxRth614h83Mw>
    <xmx:7LUIXvq9xX8jVmEl4UzP70_SOE4kCAfW1qU7bLUg0z94eYxGqxbMYg>
    <xmx:7LUIXit1x1crA89rgjttaL7eoddPu18bZIyQPL5G5kbfdEcjJCSWAg>
    <xmx:7LUIXggYSGBdBa-TxEf7rXYae7XPD18d3yaNHOxhB_1UznBCkpAE0Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC2F88005A;
        Sun, 29 Dec 2019 09:19:23 -0500 (EST)
Subject: FAILED: patch "[PATCH] usbip: Fix receive error in vhci-hcd when using" failed to apply to 4.4-stable tree
To:     suwan.kim027@gmail.com, gregkh@linuxfoundation.org,
        marmarek@invisiblethingslab.com, skhan@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 15:19:21 +0100
Message-ID: <157762916119642@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From d986294ee55d719562b20aabe15a39bf8f863415 Mon Sep 17 00:00:00 2001
From: Suwan Kim <suwan.kim027@gmail.com>
Date: Fri, 13 Dec 2019 11:30:54 +0900
Subject: [PATCH] usbip: Fix receive error in vhci-hcd when using
 scatter-gather
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When vhci uses SG and receives data whose size is smaller than SG
buffer size, it tries to receive more data even if it acutally
receives all the data from the server. If then, it erroneously adds
error event and triggers connection shutdown.

vhci-hcd should check if it received all the data even if there are
more SG entries left. So, check if it receivces all the data from
the server in for_each_sg() loop.

Fixes: ea44d190764b ("usbip: Implement SG support to vhci-hcd and stub driver")
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Signed-off-by: Suwan Kim <suwan.kim027@gmail.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191213023055.19933-2-suwan.kim027@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
index 6532d68e8808..e4b96674c405 100644
--- a/drivers/usb/usbip/usbip_common.c
+++ b/drivers/usb/usbip/usbip_common.c
@@ -727,6 +727,9 @@ int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
 
 			copy -= recv;
 			ret += recv;
+
+			if (!copy)
+				break;
 		}
 
 		if (ret != size)

