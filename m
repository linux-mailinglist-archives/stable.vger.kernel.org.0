Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48B3C37196C
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhECQgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:36578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhECQgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1AC060D07;
        Mon,  3 May 2021 16:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059721;
        bh=l++XYtZtJ70mk4ZhI+OUoCT6J6N26BdalDtg7D1/Kkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X1FTRV8uyEJ2kD+cyWQAGLOQlAySUEqYWyw7fowL9MeTFx5feWZ9QQQz+r6gN9UhC
         dmPyvsfgbmA6R4jA7CzuRCNyS7Qo2x8t47z7Wz4nv2QmwiSq4s+1zLh6d6L/zNNzJo
         2O63GTRwQqnfnLoYxaiUC0bDG7+NuLQjSiSBtWEDzSemZTfq3Nf6fqjcI42cGre7h2
         wyyKiGki6yKUq64FQYjj6E6A8T4KEwMSEqW0AmkmbkIcwagodRySfSEln0HjNiZEBx
         wwDTLbc7dyJNyt/XVcQjN3j4nhWauw5BtQV8K6Mqr7USwIBYp1wX+hf5h60QQpIVdv
         +jwvdKCLn85dw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Leung <martin.leung@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 005/134] drm/amd/display: changing sr exit latency
Date:   Mon,  3 May 2021 12:33:04 -0400
Message-Id: <20210503163513.2851510-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Leung <martin.leung@amd.com>

[ Upstream commit efe213e5a57e0cd92fa4f328dc1963d330549982 ]

[Why]
Hardware team remeasured, need to update timings
to increase latency slightly and avoid intermittent
underflows.

[How]
sr exit latency update.

Signed-off-by: Martin Leung <martin.leung@amd.com>
Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Qingqing Zhuo <Qingqing.Zhuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
index fb7f1dea3c46..71e2d5e02571 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -181,7 +181,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_0_soc = {
 		},
 	.min_dcfclk = 500.0, /* TODO: set this to actual min DCFCLK */
 	.num_states = 1,
-	.sr_exit_time_us = 12,
+	.sr_exit_time_us = 15.5,
 	.sr_enter_plus_exit_time_us = 20,
 	.urgent_latency_us = 4.0,
 	.urgent_latency_pixel_data_only_us = 4.0,
-- 
2.30.2

