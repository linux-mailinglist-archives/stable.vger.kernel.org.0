Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C02F2463F3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 12:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgHQKFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 06:05:44 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:41741 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbgHQKFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 06:05:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E189C1941E36;
        Mon, 17 Aug 2020 06:05:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Aug 2020 06:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+KA20s
        GlOaB26iYPPc7v6DEyM1M8gVYEc8xZskL3OZw=; b=GpJeFKrtpB6JvfBLyb89pt
        JsaorANH1RnRgnOJDc8La5Zu7BDgT1DWBRKRRwZ9J+IeW7byV1PP700D81nGaGw8
        2pHqxmoDNST8Jmb2bFhrKcHitUi1GlvrORaj6aFJ+eydF2p1jEa1UB3mIH8MnRCV
        zfWkmZflwjaXxP2g4gew7AEPlqdzOGEvHjbRI1vD4eqjb7qChVjlY+gSU1kELFVx
        42zB07WlmSpE54VBUF7ZPge6bL2LP2F/NVwJ17+KxGW1UudZDm9osM3CmqBCgRcd
        9CgxJHoUsrU2bWeiCkGxPB3JXbktzPPE/YdlaQA0mVItdCHULn8QjLQf1oc3EqHw
        ==
X-ME-Sender: <xms:dVY6X7viZ4K0ItYvP1hM65TpemnMx8PxJMOd8bLsT52rqeoP9PsxcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:dVY6X8enSVJQRyExD_K5bx9EY6lxjjMXiWenmRxef9cxfM30bQFh0w>
    <xmx:dVY6X-yR7WoW2pkj2tL805qmP1nr1smu5M1YMcTg6V0dI1MFfw5U9Q>
    <xmx:dVY6X6OVtGrvqEKscl49aQaxSpAyff_mHmFOCwkLDWsbMS-9SFOA9g>
    <xmx:dVY6X4JsOqNc5htzwogNdg2-g3V_-tHRaMyM3qvqdFW6kYup4ZbiQA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5A5833060067;
        Mon, 17 Aug 2020 06:05:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: cdns3: gadget: always zeroed TRB buffer when enable" failed to apply to 5.4-stable tree
To:     peter.chen@nxp.com, balbi@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Aug 2020 12:06:02 +0200
Message-ID: <1597658762119188@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 95f5acfc4f58f01a22b66d8c9c0ffb72aa96271c Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Wed, 22 Jul 2020 11:06:19 +0800
Subject: [PATCH] usb: cdns3: gadget: always zeroed TRB buffer when enable
 endpoint

During the endpoint dequeue operation, it changes dequeued TRB as link
TRB, when the endpoint is disabled and re-enabled, the DMA fetches the
TRB before the link TRB, after it handles current TRB, the DMA pointer
will advance to the TRB after link TRB, but enqueue and dequene
variables don't know it due to no hardware interrupt at the time, when
the next TRB is added to link TRB position, the DMA will not handle
this TRB due to its pointer is already at the next TRB. See the trace
log like below:

file-storage-675   [001] d..1    86.585657: usb_ep_queue: ep0: req 00000000df9b3a4f length 0/0 sgs 0/0 stream 0 zsI status 0 --> 0
file-storage-675   [001] d..1    86.585663: cdns3_ep_queue: ep1out: req: 000000002ebce364, req buff 00000000f5bc96b4, length: 0/1024 zsi, status: -115, trb: [start:0, end:0: virt addr (null)], flags:0 SID: 0
file-storage-675   [001] d..1    86.585671: cdns3_prepare_trb: ep1out: trb 000000007f770303, dma buf: 0xbd195800, size: 1024, burst: 128 ctrl: 0x00000425 (C=1, T=0, ISP, IOC, Normal) SID:0 LAST_SID:0
file-storage-675   [001] d..1    86.585676: cdns3_ring:
            Ring contents for ep1out:
            Ring deq index: 0, trb: 000000007f770303 (virt), 0xc4003000 (dma)
            Ring enq index: 1, trb: 0000000049c1ba21 (virt), 0xc400300c (dma)
            free trbs: 38, CCS=1, PCS=1
            @0x00000000c4003000 bd195800 80020400 00000425
            @0x00000000c400300c c4003018 80020400 00001811
            @0x00000000c4003018 bcfcc000 0000001f 00000426
            @0x00000000c4003024 bcfce800 0000001f 00000426

	    ...

 irq/144-5b13000-698   [000] d...    87.619286: usb_gadget_giveback_request: ep1in: req 0000000031b832eb length 13/13 sgs 0/0 stream 0 zsI status 0 --> 0
    file-storage-675   [001] d..1    87.619287: cdns3_ep_queue: ep1out: req: 000000002ebce364, req buff 00000000f5bc96b4, length: 0/1024 zsi, status: -115, trb: [start:0, end:0: virt addr 0x80020400c400300c], flags:0 SID: 0
    file-storage-675   [001] d..1    87.619294: cdns3_prepare_trb: ep1out: trb 0000000049c1ba21, dma buf: 0xbd198000, size: 1024, burst: 128 ctrl: 0x00000425 (C=1, T=0, ISP, IOC, Normal) SID:0 LAST_SID:0
    file-storage-675   [001] d..1    87.619297: cdns3_ring:
                Ring contents for ep1out:
                Ring deq index: 1, trb: 0000000049c1ba21 (virt), 0xc400300c (dma)
                Ring enq index: 2, trb: 0000000059b34b67 (virt), 0xc4003018 (dma)
                free trbs: 38, CCS=1, PCS=1
                @0x00000000c4003000 bd195800 0000001f 00000427
                @0x00000000c400300c bd198000 80020400 00000425
                @0x00000000c4003018 bcfcc000 0000001f 00000426
                @0x00000000c4003024 bcfce800 0000001f 00000426
		...

    file-storage-675   [001] d..1    87.619305: cdns3_doorbell_epx: ep1out, ep_trbaddr c4003018
    file-storage-675   [001] ....    87.619308: usb_ep_queue: ep1out: req 000000002ebce364 length 0/1024 sgs 0/0 stream 0 zsI status -115 --> 0
 irq/144-5b13000-698   [000] d..1    87.619315: cdns3_epx_irq: IRQ for ep1out: 01000c80 TRBERR , ep_traddr: c4003018 ep_last_sid: 00000000 use_streams: 0
 irq/144-5b13000-698   [000] d..1    87.619395: cdns3_usb_irq: IRQ 00000008 = Hot Reset

Fixes: f616c3bda47e ("usb: cdns3: Fix dequeue implementation")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 5b4b16bf4164..65a154d47f8e 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -242,9 +242,10 @@ int cdns3_allocate_trb_pool(struct cdns3_endpoint *priv_ep)
 			return -ENOMEM;
 
 		priv_ep->alloc_ring_size = ring_size;
-		memset(priv_ep->trb_pool, 0, ring_size);
 	}
 
+	memset(priv_ep->trb_pool, 0, ring_size);
+
 	priv_ep->num_trbs = num_trbs;
 
 	if (!priv_ep->num)

