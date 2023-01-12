Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D516673FD
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232418AbjALOCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234286AbjALOBW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:01:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC1A532AC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:01:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76F7C60C1B
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CC4C433D2;
        Thu, 12 Jan 2023 14:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532075;
        bh=BwwHk3weBC4wztuoP8owwyQiLO/Om3KFMylwqheF70o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MtdcqkJt3IKL7SdGxjhB0bIoqF05xuXdLcuGoAvGwUlyGeW2h3d71Zfqhuex1z8T4
         lbwFMZCUXCkX8NTEVl258ZgwzMpWPp91iSoXB0Bx8vvP3/rot4a8jfjVw1V7Q2UrZb
         RgkEoLL7PMpWz2jY9koTp2MapQfaX3Jb3rpKggns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Weiss <luca@z3ntu.xyz>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/783] ARM: dts: qcom: apq8064: fix coresight compatible
Date:   Thu, 12 Jan 2023 14:45:20 +0100
Message-Id: <20230112135524.372051682@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit a42b1ee868361f1cb0492f1bdaefb43e0751e468 ]

There's a typo missing the arm, prefix of arm,coresight-etb10. Fix it to
make devicetree validation happier.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Fixes: 7a5c275fd821 ("ARM: dts: qcom: Add apq8064 CoreSight components")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221013190657.48499-3-luca@z3ntu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 72c4a9fc41a2..fb25ede1ce9f 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1571,7 +1571,7 @@ wifi {
 		};
 
 		etb@1a01000 {
-			compatible = "coresight-etb10", "arm,primecell";
+			compatible = "arm,coresight-etb10", "arm,primecell";
 			reg = <0x1a01000 0x1000>;
 
 			clocks = <&rpmcc RPM_QDSS_CLK>;
-- 
2.35.1



