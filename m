Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A724F394CDF
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhE2PWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:22:24 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:34777 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhE2PWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:22:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 94F1D1940E06;
        Sat, 29 May 2021 11:20:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 29 May 2021 11:20:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wvGE/Q
        kR1y8RttH2N0pN2NSCMwzVB/dO3g8bpoF4cV8=; b=tG+puYjFjWVo5L5ml3a6vV
        XRMHZgTOtsshq3QTtPMTLilBQ2nA+VY1bhZp6IBcbytbJ0HzZadAyr/+BGB9eJUs
        vjc5akt1eY3OfaFHz0ClqI8nxd+rT2blR5geoxJ4h4MGKMRUXegwBZ4lwbPyKcQ5
        VqMtioC1qSUkYe6klqabZF0+kZLNJB5Y9+xkI9fLXiZrOFRZrduL626DclZfR5WG
        AX6kW2p5VpjRvVm4roySlvgl4quXv47FGTgZCD8uEcL+7g8EdG2KNqxYu/fB7gy8
        kv/a+r2S0TomjhoS7JCpKALSK4SO5tqawzpsR+s3Dljm1YLpt7E24Gl+C2Y6wYxg
        ==
X-ME-Sender: <xms:z1uyYCQ0QgEAtv6sZuEBzCpGoeWhkOF3tjt3-DVNzX_qi76VUb774A>
    <xme:z1uyYHynLpUk7-kbzkWr_Mbj5hn-vCfVJ7F8Tf9s_ZHajgfftdpayl8oU8z4nw_7i
    _AL4-z9m0M2WQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepvdffgeejjeeitdeiffejieejfffghedviedujeehfe
    egvefhhfevvdefueehkeelnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhg
    necukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:z1uyYP0PB1Xv9NsAUhidkkGMrTQzUL3GMZxnz1Tl6y56kqSAEpN2Sw>
    <xmx:z1uyYOCIfvTIHjDZIpROecgQGWTTyIrZZtH0n-MbyUufbsqpX_0Ycw>
    <xmx:z1uyYLhLnXODDTPEUbkhg9ibTh9mzJdKFkLgAR-EQjLipVLfCyfICQ>
    <xmx:z1uyYLJPtfONX4_igNULhvskWz7JC8UxybBP6jjxHQWFTb1fzierdQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:20:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/ttm: Skip swapout if ttm object is not populated" failed to apply to 5.12-stable tree
To:     xinhui.pan@amd.com, christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:20:44 +0200
Message-ID: <1622301644154152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

