Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C9912C2A4
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 15:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbfL2OTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 09:19:34 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:55453 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbfL2OTd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Dec 2019 09:19:33 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 9FFAF44D;
        Sun, 29 Dec 2019 09:19:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 29 Dec 2019 09:19:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=B5BNJf
        FbqmwIIB+t2+yWdeueCKEy1tQrxJ726Q92SQ8=; b=dPZyAULWjq6COo/pG/ATOU
        TkDIhAGCoorPa1/5aHqCmoaKd5N4fEzdpng9L7U2OBuNF5JW4Fa7tIoWoKVoHyeM
        k32ExdJGjv9IJZrnpMgCvv8/HWy3YBZ1MYdhJMtPf6UsNEVxLWOGNpLpYB6sygDv
        CUrA1vASn/N16SCCM3MRmvu8p7506FsOazoJBLrZhkCbhCVfiKTJ4+b+bDFUgPrQ
        JoQLTxNzbmh80vKQgxuxtd2NWBimr/FXyWHJ4qLHF9VumkNVGB4nuHKvinfsfxSV
        vMljw+Q0WOH9wmhK3HBUUeiQFZbDttU9/UbDhwKufHHxbpdp+2Xc0nBrqdfyeymQ
        ==
X-ME-Sender: <xms:9LUIXk0GJ0OA9QBmAybLzebge8m2aLNTLjU5dATbMqpHnasXE1o72g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeffedgieefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:9LUIXrw3JQwouBf-mBndSZzGP7-YXwEbsbreNpSt0E3v8lzPK4jFcw>
    <xmx:9LUIXl_4pmFVdd2qoH5yhVuVnYV-rYYm_qlX79FYF08_clolxkh8jg>
    <xmx:9LUIXi1ICVO-BTpS4wG4768IiiRt5TmhfMrOgjUQWgNdqe9aliES7A>
    <xmx:9LUIXso0oMEGT2-GlyUneQcEmkRE-7WKnjdxx8dO8dcPPasV_GzuDQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF94130608D7;
        Sun, 29 Dec 2019 09:19:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] usbip: Fix receive error in vhci-hcd when using" failed to apply to 4.9-stable tree
To:     suwan.kim027@gmail.com, gregkh@linuxfoundation.org,
        marmarek@invisiblethingslab.com, skhan@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 29 Dec 2019 15:19:22 +0100
Message-ID: <1577629162172142@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

