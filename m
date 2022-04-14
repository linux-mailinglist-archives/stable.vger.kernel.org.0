Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8751C50121A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245273AbiDNNsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343957AbiDNNjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:39:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F22A972DB;
        Thu, 14 Apr 2022 06:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 477F0B8296A;
        Thu, 14 Apr 2022 13:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF37C385A1;
        Thu, 14 Apr 2022 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943342;
        bh=RUj1M3Fs3NhMm/N2tqGoOuOwazr9EvTPpCMg8Scw0lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCA7espudVulMJkVKRte4VkG/Id43j+kGNwIblNPqXaiMhROwC5pBqe23iHeWXmaq
         NWSU8kCA4eHARLnB0r02ZyHUGRRp1FLJfcD0/sFL4mXZ8gOZa0lZpIWW0ncJgoVDbN
         rxh+sARMYDqGAJ3UJcBA3rS96t311NhggpYIS/Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Kubelun <be.dissent@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 5.4 120/475] ARM: dts: qcom: ipq4019: fix sleep clock
Date:   Thu, 14 Apr 2022 15:08:25 +0200
Message-Id: <20220414110858.510157467@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Pavel Kubelun <be.dissent@gmail.com>

[ Upstream commit 3d7e7980993d2c1ae42d3d314040fc2de6a9c45f ]

It seems like sleep_clk was copied from ipq806x.
Fix ipq40xx sleep_clk to the value QSDK defines.

Link: https://source.codeaurora.org/quic/qsdk/oss/kernel/linux-msm/commit/?id=d92ec59973484acc86dd24b67f10f8911b4b4b7d
Link: https://patchwork.kernel.org/comment/22721613/
Fixes: bec6ba4cdf2a ("qcom: ipq4019: Add basic board/dts support for IPQ4019 SoC")
Suggested-by: Bjorn Andersson <bjorn.andersson@linaro.org> (clock-output-names)
Signed-off-by: Pavel Kubelun <be.dissent@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com> (removed clock rename)
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211220170352.34591-1-chunkeey@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq4019.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index 56f51599852d..338256c59ca5 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -141,7 +141,8 @@
 	clocks {
 		sleep_clk: sleep_clk {
 			compatible = "fixed-clock";
-			clock-frequency = <32768>;
+			clock-frequency = <32000>;
+			clock-output-names = "gcc_sleep_clk_src";
 			#clock-cells = <0>;
 		};
 
-- 
2.34.1



