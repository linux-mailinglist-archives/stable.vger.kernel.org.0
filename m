Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18318635DB0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 13:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiKWMnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 07:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiKWMmS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 07:42:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E20266C86;
        Wed, 23 Nov 2022 04:41:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFA91B81F59;
        Wed, 23 Nov 2022 12:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B462DC433B5;
        Wed, 23 Nov 2022 12:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669207300;
        bh=cXUFPo7OqE2nILNuP6wEGNjVgk3DTRgoHCsjSSUkV4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyB6oeikAMbuw6OB15Vtc1BxR6dnm5BwmryO9w24tusUxmxlRTEl1j069GrduGKLV
         Pc8zC6qElt3IBtvo/g12W4PgraYX+oVlHOrM/+ak5XiCOXABPv+Zv/WcoznXu28edb
         T+MwRGqt0HoiokWqi4mUrA3qV/cIocgGHLJ9nDTegTFCEgP65fp72ttdKX6n2fPbNz
         2WeP0zJ1lcQDs8xIAiAFBY3anU5JZVmd7420hnoA428OBUJxU9/XXdOz44AolcyZ7z
         v4FPoTv4E9cZHZOSjsmKNPCJMnCx2RtMVkWZvPVVjVMlwaSTlj6eiZTw6Q4J+l2KCO
         VRRC54n4tvKpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anjana Hari <quic_ahari@quicinc.com>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        Andrew Halaney <ahalaney@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, andersson@kernel.org,
        agross@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 17/44] pinctrl: qcom: sc8280xp: Rectify UFS reset pins
Date:   Wed, 23 Nov 2022 07:40:26 -0500
Message-Id: <20221123124057.264822-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123124057.264822-1-sashal@kernel.org>
References: <20221123124057.264822-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anjana Hari <quic_ahari@quicinc.com>

[ Upstream commit f04a2862f9c3f64962b8709c75d788efba6df26b ]

UFS reset pin offsets are wrongly configured for SC8280XP,
correcting the same for both UFS instances here.

Signed-off-by: Anjana Hari <quic_ahari@quicinc.com>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Tested-by: Andrew Halaney <ahalaney@redhat.com> # QDrive3
Link: https://lore.kernel.org/r/20221103181051.26912-1-quic_bjorande@quicinc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-sc8280xp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
index aa2075390f3e..e96c00686a25 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8280xp.c
@@ -1873,8 +1873,8 @@ static const struct msm_pingroup sc8280xp_groups[] = {
 	[225] = PINGROUP(225, hs3_mi2s, phase_flag, _, _, _, _, egpio),
 	[226] = PINGROUP(226, hs3_mi2s, phase_flag, _, _, _, _, egpio),
 	[227] = PINGROUP(227, hs3_mi2s, phase_flag, _, _, _, _, egpio),
-	[228] = UFS_RESET(ufs_reset, 0xf1004),
-	[229] = UFS_RESET(ufs1_reset, 0xf3004),
+	[228] = UFS_RESET(ufs_reset, 0xf1000),
+	[229] = UFS_RESET(ufs1_reset, 0xf3000),
 	[230] = SDC_QDSD_PINGROUP(sdc2_clk, 0xe8000, 14, 6),
 	[231] = SDC_QDSD_PINGROUP(sdc2_cmd, 0xe8000, 11, 3),
 	[232] = SDC_QDSD_PINGROUP(sdc2_data, 0xe8000, 9, 0),
-- 
2.35.1

