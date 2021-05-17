Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5813D3826C0
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbhEQIXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:23:16 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41271 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230087AbhEQIXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:23:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B4B7E48F;
        Mon, 17 May 2021 04:21:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 May 2021 04:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HqSopU
        SC/Yz/D4H/sKsJQWNnowVOKI38rPTy4+435/k=; b=P7WMVpLf1jjYWELcj6SpsH
        DB4gDmhshav+mv5NVcAqL0QZgigPaBEzcF0JpF4GHIfWt0MoKc0vyPEhVZDK5IMm
        za36SHi47wpoeKv+/PSi7qnfOPseVeKA5YmrKT0KtL3D2qC9AAiwA533BMmJ4HjD
        8quUgeUIQqIJTv8TV1QW1Sq1R+Ls0eMv/MZc6xLf8I9WbyBOD0q1n2awZYui8OMM
        wtd7io+LoaPpg2H308QBv0lEhH0xzqNZKp54+UIjzXyqKnozGGl8N0AHD0sWiJz7
        BhSmwiht8whHP6DPYndkBx5DMir5bOIyb/6xEo8tutrzkJh4EzxzBlfS1AHnwPXg
        ==
X-ME-Sender: <xms:oyeiYAIordCmm9o0OZ7MwR26_ZyKNkw0Rk7faB1h3moJFnKDOIFakg>
    <xme:oyeiYALxeVFoNy87e-4QLwdt3eO6NhqUmxYasFTGBapHo3fr6HoEcCpvv3vm9RLAO
    tA42ORwv1zZdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:oyeiYAvCqyCqEJ4o--sRpObfamG3oKf5cyhmmsMNpPNnLu_keWAnGg>
    <xmx:oyeiYNbsfupTwgGR6nwzpKYxup-BqvNSWMronCECWf0_WN7N-71QqQ>
    <xmx:oyeiYHbfXgZZOY9BZ8oXZcQsD9XLkP8aDL74dgwQjIy_p3t5qcGYdw>
    <xmx:oyeiYGkl3hGWupVQch4jCXi7VCyPRACi3jI4lB3be60WRkETRMP-Jssyma0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:21:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] xhci: Do not use GFP_KERNEL in (potentially) atomic context" failed to apply to 4.14-stable tree
To:     christophe.jaillet@wanadoo.fr, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:21:43 +0200
Message-ID: <162123970316876@kroah.com>
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

