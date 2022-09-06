Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640A55AE99D
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbiIFNcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbiIFNcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:32:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA2A7549A;
        Tue,  6 Sep 2022 06:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9627461545;
        Tue,  6 Sep 2022 13:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2DEC433D6;
        Tue,  6 Sep 2022 13:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471119;
        bh=2vCxJOk8Eo6TfKehkCO3cAA4i16P8mP0Tf1MgBakdQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPyBjI+FdfsCOxZpdQ6kphov5NRtW66btMGboW7II2+5sWfMo+lb6t8y6J1J1EtJL
         0fgt1rocGWQZ8uy5UTH+ZpZJHA5ntKmW/Tpthl7RtABbx2mwTjc3UR8kfE7K4ulrWj
         AGJoCYPZpMvFcG90Vt0iR/8G9CpG22uAAkc1g/Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        sunliming <sunliming@kylinos.cn>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/80] drm/msm/dsi: fix the inconsistent indenting
Date:   Tue,  6 Sep 2022 15:29:58 +0200
Message-Id: <20220906132817.001094509@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
index e07986ab52c22..2e0be85ec3947 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -345,7 +345,7 @@ int msm_dsi_dphy_timing_calc_v3(struct msm_dsi_dphy_timing *timing,
 	} else {
 		timing->shared_timings.clk_pre =
 			linear_inter(tmax, tmin, pcnt2, 0, false);
-			timing->shared_timings.clk_pre_inc_by_2 = 0;
+		timing->shared_timings.clk_pre_inc_by_2 = 0;
 	}
 
 	timing->ta_go = 3;
-- 
2.35.1



