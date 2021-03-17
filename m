Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD9C33E4A1
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhCQBAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231753AbhCQA6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A473D64FFC;
        Wed, 17 Mar 2021 00:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942717;
        bh=ycdKLRkXafHBSwEDjvdu5pheyZU7MTyYgWw4zPjDw9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FM/UTTCR2CyrsagSmF+w7pkA0yqBsQ1qUjeu2uy46tohXvFtSRf9Y3q9ZOV9dkgsI
         1yT8CkGkPV2C+0aaSGStnWdAjaV2klos9bsEtK4e7VP/y/RcuZF2mwCHH/sb1++HNS
         8JvXZlj8YjhMnHMtvLUmHU/n7EhSiuiVVOBE6AsqGZFq9FTn5H89lpwgD4CpZdZeBA
         a+evo3XFbV46AtyC+YvSuk5ZC1yzghBGrJmgeE/f/TV+gdqcbrjVbir8gPUenjE9Vx
         FqdPZVhjwnX6XPxY8AvZbZTN9+VyVdliogOs787po72X4yj7pC7ZJCZvQWSIjkXCKh
         oD89m49U2+Hzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sung Lee <sung.lee@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Haonan Wang <Haonan.Wang2@amd.com>,
        Eryk Brol <eryk.brol@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 28/37] drm/amd/display: Revert dram_clock_change_latency for DCN2.1
Date:   Tue, 16 Mar 2021 20:57:53 -0400
Message-Id: <20210317005802.725825-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
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
index f63cbbee7b33..11a4c4029a90 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -257,7 +257,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
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

