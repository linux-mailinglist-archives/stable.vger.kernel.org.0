Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B844917DA
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346261AbiARCnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343919AbiARCh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:37:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F51CC061755;
        Mon, 17 Jan 2022 18:34:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CD70611D6;
        Tue, 18 Jan 2022 02:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F7EC36AEF;
        Tue, 18 Jan 2022 02:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473298;
        bh=UH/NsbM9mt79CzA1kPcHg2YVaT+xnxkxbBGOOFUagss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=humUDxq3tFeps3i9tpg5h7urkOPPS6Faw2i7Ei3O6zksAYaVe4Ze+mXLZKTcNkQQ5
         giPwFQZVIw4co8+HuovDH39KmaadAEgTZCEVfPTv0rpklIO2a8u8taHcLvHBKgPz3Z
         WeAiHIaCTMfT4ifD9+oMLzcH/VW23DBIvVcrszPSki9wcgwBQvdQauDeTgBDPLIv4d
         zZh5TXk93RiSn9KW01O4c6xqow/7TC85FNFbRsVE3lZrN8AAm9bZ5RQmwdMweTF4+7
         NPzdRqG5jiW092roooFdJdFBgLFHGbJ/Ubpnd1J7Wai9wWaHoXXRKgUePt/gpY6SQ8
         VXrE9AClf+bZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Leung <Martin.Leung@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com,
        Dmytro.Laktyushkin@amd.com, charlene.liu@amd.com, zhan.liu@amd.com,
        haonan.wang2@amd.com, mikita.lipski@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 056/188] drm/amd/display: add else to avoid double destroy clk_mgr
Date:   Mon, 17 Jan 2022 21:29:40 -0500
Message-Id: <20220118023152.1948105-56-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Leung <Martin.Leung@amd.com>

[ Upstream commit 11dff0e871037a6ad978e52f826a2eb7f5fb274a ]

[Why & How]
when changing some code we accidentally
changed else if-> if. reverting that.

Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
index bb31541f80723..6420527fe476c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
@@ -306,8 +306,7 @@ void dc_destroy_clk_mgr(struct clk_mgr *clk_mgr_base)
 	case FAMILY_NV:
 		if (ASICREV_IS_SIENNA_CICHLID_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
 			dcn3_clk_mgr_destroy(clk_mgr);
-		}
-		if (ASICREV_IS_DIMGREY_CAVEFISH_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
+		} else if (ASICREV_IS_DIMGREY_CAVEFISH_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
 			dcn3_clk_mgr_destroy(clk_mgr);
 		}
 		if (ASICREV_IS_BEIGE_GOBY_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
-- 
2.34.1

