Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60AA117F4D4
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 11:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgCJKPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 06:15:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56217 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbgCJKPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 06:15:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C60F220BE;
        Tue, 10 Mar 2020 06:15:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 06:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VoS854
        oGkbR+yD4wfO21W5WZfVUemaRcq5NLMR+23ws=; b=BO+2WLkX9lY885X7TBP47S
        pkNGBO6aNl3EYIl0tHuZ5fFSNLadtgdWuDZVDvmsvIgGlD37lzarN2xHWvnctQxA
        JTF2hXJYr2MzLLHXoHX0EVtK1oGunBCqUz8NzRR75eTMejBaHpO/WZvMoyC3neR7
        viaW68tl3gYxyJbqtThJezh0wYZkXkUmYIdQq02pY4busRZcVD6CG2lwazG7o0Zt
        Ytvs0W46qOTbVsbmZJlrLfxZln7A3LPtFMu9QRPrSMKTVe37hYFBL1V1VcBd4/FC
        aa4CJzT9pYnTnNBnLuMCYBK/KjuQQo3x5JXaGpi33m5T8bgRk3zJgv1MlBtQp2DQ
        ==
X-ME-Sender: <xms:0mhnXmPrLelg8b5PyFVPS9qykUt4AV4gWYrgkHvGq9YjhYYEDWaT-g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgpdgsrghsvgdruggvvh
    enucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0mhnXtp4u9WId0M7jaZdHaSkObKEp35u0SL6Xk_zrCuKc0OmJtYKoA>
    <xmx:0mhnXtPl49dfbgf85ziFli2oxqecdiJGZxHV2rXuueBCPlonwgFwTA>
    <xmx:0mhnXjNlalJ74BTauzSvPJJMo0ieuoKr-wVq7zA90A3rG9p_1_ZrFw>
    <xmx:02hnXgBQxhDLA0JCGBCzFOpg1inrqDbYj4G4BhOPIaORa1RT5QUd_g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C7E7130611FB;
        Tue, 10 Mar 2020 06:15:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/ttm: fix leaking fences via ttm_buffer_object_transfer" failed to apply to 5.4-stable tree
To:     Ahzo@tutanota.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 11:15:43 +0100
Message-ID: <15838353439240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c8c06207bcfc5a7e5918fc0a0f7f7b9a2e196d6 Mon Sep 17 00:00:00 2001
From: Ahzo <Ahzo@tutanota.com>
Date: Tue, 25 Feb 2020 13:56:14 -0500
Subject: [PATCH] drm/ttm: fix leaking fences via ttm_buffer_object_transfer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Set the drm_device to NULL, so that the newly created buffer object
doesn't appear to use the embedded gem object.

This is necessary, because otherwise no corresponding dma_resv_fini for
the dma_resv_init is called, resulting in a memory leak.

The dma_resv_fini in ttm_bo_release_list is only called if the embedded
gem object is not used, which is determined by checking if the
drm_device is NULL.

Bug: https://gitlab.freedesktop.org/drm/amd/issues/958
Fixes: 1e053b10ba60 ("drm/ttm: use gem reservation object")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Ahzo <Ahzo@tutanota.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/355089/

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index 49ed55779128..953c82a4f573 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -515,6 +515,7 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 		fbo->base.base.resv = &fbo->base.base._resv;
 
 	dma_resv_init(&fbo->base.base._resv);
+	fbo->base.base.dev = NULL;
 	ret = dma_resv_trylock(&fbo->base.base._resv);
 	WARN_ON(!ret);
 

