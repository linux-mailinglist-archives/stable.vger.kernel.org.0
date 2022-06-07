Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F60541260
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357171AbiFGTqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354422AbiFGToa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:44:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7591C6005C;
        Tue,  7 Jun 2022 11:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F6E8611DB;
        Tue,  7 Jun 2022 18:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CE2C385A2;
        Tue,  7 Jun 2022 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625909;
        bh=14VVMclWH7GSCZgc1tdjo8Jpgizmf34BnUzG9TLH3Wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=astqMyAhrVYu5m2jszLmlDt9zdRowbhnYPnvhrz+pZyDSUO04hbTrxf1/IW5V/zp2
         CE482ojoRsvEh7Mga3LYn2r4JNeWrz6y7xzO/tq92I0YvU9vmYKW47sGcPyYwWLqun
         S/00nooFEfBwfZOhCao8HSexyZq8JCtqhn9ADWmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 188/772] arm64: dts: qcom: msm8994: Fix the cont_splash_mem address
Date:   Tue,  7 Jun 2022 18:56:20 +0200
Message-Id: <20220607164954.577015550@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

[ Upstream commit 049c46f31a726bf8d202ff1681661513447fac84 ]

The default memory map places cont_splash_mem at 3401000, which was
overlooked.. Fix it!

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220319174645.340379-9-konrad.dybcio@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 215f56daa26c..480bc686e8e8 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -183,8 +183,8 @@
 			no-map;
 		};
 
-		cont_splash_mem: memory@3800000 {
-			reg = <0 0x03800000 0 0x2400000>;
+		cont_splash_mem: memory@3401000 {
+			reg = <0 0x03401000 0 0x2200000>;
 			no-map;
 		};
 
-- 
2.35.1



