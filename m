Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E034FCA97
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245345AbiDLAye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344660AbiDLAxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:53:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF863192E;
        Mon, 11 Apr 2022 17:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 873FDCE185D;
        Tue, 12 Apr 2022 00:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78573C385A4;
        Tue, 12 Apr 2022 00:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724514;
        bh=resUGCgfDFyLK6Iu5p0IhwFZLP0ZHosQKFmc2IXJMqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPSv8lF/BP0kkzSe7gfRvpJVxVjXiVPqabxnxZOBcUtkHF2w1DzDRSmnVTwJ4yGVX
         rgb/g5fnrGJRCr3J6s48h+XlXjjwzsIWbxT2mRTUzfpsk5U7uYcHwd09WJuzsg8S5B
         gStx66XhctTylwvDpe+0eK4DYKsRs6eXsKP8IONzCTna7GGAQvKP1SOOUxjz7CoikU
         JzfXhIqPt3sdx2RvK2qMRNAgmizbx5yVk+DJBOQtqleSJajrI3vA0THQA+9+k8M53B
         ukcg1zq2xlWUtJgZHJTXS2ck49J4tG9TJCfae+BtvYGkwq/pHps059pH97+ndIkVoh
         Hbtbs3hkuXgKA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Leung <Martin.Leung@amd.com>,
        George Shen <George.Shen@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com, Wayne.Lin@amd.com,
        aric.cyr@amd.com, meenakshikumar.somasundaram@amd.com,
        michael.strauss@amd.com, Jimmy.Kizito@amd.com, Eric.Yang2@amd.com,
        lee.jones@linaro.org, wenjing.liu@amd.com, roy.chan@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 30/41] drm/amd/display: Revert FEC check in validation
Date:   Mon, 11 Apr 2022 20:46:42 -0400
Message-Id: <20220412004656.350101-30-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Leung <Martin.Leung@amd.com>

[ Upstream commit b2075fce104b88b789c15ef1ed2b91dc94198e26 ]

why and how:
causes failure on install on certain machines

Reviewed-by: George Shen <George.Shen@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 35a27fe48f66..b37c4d2e7a1e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1377,10 +1377,6 @@ bool dc_validate_seamless_boot_timing(const struct dc *dc,
 	if (!link->link_enc->funcs->is_dig_enabled(link->link_enc))
 		return false;
 
-	/* Check for FEC status*/
-	if (link->link_enc->funcs->fec_is_active(link->link_enc))
-		return false;
-
 	enc_inst = link->link_enc->funcs->get_dig_frontend(link->link_enc);
 
 	if (enc_inst == ENGINE_ID_UNKNOWN)
-- 
2.35.1

