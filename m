Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13751C8FBF
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 16:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgEGOeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 10:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbgEGO3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 May 2020 10:29:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AFB72184D;
        Thu,  7 May 2020 14:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588861746;
        bh=MZoJruzevu0Mqm1XG+YDSEIaVLGDBxikzdKGaPu4uuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kW+J2htEAL1H1HndU6CWy0/3crLNewSkRIL8sT6fZTLUZSsyEKTwaitrxIKsc5d2+
         w9LAiBYEszMI386dzljCEAaLy3XQikj7eZJdN/aNskSLWIWdVo+TttGMAZ8r4Yx24q
         QEadb5h1iwLyj7SFupEr3ZMMezIvG16FGT1JJQqQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sung Lee <sung.lee@amd.com>, Yongqiang Sun <yongqiang.sun@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 28/35] drm/amd/display: Update downspread percent to match spreadsheet for DCN2.1
Date:   Thu,  7 May 2020 10:28:22 -0400
Message-Id: <20200507142830.26239-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

[ Upstream commit 668a6741f809f2d15d125cfe2b39661e8f1655ea ]

[WHY]
The downspread percentage was copied over from a previous version
of the display_mode_lib spreadsheet. This value has been updated,
and the previous value is too high to allow for such modes as
4K120hz. The new value is sufficient for such modes.

[HOW]
Update the value in dcn21_resource to match the spreadsheet.

Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index 161bf7caf3ae0..bb7add5ea2273 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -247,7 +247,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
 	.dram_channel_width_bytes = 4,
 	.fabric_datapath_to_dcn_data_return_bytes = 32,
 	.dcn_downspread_percent = 0.5,
-	.downspread_percent = 0.5,
+	.downspread_percent = 0.38,
 	.dram_page_open_time_ns = 50.0,
 	.dram_rw_turnaround_time_ns = 17.5,
 	.dram_return_buffer_per_channel_bytes = 8192,
-- 
2.20.1

