Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFDB6AF2F8
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbjCGS6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbjCGS5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:57:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0B7B79C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:45:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC63EB819D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F566C433D2;
        Tue,  7 Mar 2023 18:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214708;
        bh=wKOlSjh1wFyENgVf+uYJKpRF4m7Bf0Mczegi9duKtGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/X6w3ar8whFWCYlxh1CddNQkvgyLQEPaLmRt999KqJG2dKsTlE61uwY39DVAcJOL
         SKWl747hUPkog4dXJr3cbM+TRBhHbNokAPo9oxerpswPOPuKilxWY1saCDKKiSAQ0M
         MwXcrd1wb4L89ez492ENHOCy0UdFOK1XqIt71hMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Martin Botka <martin.botka@somainline.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 008/567] arm64: dts: qcom: sm6125: Reorder HSUSB PHY clocks to match bindings
Date:   Tue,  7 Mar 2023 17:55:44 +0100
Message-Id: <20230307165906.186362259@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
index dc3bddc54eb62..2e4fe2bc1e0a8 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -392,9 +392,9 @@ hsusb_phy1: phy@1613000 {
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



