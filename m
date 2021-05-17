Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0092B3826BF
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbhEQIXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:23:10 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45853 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231334AbhEQIXJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:23:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 38E4B48F;
        Mon, 17 May 2021 04:21:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 May 2021 04:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7JGMMz
        64QqqBArC7cuxdpLDyreDzdf925f42RaHx5oY=; b=dn16WVlR9sUkYkhlYkFZaR
        l8Aebn2jSYQGpzZl3BVrOefc4Ahvlo+4GaNdn9Vvhx0LBzW/SFridqoHYl6BjZNP
        uL9HbsTuSms1pJDVsF6bUeP7q0jPRrmco6Oezb4ucWmXrMD+Uw43Fx1s5rJkaCSY
        raT0Gqz9AbICKFgjQWoLFOXz0KOSEusd0/2+tRKDZR3vv539v51vcWQxC8WhAFjD
        CnuxcKefGfCokpCKdcoaxWXOt5Rxv3hJKKvHjIkWRcEj6ZvtRI97mnRj3OIt+aNA
        +VhuVxRI74q07XXbvroXJJ+C6hhgAMABo3BlfRAjrLJg2PCNUVJsg5Im8bDU6oeg
        ==
X-ME-Sender: <xms:oCeiYAn3HwIRIPXPZfCXWqMS-_eTMPeEd2Mmcb2rlVnK9sjjcpahTw>
    <xme:oCeiYP1g0HG7wCq2LcQoFB4xr3wk6im4L3e_Rrl72nRmeQ74bTqvvftHALLnkXviY
    QfyOurfFnuhKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:oCeiYOrxeHM5GeUJamNfnBvrtrvUneHJcqdvT-uZ1bCThF722NCCrg>
    <xmx:oCeiYMmocgjD5J8CAi-ze17RBfzA7HN-y8D44XNb7qtdMZwlTpKTIA>
    <xmx:oCeiYO03BsCp_YDcUhDm5TkXFNI-RwIeFk-0httyrGyGAg87XO_Iuw>
    <xmx:oCeiYMB1laKYcReN_eS3cSvXkOdo-g07aW_4SQKiF7h5SgaCXFDx6qSBE7s>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:21:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xhci: Do not use GFP_KERNEL in (potentially) atomic context" failed to apply to 4.9-stable tree
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:21:42 +0200
Message-ID: <162123970220721@kroah.com>
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

From dda32c00c9a0fa103b5d54ef72c477b7aa993679 Mon Sep 17 00:00:00 2001
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 12 May 2021 11:08:14 +0300
Subject: [PATCH] xhci: Do not use GFP_KERNEL in (potentially) atomic context

'xhci_urb_enqueue()' is passed a 'mem_flags' argument, because "URBs may be
submitted in interrupt context" (see comment related to 'usb_submit_urb()'
in 'drivers/usb/core/urb.c')

So this flag should be used in all the calling chain.
Up to now, 'xhci_check_maxpacket()' which is only called from
'xhci_urb_enqueue()', uses GFP_KERNEL.

Be safe and pass the mem_flags to this function as well.

Fixes: ddba5cd0aeff ("xhci: Use command structures when queuing commands on the command ring")
Cc: <stable@vger.kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20210512080816.866037-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index ca9385d22f68..27283654ca08 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -1514,7 +1514,7 @@ static int xhci_configure_endpoint(struct xhci_hcd *xhci,
  * we need to issue an evaluate context command and wait on it.
  */
 static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
-		unsigned int ep_index, struct urb *urb)
+		unsigned int ep_index, struct urb *urb, gfp_t mem_flags)
 {
 	struct xhci_container_ctx *out_ctx;
 	struct xhci_input_control_ctx *ctrl_ctx;
@@ -1545,7 +1545,7 @@ static int xhci_check_maxpacket(struct xhci_hcd *xhci, unsigned int slot_id,
 		 * changes max packet sizes.
 		 */
 
-		command = xhci_alloc_command(xhci, true, GFP_KERNEL);
+		command = xhci_alloc_command(xhci, true, mem_flags);
 		if (!command)
 			return -ENOMEM;
 
@@ -1639,7 +1639,7 @@ static int xhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 		 */
 		if (urb->dev->speed == USB_SPEED_FULL) {
 			ret = xhci_check_maxpacket(xhci, slot_id,
-					ep_index, urb);
+					ep_index, urb, mem_flags);
 			if (ret < 0) {
 				xhci_urb_free_priv(urb_priv);
 				urb->hcpriv = NULL;

