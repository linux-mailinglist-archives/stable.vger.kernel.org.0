Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23D046AEDBD
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCGSHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjCGSGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:06:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB54A80E9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:59:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38359B819C4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86BA0C4339B;
        Tue,  7 Mar 2023 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211972;
        bh=1jjYl03Ecp9nCYiEsfVilLgWW1IVgu1i3TwsDZsb17A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZNXfPzGuI/drfmJLpJ5mbtDRtPGfRnpIs2L/RNrFxZbMX0YUBPYvWpRs3zDuu8nF
         ha1dnugCmu1boJKX1+PUjicRw9g/6yI1vxoN/h+wAn26gU5JMekIUPiiwaIrQPqp3K
         rmlR7SVMbKNaZigqGrIGeHXD8nwEUoQXd6QIA7q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Petr Vorel <petr.vorel@gmail.com>,
        Dominik Kobinski <dominikkobinski314@gmail.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/885] arm64: dts: msm8992-bullhead: add memory hole region
Date:   Tue,  7 Mar 2023 17:49:29 +0100
Message-Id: <20230307170003.185585716@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominik Kobinski <dominikkobinski314@gmail.com>

[ Upstream commit 22c7e1a0fa45cd7d028d6b4117161fd0e3427fe0 ]

Add region for memory hole present on bullhead in order to
fix a reboot issue on recent kernels

Reported-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Dominik Kobinski <dominikkobinski314@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Petr Vorel <petr.vorel@gmail.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221211100501.82323-1-dominikkobinski314@gmail.com
Stable-dep-of: 26a91359aea4 ("arm64: dts: qcom: msm8992-bullhead: Fix cont_splash_mem size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index 71e373b11de9d..37bcbbc67be51 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -2,6 +2,7 @@
 /* Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
  * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
+ * Copyright (c) 2022, Dominik Kobinski <dominikkobinski314@gmail.com>
  */
 
 /dts-v1/;
@@ -50,6 +51,11 @@ cont_splash_mem: memory@3400000 {
 			reg = <0 0x03400000 0 0x1200000>;
 			no-map;
 		};
+
+		removed_region: reserved@5000000 {
+			reg = <0 0x05000000 0 0x2200000>;
+			no-map;
+		};
 	};
 };
 
-- 
2.39.2



