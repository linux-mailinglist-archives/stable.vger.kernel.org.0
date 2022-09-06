Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6434A5AEAE4
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiIFNoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239020AbiIFNnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:43:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2236119C00;
        Tue,  6 Sep 2022 06:38:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DE886154D;
        Tue,  6 Sep 2022 13:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EFEC433C1;
        Tue,  6 Sep 2022 13:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471381;
        bh=9WE35mFAtp9kJ/Gk4lXG+3ojwmqhtbdUanLcasjrzX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgMqSnzObF01rj8k4uPxcdh0nmoBxiya3446UJSuxGX0m7O1xaQXvG/jUZ0H+T9oB
         8IHhVtwrof9BtM++0IhJNWa+7dl+R9I6DwkPI1vSRPg1/4cDZiu0aJyB2bXG9ntp2w
         k0I+t4KjGZldesmctwjHeVjnasnS+W1GAlS5b/3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        sunliming <sunliming@kylinos.cn>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/107] drm/msm/dsi: fix the inconsistent indenting
Date:   Tue,  6 Sep 2022 15:29:42 +0200
Message-Id: <20220906132821.779053499@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: sunliming <sunliming@kylinos.cn>

[ Upstream commit 2f25a1fb4ec516c5ad67afd754334b491b9f09a5 ]

Fix the inconsistent indenting in function msm_dsi_dphy_timing_calc_v3().

Fix the following smatch warnings:

drivers/gpu/drm/msm/dsi/phy/dsi_phy.c:350 msm_dsi_dphy_timing_calc_v3() warn: inconsistent indenting

Fixes: f1fa7ff44056 ("drm/msm/dsi: implement auto PHY timing calculator for 10nm PHY")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: sunliming <sunliming@kylinos.cn>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/494662/
Link: https://lore.kernel.org/r/20220719015622.646718-1-sunliming@kylinos.cn
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
index a878b8b079c64..6a917fe69a833 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -347,7 +347,7 @@ int msm_dsi_dphy_timing_calc_v3(struct msm_dsi_dphy_timing *timing,
 	} else {
 		timing->shared_timings.clk_pre =
 			linear_inter(tmax, tmin, pcnt2, 0, false);
-			timing->shared_timings.clk_pre_inc_by_2 = 0;
+		timing->shared_timings.clk_pre_inc_by_2 = 0;
 	}
 
 	timing->ta_go = 3;
-- 
2.35.1



