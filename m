Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088DE6AF30D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233352AbjCGS7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbjCGS7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:59:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A6CB78B3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:46:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA17A6153D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05168C433D2;
        Tue,  7 Mar 2023 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214751;
        bh=PapvG0E6EoFxtdm+V5ky51kFUpBrhUzjhMs2oXaG8wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffk8Gu/Om8kpOrfMazkliisyMaMiAbyBByVF7FHp6qmHjsvma671wuDBI34GXpW4u
         tydz4TmTLCJkf/+zlxl9XNTOTkCrDXYqBzv6BLmuEoEGj948RrIUGJJvqR/bOrgoh9
         VIhQduWVdvF5oxWVJduwtPoz/yYG5GTDyOAp38/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/567] arm64: dts: qcom: msm8992-bullhead: Disable dfps_data_mem
Date:   Tue,  7 Mar 2023 17:55:56 +0100
Message-Id: <20230307165906.781689475@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Petr Vorel <petr.vorel@gmail.com>

[ Upstream commit 4dee5aa44b924036511a744ceb3abb1ceeb96bb6 ]

It's disabled on downstream [1] thus not shown on downstream dmesg.

Removing it fixes warnings on v6.1:

[    0.000000] OF: reserved mem: OVERLAP DETECTED!
[    0.000000] dfps_data_mem@3400000 (0x0000000003400000--0x0000000003401000) overlaps with memory@3400000 (0x0000000003400000--0x0000000004600000)

[1] https://android.googlesource.com/kernel/msm.git/+/android-7.0.0_r0.17/arch/arm64/boot/dts/lge/msm8992-bullhead.dtsi#137

Fixes: 976d321f32dc ("arm64: dts: qcom: msm8992: Make the DT an overlay on top of 8994")

Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221226185440.440968-3-pevik@seznam.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index 8e20bb13bd65e..84ba740cb957b 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -14,6 +14,9 @@
 /* cont_splash_mem has different memory mapping */
 /delete-node/ &cont_splash_mem;
 
+/* disabled on downstream, conflicts with cont_splash_mem */
+/delete-node/ &dfps_data_mem;
+
 / {
 	model = "LG Nexus 5X";
 	compatible = "lg,bullhead", "qcom,msm8992";
-- 
2.39.2



