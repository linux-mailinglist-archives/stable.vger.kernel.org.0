Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E88126906AA
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 12:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjBILTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 06:19:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjBILSi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 06:18:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6206A199D7;
        Thu,  9 Feb 2023 03:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD08619C2;
        Thu,  9 Feb 2023 11:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D7CC433A1;
        Thu,  9 Feb 2023 11:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675941410;
        bh=VloG9acZa/PwwsJWfuSKaf8CoTxyQm2FyMJ/VwbdQes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MbbZuzuG89+6OEDWDFFn7gt+vGLSCLT0eQifN2/5VyfZymLrUrvGesxAgviPMLdtE
         ThuALioPyLaGkKgyeiCbjI9zvOvOQOUk4jFLMjAWsjFtI8p6G8EjG8l3Xi6zi0uhO7
         GmwmXwu1ezVBpz1rdiIglqK0e0PocDDAA8Rb6SiOIhaXH/aFyi/XEleDjDuLkqaDMG
         EgB1Yh1FHg3qaCgb4y0GoUpFr7JM1is8rAHK/tDpHNUgNIBXnxA8/boJlKdX/eyIUq
         +OahqmlCkT4kED0xgwlN8fU6hu1Ah/cy19g/1HHsPr28ynrZxamWcF/S2zEZHqTGyP
         ce69ZvqlmAcdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Miess <Daniel.Miess@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, nathan@kernel.org, Charlene.Liu@amd.com,
        nicholas.kazlauskas@amd.com, Pavle.Kotarac@amd.com,
        roman.li@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 29/38] drm/amd/display: Add missing brackets in calculation
Date:   Thu,  9 Feb 2023 06:14:48 -0500
Message-Id: <20230209111459.1891941-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230209111459.1891941-1-sashal@kernel.org>
References: <20230209111459.1891941-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Miess <Daniel.Miess@amd.com>

[ Upstream commit ea062fd28f922cb118bfb33229f405b81aff7781 ]

[Why]
Brackets missing in the calculation for MIN_DST_Y_NEXT_START

[How]
Add missing brackets for this calculation

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Daniel Miess <Daniel.Miess@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c    | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
index 0d12fd079cd61..3afd3c80e6da8 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
@@ -3184,7 +3184,7 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 		} else {
 			v->MIN_DST_Y_NEXT_START[k] = v->VTotal[k] - v->VFrontPorch[k] + v->VTotal[k] - v->VActive[k] - v->VStartup[k];
 		}
-		v->MIN_DST_Y_NEXT_START[k] += dml_floor(4.0 * v->TSetup[k] / (double)v->HTotal[k] / v->PixelClock[k], 1.0) / 4.0;
+		v->MIN_DST_Y_NEXT_START[k] += dml_floor(4.0 * v->TSetup[k] / ((double)v->HTotal[k] / v->PixelClock[k]), 1.0) / 4.0;
 		if (((v->VUpdateOffsetPix[k] + v->VUpdateWidthPix[k] + v->VReadyOffsetPix[k]) / v->HTotal[k])
 				<= (isInterlaceTiming ?
 						dml_floor((v->VTotal[k] - v->VActive[k] - v->VFrontPorch[k] - v->VStartup[k]) / 2.0, 1.0) :
-- 
2.39.0

