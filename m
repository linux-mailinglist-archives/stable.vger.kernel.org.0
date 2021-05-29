Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90725394CE0
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhE2PWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:22:32 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:51589 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229698AbhE2PWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:22:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id BD26C1940E09;
        Sat, 29 May 2021 11:20:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:20:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=NxEf0Y
        ALPTZZTUZRv0RJ8tXPTdkaK63RWVxnz+NjkrQ=; b=h3AaGZ/KMpzKjtiVyYkWcN
        JgO2aqehbz9cZ4qixceoE/pRKzts7dEUltDldAto1h3cePq+rgKTUlKEs4Rs4eYx
        9FMQce17ZxhzUaP47+DsKEj3Bl2zHbTkFvNTrYesYrTXSBV2AL33Sc/MIY3oax3H
        LVyYnIua6SbkfFXjSweflyodTJcErmJtWLidVuIF+5qkhjWFTgTDvuC8/XFoV0b+
        G8m3w5xLGrR9ypUGpwgM1H0dkvsoW1LZde/MiDNmdmaspFm/jCovU/vPc9GzREGD
        J+OxZoVfY0jocqF8wEhW2lbYbGeDVR+4ZRyKC3PCiQoE/ea+YCACoqmjzwsew+sg
        ==
X-ME-Sender: <xms:11uyYBPKSH1Ug93Iq2O88lh9UO1BcUoTTukSidXV7TQuR0UQgmzvYQ>
    <xme:11uyYD84Bcn7l72FhBlnv6rfbpREOMb0FvQ3rK39Vry73Gxm0V1r9y0ui7wDjp3JW
    QpNRUyrd_5wUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:11uyYATlNbvGnxt_XO_ul2Z3dLH6oFEjXMYgWgRmqcVO9xzHDg9vMA>
    <xmx:11uyYNuGR_49sAEfjajT-hqpEeE7xGZa23KWIjNoQWAh8mz2DaXRrA>
    <xmx:11uyYJfxxP_NWHrycTvEXYH4jvEEhJlOe3H9G7nTRlRtzoC2ntDGZg>
    <xmx:11uyYJkeEVky79XEBGWqS3c_1wVoM1LY_EheMCAZD1X4BWVDf54X1A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:20:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/ttm: Skip swapout if ttm object is not populated" failed to apply to 5.10-stable tree
To:     xinhui.pan@amd.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:20:45 +0200
Message-ID: <16223016457756@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 35f819d218035ddfbc71e7cf62a4849231701e58 Mon Sep 17 00:00:00 2001
From: xinhui pan <xinhui.pan@amd.com>
Date: Fri, 21 May 2021 16:31:12 +0800
Subject: [PATCH] drm/ttm: Skip swapout if ttm object is not populated
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Swapping a ttm object which has no backend pages makes no sense.

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210521083112.33176-1-xinhui.pan@amd.com
CC: stable@kernel.org
Signed-off-by: Christian König <christian.koenig@amd.com>

diff --git a/drivers/gpu/drm/ttm/ttm_device.c b/drivers/gpu/drm/ttm/ttm_device.c
index 510e3e001dab..a1dcf7d55c90 100644
--- a/drivers/gpu/drm/ttm/ttm_device.c
+++ b/drivers/gpu/drm/ttm/ttm_device.c
@@ -145,7 +145,7 @@ int ttm_device_swapout(struct ttm_device *bdev, struct ttm_operation_ctx *ctx,
 			list_for_each_entry(bo, &man->lru[j], lru) {
 				uint32_t num_pages;
 
-				if (!bo->ttm ||
+				if (!bo->ttm || !ttm_tt_is_populated(bo->ttm) ||
 				    bo->ttm->page_flags & TTM_PAGE_FLAG_SG ||
 				    bo->ttm->page_flags & TTM_PAGE_FLAG_SWAPPED)
 					continue;

