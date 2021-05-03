Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044B3371B6D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231917AbhECQpw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233002AbhECQoX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:44:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E185613B4;
        Mon,  3 May 2021 16:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059917;
        bh=RI5xZp6fXcTeorMo8FtnealqGLEsm1U4JacNau8h+kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AS2RJFaCoU39ee6tVZ9zGicSdCBMmntBmrBqi90lW4rE08BXZcFpgvT25TtarMs01
         fvUPRxGQYPg6Spy8ErEq+/UWnwVagbjQhWtgDbxm/HSa8ZK8ajb528ze39CG02Y7Cg
         40gn240G5/vwmGGbtYpERJJlP40d/NSmEUwlp8cLnl4HMBrBxKdMQiDmcr8BAU33/I
         Fom1GvCfp2za5V5n0a6ef6UIXakTq4TNitdWCe9R5U9O4WnZECw1OpeU5szbLOi2+b
         cBxBwCe3rFu0lq5TE30A97xzn4TUsNrgPGjEMEaT+BXZlV+qm83INhGpGyMNP4VLo1
         C5VZI0IRZzIdw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Leung <martin.leung@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 005/100] drm/amd/display: changing sr exit latency
Date:   Mon,  3 May 2021 12:36:54 -0400
Message-Id: <20210503163829.2852775-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
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
index 2455d210ccf6..8465cae180da 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_resource.c
@@ -180,7 +180,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn3_0_soc = {
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

