Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28392E99E7
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbhADQEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbhADQDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:03:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 723282072D;
        Mon,  4 Jan 2021 16:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776177;
        bh=7ig1rKJIVwtSJ8LzofyjMuBDe2lGk1Ll4z/G22TAaMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWePgD/HB/Zvg0tSTYnAIbBhXqDbkcW0bNBFfB95NEjD1dwTQoU1z63OuMxEJgrvo
         SV+0ybxcFPOPBdjCcFr0rTdYsl2V9WkEh3FFSQLZJa8RxslMM6GFIZaVctuKex8Yj5
         wNxhk7LvTKiNKv4qO+rNuyJc0XY8P4L39+ZooKL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jake Wang <haonan.wang2@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/63] drm/amd/display: updated wm table for Renoir
Date:   Mon,  4 Jan 2021 16:57:49 +0100
Message-Id: <20210104155711.521915510@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jake Wang <haonan.wang2@amd.com>

[ Upstream commit 410066d24cfc1071be25e402510367aca9db5cb6 ]

[Why]
For certain timings, Renoir may underflow due to sr exit
latency being too slow.

[How]
Updated wm table for renoir.

Signed-off-by: Jake Wang <haonan.wang2@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index 6b431db146cd9..1c6e401dd4cce 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -704,24 +704,24 @@ static struct wm_table ddr4_wm_table_rn = {
 			.wm_inst = WM_B,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 11.12,
+			.sr_enter_plus_exit_time_us = 12.48,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_C,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 11.12,
+			.sr_enter_plus_exit_time_us = 12.48,
 			.valid = true,
 		},
 		{
 			.wm_inst = WM_D,
 			.wm_type = WM_TYPE_PSTATE_CHG,
 			.pstate_latency_us = 11.72,
-			.sr_exit_time_us = 10.12,
-			.sr_enter_plus_exit_time_us = 11.48,
+			.sr_exit_time_us = 11.12,
+			.sr_enter_plus_exit_time_us = 12.48,
 			.valid = true,
 		},
 	}
-- 
2.27.0



