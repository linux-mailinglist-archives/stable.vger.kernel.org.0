Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00DA371AE7
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhECQlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232151AbhECQjM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B11A6141D;
        Mon,  3 May 2021 16:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059828;
        bh=1lF+p0wWKEydSjKxt8caoh1BWCJvhUgVNOheCC5uX6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5Irqu/WxLrjPeB/bWLjd3XfGO5Ac4ksgbbtMtaaxfcWgBP6MLxrCA6nhupbwiv3B
         TQCoqs7KOdrmzWXn83RkArRh2kEm5pdyPQUpspe7pcZv0H24PupyRP/2VFoedZKjEX
         zIvzHdHAtrZ8mbWeAfDmhHxRCc7TBUH5ttzJZHArbZ7FzrfkJxEBVuRTsXO9HOY4Vk
         SF4E6IDw5E7FEIJk+pXsOhwJe8ue2AxCHkXsGAB5XutR4bpNLHLGnWuuXwRDaXP7vr
         Bd1KoElMIR8vgd4WckUFpvCL2W2A9E7qFW0/q4bCXm4vTKX1lKJnpTVbrTCKa31jyC
         yn6O6t8SDgQ3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Leung <martin.leung@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Qingqing Zhuo <Qingqing.Zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 005/115] drm/amd/display: changing sr exit latency
Date:   Mon,  3 May 2021 12:35:09 -0400
Message-Id: <20210503163700.2852194-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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
index 7ec8936346b2..f90881f4458f 100644
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

