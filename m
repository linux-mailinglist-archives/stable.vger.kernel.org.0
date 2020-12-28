Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB64B2E3650
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbgL1LSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:18:31 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:54511 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727207AbgL1LSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:18:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id EFA69837;
        Mon, 28 Dec 2020 06:17:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=El+z/T
        GxWx23kKQXFdGbkLSa6GNnzdqthBvS4k5MXn0=; b=iAxUCHeWgu4yHVfgGHWPHq
        SzwN54/kPpZ01sZGF6sghJIN4W9PGEujjeftINSvBcBSqXy5+oxdaZWhjjzWeW7C
        msGg4rlW9QdTPUyh4Vc5XZcBEZl2xlUfiBhPiBrRSRqK48IdQA42aW62nvQrPbAv
        VmXs0G0i8sZ4b9JyYWCGST8R0e/fNFLWpnPucLIQhCWAtq50lpNLCMYSFixcxPY5
        fj/MIfcDPJj7qK5GhEZqtcHV3eI0Eotcn/n1/fBfdpkDKEVD0fhxbGNsT4O9d+q0
        2RBi7AzRNruSR+ZbSH0lftaZaqkbSvXLLGRnRNiLv00DLnR+4883TOKxv1sIKk4A
        ==
X-ME-Sender: <xms:w77pX1QrMW-YKFe6f4ny4VplBStnAVOIcs9poKL2YsZY0tPIUYKlvw>
    <xme:w77pX-wGQ5bhrpWjTUgqJwuwhJQCx6RWX-Oj8MIGVc-lNebO_BqluOS8oo0euyR7g
    9aLLub-Yaj_KQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:w77pX61SsjN6QfsmVqVYakmatPM5SevJ_vSsEH9cnc-5HzjB2y3BYw>
    <xmx:w77pX9ANlLuyZePh7u9uK_dKHw1qzvKdfdfXjxO55EvfPXejvOotIA>
    <xmx:w77pX-iFdjpvV2gYcPekA2qIgmE8FYEd1GJgEyRpLx79-eBAXux1mg>
    <xmx:w77pXyYDEW0hW9boVRei0P9I2ZOBmLDefGBp1fgAwkEWTBqM4ziGk3n2d-o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2D1A5240057;
        Mon, 28 Dec 2020 06:17:23 -0500 (EST)
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

