Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5D9539508F
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 13:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbhE3LG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 07:06:59 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:35101 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3LG7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 07:06:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id A96B3194059A;
        Sun, 30 May 2021 07:05:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 30 May 2021 07:05:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=tJ95fx
        zK+LV5Djod6odAp8UuM2wq06voZHAK9W+i57k=; b=kUIU1I/4+qjE5q/FszoHip
        rGyjoVG2jXVH/xvyj6GTV+PtjgVQuPr7BS4bndSOO8o3YR41/1n1xGATJJg4MpUA
        Av0Yh1M8kA4KcEKKCX9mkFEgsCFSUlbyFkRUl8/H7AOP605r170IrAo4oY/n5La3
        5Vw1flXwEaS/+T6bT0TkcrZkQmLq3Qzr7grrXiZr/QQxRDoUPfQzH/saj+mwxl/I
        QdBTDxuPJA3w45HLxGcnRTkcmm5sDd8mxL4PLS1chlrujssPJe8ZWNU+q3gjW8WT
        mLaeS7TPFrIqmceNjaSnYHhKMC7+G5jpHo9nfxS9ip8SZdu8+NpnwBvuOtKZeATw
        ==
X-ME-Sender: <xms:cHGzYHnX2JT6PC96mZ9PpCWHp-LFf0k3vD9qThC1ZbzfaXlgN0N5Qw>
    <xme:cHGzYK2QbAuwCioppAQIbCUUVlFC2tz6e1yLZPFwkJHQX4U9F1O3YKK11B6A05JH1
    af1Qg_5gCwXBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cHGzYNpfEcT8NHA18xEOKUgNaLKN8oBEnlvQRvA9DTM6Wf3dfIWWqQ>
    <xmx:cHGzYPkXX8UbP9McjNV5fvPAmJcXeG2mAfFtEwL62EOCPOHR1ZT9Ag>
    <xmx:cHGzYF2v1rwV-pU75XlydwCDfwpgPDGj6VhSDlk-oufoA5wT5Ge_ng>
    <xmx:cHGzYChMn7LTvmh_FsYgLKk3mOc_RS8DEdnKBDXrSMnV1tHCvq6JmQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 07:05:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: gadget: udc: renesas_usb3: Fix a race in" failed to apply to 4.9-stable tree
To:     yoshihiro.shimoda.uh@renesas.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 13:05:18 +0200
Message-ID: <1622372718131227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From e752dbc59e1241b13b8c4f7b6eb582862e7668fe Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Mon, 24 May 2021 15:01:55 +0900
Subject: [PATCH] usb: gadget: udc: renesas_usb3: Fix a race in
 usb3_start_pipen()

The usb3_start_pipen() is called by renesas_usb3_ep_queue() and
usb3_request_done_pipen() so that usb3_start_pipen() is possible
to cause a race when getting usb3_first_req like below:

renesas_usb3_ep_queue()
 spin_lock_irqsave()
 list_add_tail()
 spin_unlock_irqrestore()
 usb3_start_pipen()
  usb3_first_req = usb3_get_request() --- [1]
 --- interrupt ---
 usb3_irq_dma_int()
 usb3_request_done_pipen()
  usb3_get_request()
  usb3_start_pipen()
  usb3_first_req = usb3_get_request()
  ...
  (the req is possible to be finished in the interrupt)

The usb3_first_req [1] above may have been finished after the interrupt
ended so that this driver caused to start a transfer wrongly. To fix this
issue, getting/checking the usb3_first_req are under spin_lock_irqsave()
in the same section.

Fixes: 746bfe63bba3 ("usb: gadget: renesas_usb3: add support for Renesas USB3.0 peripheral controller")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210524060155.1178724-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/udc/renesas_usb3.c b/drivers/usb/gadget/udc/renesas_usb3.c
index 0c418ce50ba0..f1b35a39d1ba 100644
--- a/drivers/usb/gadget/udc/renesas_usb3.c
+++ b/drivers/usb/gadget/udc/renesas_usb3.c
@@ -1488,7 +1488,7 @@ static void usb3_start_pipen(struct renesas_usb3_ep *usb3_ep,
 			     struct renesas_usb3_request *usb3_req)
 {
 	struct renesas_usb3 *usb3 = usb3_ep_to_usb3(usb3_ep);
-	struct renesas_usb3_request *usb3_req_first = usb3_get_request(usb3_ep);
+	struct renesas_usb3_request *usb3_req_first;
 	unsigned long flags;
 	int ret = -EAGAIN;
 	u32 enable_bits = 0;
@@ -1496,7 +1496,8 @@ static void usb3_start_pipen(struct renesas_usb3_ep *usb3_ep,
 	spin_lock_irqsave(&usb3->lock, flags);
 	if (usb3_ep->halt || usb3_ep->started)
 		goto out;
-	if (usb3_req != usb3_req_first)
+	usb3_req_first = __usb3_get_request(usb3_ep);
+	if (!usb3_req_first || usb3_req != usb3_req_first)
 		goto out;
 
 	if (usb3_pn_change(usb3, usb3_ep->num) < 0)

