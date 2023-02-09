Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACCB36906E8
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjBILVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230365AbjBILVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:21:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156DF5AB3C;
        Thu,  9 Feb 2023 03:17:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A8F6B8210A;
        Thu,  9 Feb 2023 11:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068DDC4339C;
        Thu,  9 Feb 2023 11:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941438;
        bh=R3HKuJABYKwoQftJOBb4X6UcJr6mq7bO3rodLXAVxCs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Az5LBkCMyX+jLOXAZYoFi0zkgcIkA/VhOscoai1zL7uFClaFrRGO/n+vCp9DIO8rM
         oBIfODh1eKlnr8y0L3kI7zUsl0lElwDbtLYhdhyn5XxGPd8WsZVqbhLoKySMFGJqqW
         GzS4EI5N5b8osSBGv9sMPiayrNT/tSCQepMckswIKl6pe/KdcRfE0xwasWmKgRJfTT
         X7FiNFquVCuUA1r6kMoYurRIQMtiQkH7XjLcurxmiYTeMFdo4KRg5x2sxfW0IyDzTh
         cbE5fY9RO7ECK8WkjpWvi+P8YMLZJdG4aLKdDz6Rw2xZpAmgKKitmu/Uj+93xd1evh
         EETOKomhjWIwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>, Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, sonny.jiang@amd.com, James.Zhu@amd.com,
        tim.huang@amd.com, kenneth.feng@amd.com, Likun.Gao@amd.com,
        Stanley.Yang@amd.com, yiqing.yao@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 33/38] drm/amdgpu: enable HDP SD for gfx 11.0.3
Date:   Thu,  9 Feb 2023 06:14:52 -0500
Message-Id: <20230209111459.1891941-33-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit bb25849c0fa550b26cecc9c476c519a927c66898 ]

Enable HDP clock gating control for gfx 11.0.3.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 9bc9852b9cda9..230e15fed755c 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -643,7 +643,8 @@ static int soc21_common_early_init(void *handle)
 			AMD_CG_SUPPORT_GFX_CGCG |
 			AMD_CG_SUPPORT_GFX_CGLS |
 			AMD_CG_SUPPORT_REPEATER_FGCG |
-			AMD_CG_SUPPORT_GFX_MGCG;
+			AMD_CG_SUPPORT_GFX_MGCG |
+			AMD_CG_SUPPORT_HDP_SD;
 		adev->pg_flags = AMD_PG_SUPPORT_VCN |
 			AMD_PG_SUPPORT_VCN_DPG |
 			AMD_PG_SUPPORT_JPEG;
-- 
2.39.0

