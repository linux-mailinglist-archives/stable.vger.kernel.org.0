Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7C52E3687
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbgL1LeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:34:24 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:50167 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727287AbgL1LeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:34:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 31871804;
        Mon, 28 Dec 2020 06:33:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=r6lWOV
        DC/+0HH3BVRwynx6+Tg2zGxYecNNfnvR9ogWE=; b=dI0O+KFB+hA3i3ybDJHN1/
        haTx6fJmlOexUr75J1quwuVE43yZjyxNx0bjPuVWBQEckbD9GRGBCYMvcDM1bTy2
        KDNFFBe7SQAgqryj2p1ir7sj1/tFxVIdwJNIFfcHrE7o1e2E0LyG8XrN6x6+zWMc
        fCpU8vcb2yfZOYm1XNsTTa+2ccxP3tsusKaK4wCwdpbii1Smhf0WL45AxbRTCDGn
        3Qh7S/b9aAOUastJpTt+nZsx+NwyWtWrbQZW8rxSGv+RIEZInhWHFRuCVnxRLqGN
        O4p0xJQYnOGQV5sBGqPHQ9NR2zKY2zIjpY/VmU95TtrjUm2QbNc9q1jj6LHA3BtQ
        ==
X-ME-Sender: <xms:fcLpX2gKyKUWGXXOodXVvsOpPvDhI34XDEZhVLqvH_bysWttHt9Pig>
    <xme:fcLpX8TnZCb2SA5nCAYWhHtEC3Zbo6ne_ZaSjP3h9gBLshZR75fWTd7Gn-odP7U5J
    nRDDrxAU2phkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fcLpX_xldHoXDaIGH2t7Tp2k0wRV6Nft-gEIkAhzYtiUf6YlvSAIzw>
    <xmx:fcLpX3fKyHdJmFXCufpoPZClPinic-jc3otRgBAgDnqpIowNKcX3dQ>
    <xmx:fcLpX7Jn82VwD-9XeuXbWNZyAdR0a4yqPCX7PO--kySvekwkQP3n8g>
    <xmx:fcLpX-UfGhv7V8djMEVae7V4HwaCTBWJGhorTqcEduciB_yXV_sTosJebzc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 89ACE1080059;
        Mon, 28 Dec 2020 06:33:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] dma-buf/dma-resv: Respect num_fences when initializing the" failed to apply to 4.14-stable tree
To:     maarten.lankhorst@linux.intel.com,
        niranjana.vishwanathapura@intel.com, stable@vger.kernel.org,
        thomas.hellstrom@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:18:39 +0100
Message-ID: <16091543197829@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

