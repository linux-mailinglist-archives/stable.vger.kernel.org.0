Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A6B6AE815
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbjCGRM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjCGRMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:12:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFC097FE9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A9DC61505
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BD0C4339B;
        Tue,  7 Mar 2023 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208851;
        bh=Snd4oiNJAIPT019vHThaEjKB/8+Ek27YTQ8lij6InvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0JcTwR30kPz0ZHyWcovyb+PY8/96HegJ049zW3bmsJn3iFFFfUG+IGGpmEiiA0aq
         0VzJ6ufA+qY1t8qaPAJYcYQC1irFaJmn6Nwg/saZQeMi0pWvuJq5ik/JpYB8eekqI5
         mmIpMr4iTsYW3sKk7pysfrqUPuFAt/kpvs6gIS5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Martin Botka <martin.botka@somainline.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0023/1001] arm64: dts: qcom: sm6125: Reorder HSUSB PHY clocks to match bindings
Date:   Tue,  7 Mar 2023 17:46:35 +0100
Message-Id: <20230307170023.171474741@linuxfoundation.org>
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

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 8416262b0ea46d84767141b074748f4d4f37736a ]

Reorder the clocks and corresponding names to match the QUSB2 phy
schema, fixing the following CHECK_DTBS errors:

    arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dtb: phy@1613000: clock-names:0: 'cfg_ahb' was expected
            From schema: /newdata/aosp-r/kernel/mainline/kernel/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml
    arch/arm64/boot/dts/qcom/sm6125-sony-xperia-seine-pdx201.dtb: phy@1613000: clock-names:1: 'ref' was expected
            From schema: /newdata/aosp-r/kernel/mainline/kernel/Documentation/devicetree/bindings/phy/qcom,qusb2-phy.yaml

Fixes: cff4bbaf2a2d ("arm64: dts: qcom: Add support for SM6125")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Martin Botka <martin.botka@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221216213343.1140143-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6125.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index 7e25a4f85594f..bf9e8d45ee44f 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -442,9 +442,9 @@ hsusb_phy1: phy@1613000 {
 			reg = <0x01613000 0x180>;
 			#phy-cells = <0>;
 
-			clocks = <&rpmcc RPM_SMD_XO_CLK_SRC>,
-				 <&gcc GCC_AHB2PHY_USB_CLK>;
-			clock-names = "ref", "cfg_ahb";
+			clocks = <&gcc GCC_AHB2PHY_USB_CLK>,
+				 <&rpmcc RPM_SMD_XO_CLK_SRC>;
+			clock-names = "cfg_ahb", "ref";
 
 			resets = <&gcc GCC_QUSB2PHY_PRIM_BCR>;
 			status = "disabled";
-- 
2.39.2



