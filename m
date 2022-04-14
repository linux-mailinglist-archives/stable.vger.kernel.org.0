Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71B1500F18
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244295AbiDNNYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244234AbiDNNXo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:23:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266CA99EEB;
        Thu, 14 Apr 2022 06:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CABA7B8296D;
        Thu, 14 Apr 2022 13:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF74C385BF;
        Thu, 14 Apr 2022 13:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942311;
        bh=ejY/FW7jQpHBzQoAP7RBr66XsTAszjxhUvn28Yrr6w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEZLMMC7FZparG8QDv+xvGJ5CGp3R/n6ijQwsmZXMIrwn7aKKjXUjDz60Db2wFrXt
         8+zLuqF6RNkSWsnUOD03Krb62bUZXzmjIKaCsi5GuuxEEkNFJZYdjKfDx8qZCUnvIB
         Lpx1Xk3TzTSuSDuTdMxKc+WKYI1hro4lf3OPjGLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Kubelun <be.dissent@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>
Subject: [PATCH 4.19 090/338] ARM: dts: qcom: ipq4019: fix sleep clock
Date:   Thu, 14 Apr 2022 15:09:53 +0200
Message-Id: <20220414110841.459666159@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 8328ad589e2b..59527bb1225a 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -135,7 +135,8 @@
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



