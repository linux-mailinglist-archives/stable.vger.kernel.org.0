Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CDA6AEDBC
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:07:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCGSHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjCGSGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:06:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F211DA80F7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:59:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31B23B819BF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB53C433D2;
        Tue,  7 Mar 2023 17:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211978;
        bh=TVyvI3LABb7kprlA7HEyPFoBlNxP8xfusnzYgc0/gro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uV4dXxWDo0hZXZmfdYNNm50NJw0OE6XF4nc0zFhgy6BIVmWLt+wyIevC6xoNQ6ys/
         uYW0vMBXYmk3hC1izpCUkeQYtbRq7t/35UkLFYs99NZLLGRaqKtTPSvegpyMaQ5VRm
         LFu7xFEEhNJ7POEJHmmOLyJNfovYl475+jV5kYaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Petr Vorel <petr.vorel@gmail.com>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/885] arm64: dts: qcom: msm8992-bullhead: Disable dfps_data_mem
Date:   Tue,  7 Mar 2023 17:49:31 +0100
Message-Id: <20230307170003.277006263@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index 97f109cf82400..49f30efdbe656 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
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



