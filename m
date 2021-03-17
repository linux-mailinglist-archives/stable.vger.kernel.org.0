Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437C833E427
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhCQA6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231420AbhCQA5s (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BD7C64F9B;
        Wed, 17 Mar 2021 00:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942663;
        bh=Vnr7MAJTIlC5HrBZBnBkc8Elfqq+p/iixIUF9T1HFtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFWVjSZ93BRpW/e1CqDdvUbwHO+tQ8EHzO/e5O7LBDDBxLf0ElaNq3ZnUznc2wfaP
         WCgI+bz3kN6zXOfIJAVOj8mnY7bU4/63Ab5u74MhrTZUh8TcchBp2fzFqI69by6F8l
         HtItuoctyLwmaei9BzmyXRfKpIHWaVEGMLF161ywnulJP5DgUNhegye97r+ctmTIHG
         KZ6SKDrdXCSAXlOunvHjafxxRjYXPLysX5CQZ5IMw/aN5bhSYoPAEIkI6g1AZfyBod
         55UKmJpO9py1ZQ46rC9TRcSZoOXPRb2pZFz0y52jp70t2vJCrRdN6Fyz2XN0of7Om1
         Rk33I1so7i9nQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sung Lee <sung.lee@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Haonan Wang <Haonan.Wang2@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 40/54] drm/amd/display: Revert dram_clock_change_latency for DCN2.1
Date:   Tue, 16 Mar 2021 20:56:39 -0400
Message-Id: <20210317005654.724862-40-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

[ Upstream commit b0075d114c33580f5c9fa9cee8e13d06db41471b ]

[WHY & HOW]
Using values provided by DF for latency may cause hangs in
multi display configurations. Revert change to previous value.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Haonan Wang <Haonan.Wang2@amd.com>
Acked-by: Eryk Brol <eryk.brol@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index 4e2dcf259428..b2b1e3664f28 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -295,7 +295,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
 	.num_banks = 8,
 	.num_chans = 4,
 	.vmm_page_size_bytes = 4096,
-	.dram_clock_change_latency_us = 11.72,
+	.dram_clock_change_latency_us = 23.84,
 	.return_bus_width_bytes = 64,
 	.dispclk_dppclk_vco_speed_mhz = 3600,
 	.xfc_bus_transport_time_us = 4,
-- 
2.30.1

