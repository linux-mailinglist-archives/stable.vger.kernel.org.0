Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C18D54091A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349865AbiFGSFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351866AbiFGSCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:02:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E5E10EA76;
        Tue,  7 Jun 2022 10:45:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E035B8232D;
        Tue,  7 Jun 2022 17:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE27C385A5;
        Tue,  7 Jun 2022 17:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623957;
        bh=w8FYKQUExsKstyad/DdnaMx4vihIzvazBmurUFBgcRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpAf0ikflagecE6syQGK/cE5lACAEkCqFTGPyhWiRYFnAdnAU9tzqnilHWvCg7/18
         OzgL2XHNcbzdRHwXAwb1vvBZIUEbAEg4lEl1eDz1bBbVub76Le582tLdnzPMzRYLfQ
         cuFHCKoYC+iUvUXFbl+8BMaxITWncmTVtBUW52Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 153/667] arm64: dts: qcom: msm8994: Fix BLSP[12]_DMA channels count
Date:   Tue,  7 Jun 2022 18:56:58 +0200
Message-Id: <20220607164939.405456317@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 1ae438d26b620979ed004d559c304d31c42173ae ]

MSM8994 actually features 24 DMA channels for each BLSP,
fix it!

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220319174645.340379-14-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 1165269f059e..3c27671c8b5c 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -498,7 +498,7 @@
 			#dma-cells = <1>;
 			qcom,ee = <0>;
 			qcom,controlled-remotely;
-			num-channels = <18>;
+			num-channels = <24>;
 			qcom,num-ees = <4>;
 		};
 
@@ -634,7 +634,7 @@
 			#dma-cells = <1>;
 			qcom,ee = <0>;
 			qcom,controlled-remotely;
-			num-channels = <18>;
+			num-channels = <24>;
 			qcom,num-ees = <4>;
 		};
 
-- 
2.35.1



