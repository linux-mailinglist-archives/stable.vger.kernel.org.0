Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2916AEA15
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjCGRaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbjCGRaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41955900BC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:25:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EB20614FF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73928C433EF;
        Tue,  7 Mar 2023 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209929;
        bh=2zb3YJ3mcP+geSV3Elhnpk7gwlVhNAdYGW/0v7avtQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdJ4dg61tV1RxvtIKiuL/8JYeDcxfX/KYBOWoM6Apu0yNsi2WDrdLKX6tq70+YhyV
         DYfM2RObuoiQMra8Sgsks6QUEno3Vs6HvIhOFR0WI93WiJNCdgF7xa7WAEZquzvTxo
         Sm9Qw2s9GMiNlhrjTHC4OcmQBOpNfJBKx2YHJeRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Sasha Levin <sashal@kernel.org>,
        Jessica Zhang <quic_jesszhan@quicinc.com>
Subject: [PATCH 6.2 0377/1001] drm/msm/dpu: sc7180: add missing WB2 clock control
Date:   Tue,  7 Mar 2023 17:52:29 +0100
Message-Id: <20230307170037.719269433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 255f056181ac69278dcd8778f0be32a21b2d2a6a ]

Add missing DPU_CLK_CTRL_WB2 to sc7180_mdp clocks array.

Fixes: 51e4d60e6ba5 ("drm/msm/dpu: add writeback support for sc7180")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Tested-by: Jessica Zhang <quic_jesszhan@quicinc.com> # Trogdor (sc7180)
Patchwork: https://patchwork.freedesktop.org/patch/518504/
Link: https://lore.kernel.org/r/20230116103055.780767-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 2196e205efa5e..83f1dd2c22bd7 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -459,6 +459,8 @@ static const struct dpu_mdp_cfg sc7180_mdp[] = {
 		.reg_off = 0x2B4, .bit_off = 8},
 	.clk_ctrls[DPU_CLK_CTRL_CURSOR1] = {
 		.reg_off = 0x2C4, .bit_off = 8},
+	.clk_ctrls[DPU_CLK_CTRL_WB2] = {
+		.reg_off = 0x3B8, .bit_off = 24},
 	},
 };
 
-- 
2.39.2



