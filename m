Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBB62E364F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbgL1LSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:18:02 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54667 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727171AbgL1LSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:18:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B60527AE;
        Mon, 28 Dec 2020 06:17:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:17:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=j5rB0H
        /GIFOJ/ktpIhrL+40KS4fVIn5n8De0z55US3g=; b=Akp+ng5s8h3gD/VUuwdE5/
        G5y7yivkGdr8GYj9BryFRkmGhxRaEu6G9CXMgaqkfWz7mIyQHw9F51R1q+ly1fIb
        gZivWUPl9+5K2Wi7HCjSBD6dTtY7zSPGAoSjtF07rqGF3T3xakEFYh4Z5h+oQNYJ
        uKPpkNhiK1D6dVdonWqf6KNnXFwgnxVOhCUaufJ7JJI1hRKBS/mpBGwkKNR0PukJ
        zauqj4pWWd8G7MiRht0Cs6BHnZxGB2/hsq5ouEavkCgAK1VEs2HmUH6/+T/+iwmb
        iTcDyblShKQJLJ6lpmx+O5Brke2lWdAcwAjn6o9rv0zWZas9vGFaciIES58UFbyQ
        ==
X-ME-Sender: <xms:u77pX8SA4At6OrBKIe-sbu1oMdnrygHJ_5pXbE3nXYP8ffYg7lrGig>
    <xme:u77pX5wH7bZlMSW4uO0U8CvU5r-5e2nXpj8cldJj1mS-BkHlbqxjjVQkBLTQiYdNE
    p_9xH8dxKffvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:u77pX5298hrlF26UP2__l2dBSiCUapFlGqoagITPHx2pEIzY8dO53w>
    <xmx:u77pXwA2Vccjj2RTzCraJelyzCsggKCz6Frg47UYhwVcvmMNoG5Hjg>
    <xmx:u77pX1jCD3J5XWeAEdhVMa5ye1z4sLIhXEPEeepVq_jYotkPokImPA>
    <xmx:u77pX1YB3YdlfifDV2HDkvqxG4rp98MR73Hgg5WiW8REy459XNWUqybFPIc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D9793108005C;
        Mon, 28 Dec 2020 06:17:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] dma-buf/dma-resv: Respect num_fences when initializing the" failed to apply to 4.4-stable tree
To:     maarten.lankhorst@linux.intel.com,
        niranjana.vishwanathapura@intel.com, stable@vger.kernel.org,
        thomas.hellstrom@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:18:38 +0100
Message-ID: <160915431819129@kroah.com>
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

