Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57D204F3E08
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380613AbiDEMNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357955AbiDEK1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0854A986E4;
        Tue,  5 Apr 2022 03:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B48A1B81C98;
        Tue,  5 Apr 2022 10:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3E8C385A1;
        Tue,  5 Apr 2022 10:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153498;
        bh=yB1Mj8izsK999do407RRNb3PZDMXLhS63ewWmKva5Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGcArRBMu2zditTQ/+D/qcaH5iGdJH8iNS/lrLPYHtAlnvsSFOmXsohMmlhqqtHEX
         os1xiBZHsmxkzPQieBgaoxhiIbRihXUE8usiVubXX241APhuaE70X7q+sykmVt1Hye
         wgaPccpSAO0VDy6m7tt+PzIMZlWKOqqb5yVR54n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Kubelun <be.dissent@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 5.10 204/599] ARM: dts: qcom: ipq4019: fix sleep clock
Date:   Tue,  5 Apr 2022 09:28:18 +0200
Message-Id: <20220405070304.912044350@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index 74d8e2c8e4b3..3defd47fd8fa 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -142,7 +142,8 @@
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



