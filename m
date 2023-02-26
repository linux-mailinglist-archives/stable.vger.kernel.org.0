Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF9E6A2D4F
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 04:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBZDl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 22:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjBZDl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 22:41:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6103F7EFF;
        Sat, 25 Feb 2023 19:41:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 162FAB80B77;
        Sun, 26 Feb 2023 03:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D70C4339B;
        Sun, 26 Feb 2023 03:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677382914;
        bh=52E+GSuFyFo38fz7sYxZyDNgzhjR99EHvAE7QxPalRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClxkgYD1n8TjM1rel0wZthq4wIBNveVYbGey/WjXP53fDiY+SOb914l26ij6A2f2m
         Ug6NlCxg89TMt/g8xskiBT8DUTComTuDku0d25qaw1g+ZZ/yleuDcLMLam/DhHZ4MV
         glB2+awhII+Gy6lWbhHUBtz7/HzI7th8pd6hdJvCDb4zmWscVq1wJJ9si040WNxB+1
         nbmNiGubOwj/qo1FId2V+3CuRfMa8wqtaofVyl7kQnJd/81ovG1Fqt7c+o2Bmdb6Dp
         ZanCGbuJXcLSPLzT8czG+OQMKCWEHTFfbluk/+3ZVRTuyez4g/+dz7+JKfEZS4Zg1Y
         6KvrxdDuMgTsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 02/21] arm64: dts: qcom: msm8996: Add additional A2NoC clocks
Date:   Sat, 25 Feb 2023 22:41:31 -0500
Message-Id: <20230226034150.771411-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226034150.771411-1-sashal@kernel.org>
References: <20230226034150.771411-1-sashal@kernel.org>
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 67fb53745e0b38275fa0b422b6a3c6c1c028c9a2 ]

On eMMC devices, the UFS clocks aren't started in the bootloader (or well,
at least it should not be, as that would just leak power..), which results
in platform reboots when trying to access the unclocked UFS hardware,
which unfortunately happens on each and every boot, as interconnect calls
sync_state and goes over each and every path.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org> #db820c
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221210200353.418391-6-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index d31464204f696..e51a75d15cb29 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -830,9 +830,11 @@ a2noc: interconnect@583000 {
 			compatible = "qcom,msm8996-a2noc";
 			reg = <0x00583000 0x7000>;
 			#interconnect-cells = <1>;
-			clock-names = "bus", "bus_a";
+			clock-names = "bus", "bus_a", "aggre2_ufs_axi", "ufs_axi";
 			clocks = <&rpmcc RPM_SMD_AGGR2_NOC_CLK>,
-				 <&rpmcc RPM_SMD_AGGR2_NOC_A_CLK>;
+				 <&rpmcc RPM_SMD_AGGR2_NOC_A_CLK>,
+				 <&gcc GCC_AGGRE2_UFS_AXI_CLK>,
+				 <&gcc GCC_UFS_AXI_CLK>;
 		};
 
 		mnoc: interconnect@5a4000 {
-- 
2.39.0

