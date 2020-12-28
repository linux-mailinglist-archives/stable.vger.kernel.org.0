Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74452E3685
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgL1LeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:34:23 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60877 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727220AbgL1LeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:34:23 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 08B7230D;
        Mon, 28 Dec 2020 06:33:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=El+z/T
        GxWx23kKQXFdGbkLSa6GNnzdqthBvS4k5MXn0=; b=D3KyFQK3XHl2DMIBL2EGfP
        hvt6P9dlFkC0uTUPlSC4g6XZvEbIh5Xrcsqa/GkL5cxnj0hxju2nLA8rGaeOK+ZF
        ZALdaUPU7S66CK692VM6Cx2J+z1jXegwwUKFt9CnsoYkVdj2EhDx+7Ylg5ibARAp
        Ie3sfLi8RehBuEwdA8memUtc7rn2x3tty71BnbAmBCyqf8TvUHaIzxLb0V5SfDcn
        UtgCOONLfJcXEYQrXKbX1FwJC/rHYzXypNFTMa1WOcA2ka/C7kEFoHZ0W4CbDCVF
        2quqLnuwEQHGfwvf5n1419lunYKlim3Kv6rp/HMoKw/8LiF2/Dv7xigHxjpcaxHg
        ==
X-ME-Sender: <xms:fMLpXzGUBKrwDIBleY_QBOZPU2_s99SbKscvIMz_uE7O0I5hXTOVhQ>
    <xme:fMLpXwU7OeR6w6156jFBjwC_vBHKQCI7QYrLkWgEJMf-rcE5fjsjtsKx_x0s36Msz
    XAV8Cp9gqhvUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fMLpX1L3YE22yJTX92fWu_3SiBPx2Kkwp127Tg2FRrqoKhju5FVn0A>
    <xmx:fMLpXxFm-HANWsmXxy1OffSkKaRmciCnK5bgxdho0ZTQHgRAA_89-w>
    <xmx:fMLpX5V_ZlcL4aVOn3Ul5vZLIq3X8V40F4qbnK9cUmHSgGbrJeP05g>
    <xmx:fMLpX4fCNUI64iTmuloI4S_Z1tf4j0Iarygbkj-4NJR68vZZYUsBjVUuFGo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3990C1080063;
        Mon, 28 Dec 2020 06:33:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] dma-buf/dma-resv: Respect num_fences when initializing the" failed to apply to 4.9-stable tree
To:     maarten.lankhorst@linux.intel.com,
        niranjana.vishwanathapura@intel.com, stable@vger.kernel.org,
        thomas.hellstrom@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:18:38 +0100
Message-ID: <1609154318123125@kroah.com>
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

From bf8975837dac156c33a4d15d46602700998cb6dd Mon Sep 17 00:00:00 2001
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Date: Tue, 24 Nov 2020 12:57:07 +0100
Subject: [PATCH] dma-buf/dma-resv: Respect num_fences when initializing the
 shared fence list.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We hardcode the maximum number of shared fences to 4, instead of
respecting num_fences. Use a minimum of 4, but more if num_fences
is higher.

This seems to have been an oversight when first implementing the
api.

Fixes: 04a5faa8cbe5 ("reservation: update api and add some helpers")
Cc: <stable@vger.kernel.org> # v3.17+
Reported-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201124115707.406917-1-maarten.lankhorst@linux.intel.com

diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index bb5a42b10c29..6ddbeb5dfbf6 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -200,7 +200,7 @@ int dma_resv_reserve_shared(struct dma_resv *obj, unsigned int num_fences)
 			max = max(old->shared_count + num_fences,
 				  old->shared_max * 2);
 	} else {
-		max = 4;
+		max = max(4ul, roundup_pow_of_two(num_fences));
 	}
 
 	new = dma_resv_list_alloc(max);

