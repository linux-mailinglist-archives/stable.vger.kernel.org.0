Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2558B37B85E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhELIsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:48:30 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:34995 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230265AbhELIs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 04:48:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id EF98D13AC;
        Wed, 12 May 2021 04:47:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 04:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wCCN0b
        8Nx5exXxqnGNyDMJ2Sa3WmFzwqEZOaOevgWqc=; b=kWCgd6RYWLDQoeNSGdmNSd
        n+T/F9+akiCz9zfk5WN0RFqOYrViHiA3WuXWcjqR0HSsjObbry5M21it/S/bgCLD
        nhZyhSW7SZ20vbrCDvakXsaCuKZqAPPiOoq5jGoGRlhG9OlKiKBHSssq3fbQ0pQG
        WrIKfPxAHpWdWzVOMPb5VB6MuAzDI95KLZQaSPP4irOmFkVaoNKeKjzi+XlyHDEa
        Gs87oCIm9pZFve6JmxrKxMFmPP8/76YIX9G2Xc5dh8OmdHsGgtFqDnXVa2vBoUgu
        idWxSwRDTQxAVUR5fGooJkeVv98ZSFkGJf9zPbdB0wqWDd2/r41hFni7/nN3EjXQ
        ==
X-ME-Sender: <xms:F5abYH1hZrDCEEpUOlexyMCgWG5cNmpa8vkQ742KqD3n_xOIiAgnFg>
    <xme:F5abYGHsX6Sat3frOda9o9b9KcRL4ClKetU7L4to2gOdJv84qXWKVAlGQqVaeHNke
    zqQetVkt5vjAQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:F5abYH4jAyo5noo9FFoMeg6LaQ1huIx4IW7LLMQn4slZULbMiHADFg>
    <xmx:F5abYM28RPbup9rjoFYeS-LWfKuE5C4A5z_0MUP0w3ehQyjZ6H3TKA>
    <xmx:F5abYKFVJKyyOIdycQCn6zTCOMzISZD84bj-U5a9ufpt34u4A2iwgA>
    <xmx:F5abYMO0FyjjiqurmhCCAAL7e28jraNNFToU7hv4Fmm1zILFQh_0IgdmGoY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 04:47:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: xhci-mtk: fix broken streams issue on 0.96 xHCI" failed to apply to 5.12-stable tree
To:     chunfeng.yun@mediatek.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 10:46:59 +0200
Message-ID: <1620809219112239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1f743c8749eacd906dd3ce402b7cd540bb69ad3e Mon Sep 17 00:00:00 2001
From: Chunfeng Yun <chunfeng.yun@mediatek.com>
Date: Wed, 31 Mar 2021 17:05:52 +0800
Subject: [PATCH] usb: xhci-mtk: fix broken streams issue on 0.96 xHCI

The MediaTek 0.96 xHCI controller on some platforms does not
support bulk stream even HCCPARAMS says supporting, due to MaxPSASize
is set a default value 1 by mistake, here use XHCI_BROKEN_STREAMS
quirk to fix it.

Fixes: 94a631d91ad3 ("usb: xhci-mtk: check hcc_params after adding primary hcd")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/1617181553-3503-3-git-send-email-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/host/xhci-mtk.c b/drivers/usb/host/xhci-mtk.c
index c1bc40289833..4e3d53cc24f4 100644
--- a/drivers/usb/host/xhci-mtk.c
+++ b/drivers/usb/host/xhci-mtk.c
@@ -411,6 +411,13 @@ static void xhci_mtk_quirks(struct device *dev, struct xhci_hcd *xhci)
 	xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
 	if (mtk->lpm_support)
 		xhci->quirks |= XHCI_LPM_SUPPORT;
+
+	/*
+	 * MTK xHCI 0.96: PSA is 1 by default even if doesn't support stream,
+	 * and it's 3 when support it.
+	 */
+	if (xhci->hci_version < 0x100 && HCC_MAX_PSA(xhci->hcc_params) == 4)
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
 }
 
 /* called during probe() after chip reset completes */
@@ -572,7 +579,8 @@ static int xhci_mtk_probe(struct platform_device *pdev)
 	if (ret)
 		goto put_usb3_hcd;
 
-	if (HCC_MAX_PSA(xhci->hcc_params) >= 4)
+	if (HCC_MAX_PSA(xhci->hcc_params) >= 4 &&
+	    !(xhci->quirks & XHCI_BROKEN_STREAMS))
 		xhci->shared_hcd->can_do_streams = 1;
 
 	ret = usb_add_hcd(xhci->shared_hcd, irq, IRQF_SHARED);

