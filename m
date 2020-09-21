Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6ED8272863
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgIUOm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727837AbgIUOlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:41:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53DB1238D6;
        Mon, 21 Sep 2020 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699270;
        bh=O3h3G/LlPhnxLrt7R/eSmGNSC3iirLlq5K1qtaDXSDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qBdZHKHEfSiB4MnHw30oLoYjQotZIQ74NuEdkYmrl/Kx9jKNDowk3huiB7DBDmgO2
         sBfPw1wdw0hAzzG9LLRGaHfHKQ1G23JzBh/DL7agMf8d5hAuxFyFa+BCSpVPfiv7mv
         xHT3ShEvq9Zp1N0ET+01lKZMwFExY8rkcLfa3m00=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jun Lei <jun.lei@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 12/15] drm/amd/display: update nv1x stutter latencies
Date:   Mon, 21 Sep 2020 10:40:51 -0400
Message-Id: <20200921144054.2135602-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144054.2135602-1-sashal@kernel.org>
References: <20200921144054.2135602-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jun Lei <jun.lei@amd.com>

[ Upstream commit c4790a8894232f39c25c7c546c06efe074e63384 ]

[why]
Recent characterization shows increased stutter latencies on some SKUs,
leading to underflow.

[how]
Update SOC params to account for this worst case latency.

Signed-off-by: Jun Lei <jun.lei@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 05b98eadc2899..46afd048c1ea3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -340,8 +340,8 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_0_nv14_soc = {
 			},
 		},
 	.num_states = 5,
-	.sr_exit_time_us = 8.6,
-	.sr_enter_plus_exit_time_us = 10.9,
+	.sr_exit_time_us = 11.6,
+	.sr_enter_plus_exit_time_us = 13.9,
 	.urgent_latency_us = 4.0,
 	.urgent_latency_pixel_data_only_us = 4.0,
 	.urgent_latency_pixel_mixed_with_vm_data_us = 4.0,
-- 
2.25.1

