Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DDF593E36
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbiHOUh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346687AbiHOUgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:36:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4F94E843;
        Mon, 15 Aug 2022 12:06:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BB1CB810A2;
        Mon, 15 Aug 2022 19:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFF3C433C1;
        Mon, 15 Aug 2022 19:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590412;
        bh=lyE0Uoi4jt5cS3p9ntPQyP0WH2gJ35GJtynLlM09Ihs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cf0JdUihryG0f5wKx6B/Vqm1vx918XsgVjBtk1pPhBg4tMOBOlHEA4HtedDa8RLYp
         iV4dMfxJkbjXDmmk2TTyi0FS2S1MO4yRLMDf1npnjyO2tkbXSdGjyz7ClmmG40FlND
         E7DztCp5TB5XdLWXz2c10/II0/BupBhCz27FpNPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sireesh Kodali <sireeshkodali1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0251/1095] arm64: dts: qcom: msm8916: Fix typo in pronto remoteproc node
Date:   Mon, 15 Aug 2022 19:54:10 +0200
Message-Id: <20220815180440.142752756@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index e34963505e07..7ecd747dc624 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1758,8 +1758,8 @@ pronto: remoteproc@a21b000 {
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



