Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DCA4F271B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbiDEIFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiDEH7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88BE57491;
        Tue,  5 Apr 2022 00:54:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29DA661722;
        Tue,  5 Apr 2022 07:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAD6C34111;
        Tue,  5 Apr 2022 07:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145244;
        bh=k5R7zHG+JGBCo1Mf88SDA+mrmcIevYFylf9t74xM0Ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZO8xeHEaicYWYJmIBOwPYzrkx2rMoY7YUcEyskS8tpmfxiupjMp2cYuLNMGO0Rb1
         21SFfRNDUeY21qCUk4MQcYV9sgw++UHuqxPhIPizwALqeZD8/ouCa2CjaGSsPpEATJ
         n9RtlXuYnl8nwZxIaLMFr4k+PTqWb2cWJEo7APMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, devicetree@vger.kernel.org,
        Maulik Shah <quic_mkshah@quicinc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0336/1126] arm64: dts: qcom: sm8350: Correct TCS configuration for apps rsc
Date:   Tue,  5 Apr 2022 09:18:03 +0200
Message-Id: <20220405070417.478351415@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Maulik Shah <quic_mkshah@quicinc.com>

[ Upstream commit a131255e4ad1ef8d4873ecba21561ba272b2547a ]

Correct the TCS config by updating the number of TCSes for each type.

Cc: devicetree@vger.kernel.org
Fixes: b7e8f433a673 ("arm64: dts: qcom: Add basic devicetree support for SM8350 SoC")
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1641749107-31979-4-git-send-email-quic_mkshah@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 4b19744bcfb3..765d018e6306 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1820,7 +1820,7 @@
 			qcom,tcs-offset = <0xd00>;
 			qcom,drv-id = <2>;
 			qcom,tcs-config = <ACTIVE_TCS  2>, <SLEEP_TCS   3>,
-					  <WAKE_TCS    3>, <CONTROL_TCS 1>;
+					  <WAKE_TCS    3>, <CONTROL_TCS 0>;
 
 			rpmhcc: clock-controller {
 				compatible = "qcom,sm8350-rpmh-clk";
-- 
2.34.1



