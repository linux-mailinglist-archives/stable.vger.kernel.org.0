Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713952F7515
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbhAOJSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:18:51 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:54151 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725917AbhAOJSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 04:18:50 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4A74C19C3DD3;
        Fri, 15 Jan 2021 04:18:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 04:18:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=usLGtI
        Kg2gmxOpcWEz8PPIfFLwVh5clSlI8uOJ93f4I=; b=HhRaLewm49rpr3OejmcCU3
        hy/43nGD7vxK2+lYKkFBkgIV4naKzr+6XkOq6/9GQjwyX0mCjFf/sGP1fX0Lkapf
        03fkDdBZ+IT317IAcTD43gt6SpGQZ3r4WCjucN7EHFVJW0Y25VSBkarDBr7+6mbr
        oMrT7HJ04gX8jjtR9jh47NbTOKJ+WkiP1hQOlVVkaRJeN25/pfpj9axBartLhKrr
        JnBZV1oTfSjqwXsjQE3RI8E5dLO1rVxj7IZykHXSVMnG+Myc/e4wSbcE4vwMZHeq
        QxJjCrbmc+/U1mxibGVpLKZ8jG8y9+aa8eEC3c2DkCaIXtON3quPKAx8pYKX+Z4g
        ==
X-ME-Sender: <xms:y10BYBIAIQCsS7-9dt00EafIrZalHkWKhq-9Blf4_6Ubz2om0Ag8Jg>
    <xme:y10BYNJPq6gJKvRaeM6QS8d2MJUmVAFZPpSTVbabO70s89KAGmJfNRnj6usEK-C_Y
    rfb0JRjTn74vA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:y10BYJsAoGNzusAnt2bR9FCBs78zN_eZpDf0WwBoDqUIdF4NKiLyKw>
    <xmx:y10BYCbwcmlCGOeCGZI_eiAsCyekxj7cIkrkHa6z7ctctUA6UqZgYQ>
    <xmx:y10BYIYo_rywgnHI1KI96NOh4ITAnliZj_ZPUaQlXB93tWqKfn0Y4A>
    <xmx:zF0BYHmAFwp1xMnZCyJ9rss3TU1U12ws9Cet2qp6Q6-lLrDcbbGj1A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 814BA240062;
        Fri, 15 Jan 2021 04:18:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: cdc_ncm: correct overhead in delayed_ndp_size" failed to apply to 4.4-stable tree
To:     jks@iki.fi, bjorn@mork.no, davem@davemloft.net, lkp@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 10:18:01 +0100
Message-ID: <161070228139179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 7a68d725e4ea384977445e0bcaed3d7de83ab5b3 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jouni=20K=2E=20Sepp=C3=A4nen?= <jks@iki.fi>
Date: Tue, 5 Jan 2021 06:52:49 +0200
Subject: [PATCH] net: cdc_ncm: correct overhead in delayed_ndp_size
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Aligning to tx_ndp_modulus is not sufficient because the next align
call can be cdc_ncm_align_tail, which can add up to ctx->tx_modulus +
ctx->tx_remainder - 1 bytes. This used to lead to occasional crashes
on a Huawei 909s-120 LTE module as follows:

- the condition marked /* if there is a remaining skb [...] */ is true
  so the swaps happen
- skb_out is set from ctx->tx_curr_skb
- skb_out->len is exactly 0x3f52
- ctx->tx_curr_size is 0x4000 and delayed_ndp_size is 0xac
  (note that the sum of skb_out->len and delayed_ndp_size is 0x3ffe)
- the for loop over n is executed once
- the cdc_ncm_align_tail call marked /* align beginning of next frame */
  increases skb_out->len to 0x3f56 (the sum is now 0x4002)
- the condition marked /* check if we had enough room left [...] */ is
  false so we break out of the loop
- the condition marked /* If requested, put NDP at end of frame. */ is
  true so the NDP is written into skb_out
- now skb_out->len is 0x4002, so padding_count is minus two interpreted
  as an unsigned number, which is used as the length argument to memset,
  leading to a crash with various symptoms but usually including

> Call Trace:
>  <IRQ>
>  cdc_ncm_fill_tx_frame+0x83a/0x970 [cdc_ncm]
>  cdc_mbim_tx_fixup+0x1d9/0x240 [cdc_mbim]
>  usbnet_start_xmit+0x5d/0x720 [usbnet]

The cdc_ncm_align_tail call first aligns on a ctx->tx_modulus
boundary (adding at most ctx->tx_modulus-1 bytes), then adds
ctx->tx_remainder bytes. Alternatively, the next alignment call can
occur in cdc_ncm_ndp16 or cdc_ncm_ndp32, in which case at most
ctx->tx_ndp_modulus-1 bytes are added.

A similar problem has occurred before, and the code is nontrivial to
reason about, so add a guard before the crashing call. By that time it
is too late to prevent any memory corruption (we'll have written past
the end of the buffer already) but we can at least try to get a warning
written into an on-disk log by avoiding the hard crash caused by padding
past the buffer with a huge number of zeros.

Signed-off-by: Jouni K. Seppänen <jks@iki.fi>
Fixes: 4a0e3e989d66 ("cdc_ncm: Add support for moving NDP to end of NCM frame")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209407
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 3b816a4731f2..5a78848db93f 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1199,7 +1199,10 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	 * accordingly. Otherwise, we should check here.
 	 */
 	if (ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END)
-		delayed_ndp_size = ALIGN(ctx->max_ndp_size, ctx->tx_ndp_modulus);
+		delayed_ndp_size = ctx->max_ndp_size +
+			max_t(u32,
+			      ctx->tx_ndp_modulus,
+			      ctx->tx_modulus + ctx->tx_remainder) - 1;
 	else
 		delayed_ndp_size = 0;
 
@@ -1410,7 +1413,8 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	if (!(dev->driver_info->flags & FLAG_SEND_ZLP) &&
 	    skb_out->len > ctx->min_tx_pkt) {
 		padding_count = ctx->tx_curr_size - skb_out->len;
-		skb_put_zero(skb_out, padding_count);
+		if (!WARN_ON(padding_count > ctx->tx_curr_size))
+			skb_put_zero(skb_out, padding_count);
 	} else if (skb_out->len < ctx->tx_curr_size &&
 		   (skb_out->len % dev->maxpacket) == 0) {
 		skb_put_u8(skb_out, 0);	/* force short packet */

