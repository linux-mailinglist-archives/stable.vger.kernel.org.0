Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517594FC9F1
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbiDLAtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243149AbiDLAtR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:49:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51B931230;
        Mon, 11 Apr 2022 17:46:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD326617D9;
        Tue, 12 Apr 2022 00:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE98C385A3;
        Tue, 12 Apr 2022 00:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724378;
        bh=YFxb/cVspJp1tW8d8bAmkViEX0/sfTm8F8Bhz0BXQj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RhsKdL6ii1359Muknom3KCF2ZbxNk+gwltvoXYWTa7hPyGJmqsWW04OjZ3n8ad0mf
         T+I8MEwEjXy126opiN3PEOdUfEpWkRmTVQp12c1WU6MCHmS0qUBwpfbKnemguiETCw
         flJ1HDCDUS8/qF49RaGLR8LG4YtHAQ6IKXUnW6EDpz6dLWmYVZlUUkOaCLsPBDFhFV
         CyKdcs+z+Lu2zhv1uUFPjQFWydP67Xb9qIhBqx0EPIfIXPWxP0kmG1m9Bnj+YNIGv0
         ckzbzcg9yoDUpuIqkC98s5BNBPYxPZi1RUys+FPPhQFynalF3tFeaXmfXeg+LcdXl9
         C8X95oYR4RiAg==
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
        Jun.Lei@amd.com, meenakshikumar.somasundaram@amd.com,
        michael.strauss@amd.com, Jimmy.Kizito@amd.com, Eric.Yang2@amd.com,
        lee.jones@linaro.org, wenjing.liu@amd.com, roy.chan@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 37/49] drm/amd/display: Revert FEC check in validation
Date:   Mon, 11 Apr 2022 20:43:55 -0400
Message-Id: <20220412004411.349427-37-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
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
index a62711d71d0e..ba1aa994db4b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1493,10 +1493,6 @@ bool dc_validate_seamless_boot_timing(const struct dc *dc,
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

