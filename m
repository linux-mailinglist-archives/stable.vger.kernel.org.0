Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5C556FB5D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbiGKJ35 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiGKJ33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:29:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B4C66D9F2;
        Mon, 11 Jul 2022 02:16:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB907CE125F;
        Mon, 11 Jul 2022 09:16:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0150C341C0;
        Mon, 11 Jul 2022 09:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530983;
        bh=wuFITWr7voOniBRlxupsTInvUgybpSVcKtHclsOVbcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWY90zNy9CBfsXXLpaXJ8dPGY9/WFYNxFCXSdGqjT+nc+Nr24bbVicWHTeh5Fd63k
         B1/E1TmQuxx/osPlT4v7+D7jVppGb3pBSpeey2wMaP592Qn24nN5pzPQeuCnWZGfN6
         AcpMllXVCzymtQNoeguqCp/gVlEYLYNXNk3UMOV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 054/112] arm64: dts: qcom: msm8994: Fix CPU6/7 reg values
Date:   Mon, 11 Jul 2022 11:06:54 +0200
Message-Id: <20220711090551.105006997@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 47bf59c4755930f616dd90c8c6a85f40a6d347ea ]

CPU6 and CPU7 were mistakengly pointing to CPU5 reg. Fix it.

Fixes: 02d8091bbca0 ("arm64: dts: qcom: msm8994: Add a proper CPU map")
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220501184016.64138-1-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index b1e595cb4b90..6b76321288d0 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -93,7 +93,7 @@
 		CPU6: cpu@102 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a57";
-			reg = <0x0 0x101>;
+			reg = <0x0 0x102>;
 			enable-method = "psci";
 			next-level-cache = <&L2_1>;
 		};
@@ -101,7 +101,7 @@
 		CPU7: cpu@103 {
 			device_type = "cpu";
 			compatible = "arm,cortex-a57";
-			reg = <0x0 0x101>;
+			reg = <0x0 0x103>;
 			enable-method = "psci";
 			next-level-cache = <&L2_1>;
 		};
-- 
2.35.1



