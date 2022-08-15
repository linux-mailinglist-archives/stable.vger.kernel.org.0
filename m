Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE125936AA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbiHOSmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243575AbiHOSlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58302ED5C;
        Mon, 15 Aug 2022 11:24:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09EBA60FB8;
        Mon, 15 Aug 2022 18:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CFFC433D6;
        Mon, 15 Aug 2022 18:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587887;
        bh=lJ6yWdOYTSwDorEM6lVgpgfm9KNuX8QvSpIRLKKt5tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HID9Pvp994UzCkEQyZkTmj20pouSUqs3KQkmm9piE8Q5SztsC49sZG6OsqZzVf82S
         7uk2jMXKtx91LD7cv2iWJ7izYSpPbgldA44cNhvl9KdkVeApn4AQQzNSv74Gna2rPk
         QX28wsrLixlLUAwcA31qGr2j82WJMoHos6rzPLyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sireesh Kodali <sireeshkodali1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/779] arm64: dts: qcom: msm8916: Fix typo in pronto remoteproc node
Date:   Mon, 15 Aug 2022 19:57:19 +0200
Message-Id: <20220815180345.614725077@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sireesh Kodali <sireeshkodali1@gmail.com>

[ Upstream commit 5458d6f2827cd30218570f266b8d238417461f2f ]

The smem-state properties for the pronto node were incorrectly labelled,
reading `qcom,state*` rather than `qcom,smem-state*`. Fix that, allowing
the stop state to be used.

Fixes: 88106096cbf8 ("ARM: dts: msm8916: Add and enable wcnss node")
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220526141740.15834-3-sireeshkodali1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 8b2724272464..19e201f52b16 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1747,8 +1747,8 @@ pronto: remoteproc@a21b000 {
 					<&rpmpd MSM8916_VDDMX>;
 			power-domain-names = "cx", "mx";
 
-			qcom,state = <&wcnss_smp2p_out 0>;
-			qcom,state-names = "stop";
+			qcom,smem-states = <&wcnss_smp2p_out 0>;
+			qcom,smem-state-names = "stop";
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&wcnss_pin_a>;
-- 
2.35.1



