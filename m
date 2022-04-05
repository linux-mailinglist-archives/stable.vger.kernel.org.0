Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7D74F2BA2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343799AbiDEJNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244892AbiDEIwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF2F240B1;
        Tue,  5 Apr 2022 01:45:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B23EAB81B18;
        Tue,  5 Apr 2022 08:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2257EC385A0;
        Tue,  5 Apr 2022 08:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148339;
        bh=YS6YXJtkkJlRPJMsD2DAR/8ig+TUFhHwPdrDujFulyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWldJv/hHQf2oXqtizTxC1OUmJfgka83KKbp48HAhLHmjlYWAIp1JapZnBlH/mrfT
         P0v2SAd0+gb2JcZm3JcIbyUuHD+ZJdzM5OD8u2XcEJ5R57U4beuTWi0Jt3F44Cp+g2
         jfgOkgZi9uabEdQoqk8ZFKg5WiIbe0e0RxsGA2UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Vorel <petr.vorel@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0321/1017] arm64: dts: qcom: msm8994: Provide missing "xo_board" and "sleep_clk" to GCC
Date:   Tue,  5 Apr 2022 09:20:34 +0200
Message-Id: <20220405070403.807280554@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Petr Vorel <petr.vorel@gmail.com>

[ Upstream commit 4dd1ad6192748523878463a285346db408b34a02 ]

This is needed due changes in commit 0519d1d0bf33 ("clk: qcom:
gcc-msm8994: Modernize the driver"), which removed struct
clk_fixed_factor. Preparation for next commit for enabling SD/eMMC.
Inspired by 2c2f64ae36d9.

This is required for both msm8994-huawei-angler (sdhc1 will be enabled
in next commit) and msm8992-lg-bullhead (where actually fixes sdhc1
- tested on bullhead rev 1.01).

Fixes: 0519d1d0bf33 ("clk: qcom: gcc-msm8994: Modernize the driver")

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220113233358.17972-4-petr.vorel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 5a9a5ed0565f..215f56daa26c 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -713,6 +713,9 @@
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
 			reg = <0xfc400000 0x2000>;
+
+			clock-names = "xo", "sleep_clk";
+			clocks = <&xo_board>, <&sleep_clk>;
 		};
 
 		rpm_msg_ram: sram@fc428000 {
-- 
2.34.1



