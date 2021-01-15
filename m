Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE632F7516
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 10:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbhAOJTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 04:19:00 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:42159 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727075AbhAOJS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 04:18:59 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8B657195A9BF;
        Fri, 15 Jan 2021 04:18:13 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 15 Jan 2021 04:18:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UAA+bC
        Y/MsGZe/jz3tQKSatCrIxfbdxt1VIH/S1fjs8=; b=MN5NeZNHWBgn8MWzyijfdL
        J3WTKSd9CujIaIb2zcHER1aYCtBi0/h134QR258rJ17vnrhQ0htOCp2yB4UT2cEV
        BZi6IfhAZ6KEYi7rV28tCch6s4lr0yx3vRS8Svbpq7ERrBa7TpfUnAcNHq3AiuMO
        BWOFc/76FFEGu+0BfA5RpneGm3vUgyj8Z7P0PuNHhM0ALAyw+RUyRYOAC6N2Tewa
        2p7KhTCqUFoAbHQAsZSizyMlOkOAqX9kMXNHz8rWhD+eAUqWlkecIOagDOaXS97J
        j9s0EchYTMPgerWadUEuXsc5jobFVz+g4CqBfGwv6zFqMYv7pfw8K7qcIQk59uow
        ==
X-ME-Sender: <xms:1V0BYEnfDG_FeQ6mIik7AdbwS8jEdu7HBM49i_eOiIhrJ62Q8XtMGg>
    <xme:1V0BYD3EWEbMTh9DTALV7gX_fK5OL287kOAl4K4kCYBOKtjscvMlepbWCEqzucaHA
    DFBGa8YuOsmqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtddugddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepkeejgffftefgveeggeehudfgleehkedthedtiefhie
    elieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:1V0BYCq0tnmGRitX7I8qLC3iOxX8iUp2zZCkShG55BxRkVGbShORPA>
    <xmx:1V0BYAneQ8ARJ93LA7-nQ_pM9P-GwgFB7sckoSN0k1ip2jvwuFbo8w>
    <xmx:1V0BYC1k8ZDtK89nTMOzuavQsRrMlmy2VySJfq49k609eyvgtdhoWw>
    <xmx:1V0BYADqocZ64t0G7guam1mAv6mMgw0GgoFWHZ3au_MgISrDtSC78w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 331A61080057;
        Fri, 15 Jan 2021 04:18:13 -0500 (EST)
Subject: FAILED: patch "[PATCH] net: cdc_ncm: correct overhead in delayed_ndp_size" failed to apply to 4.9-stable tree
To:     jks@iki.fi, bjorn@mork.no, davem@davemloft.net, lkp@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Jan 2021 10:18:03 +0100
Message-ID: <161070228312335@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

