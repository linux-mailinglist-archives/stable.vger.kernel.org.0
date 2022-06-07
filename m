Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AA8540A95
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351380AbiFGSXQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352477AbiFGSRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2832314D0A;
        Tue,  7 Jun 2022 10:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3786DB82373;
        Tue,  7 Jun 2022 17:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2ADC341E8;
        Tue,  7 Jun 2022 17:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624329;
        bh=5rY6srO4+hqOtNH3/jjdrbd5QNtkrJk2qMwIoIB2REE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MD7qKBlOAXvU9z76jubQVV2YAL5mHlMdUdyotqe5fzKJZXVEFTAIKbeZIIsycDjAH
         T7J5M8XBYpyS67wNJ4YTuBfaSmVE1F8mREtiry9J6ZMkQGZNABRUTVcLH/vW4/4JKn
         w+NAGro5bn0vhupQzuvQttI2ik7EjygGjeR2eIes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/667] drm/msm/dsi: fix address for second DSI PHY on SDM660
Date:   Tue,  7 Jun 2022 18:59:13 +0200
Message-Id: <20220607164943.416925418@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 9208c707650354dff5b164b586837454f7285124 ]

Correct a typo in the address of the second DSI PHY in the SDM660 device
config.

Fixes: 694dd304cc29 ("drm/msm/dsi: Add phy configuration for SDM630/636/660")
Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/484697/
Link: https://lore.kernel.org/r/20220503204340.935532-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
index 1c1e9861b93f..6d3abcdc57bf 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -1064,6 +1064,6 @@ const struct msm_dsi_phy_cfg dsi_phy_14nm_660_cfgs = {
 	},
 	.min_pll_rate = VCO_MIN_RATE,
 	.max_pll_rate = VCO_MAX_RATE,
-	.io_start = { 0xc994400, 0xc996000 },
+	.io_start = { 0xc994400, 0xc996400 },
 	.num_dsi_phy = 2,
 };
-- 
2.35.1



