Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F354F2766
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbiDEIG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbiDEH7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FB55717D;
        Tue,  5 Apr 2022 00:53:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDAD5B81B90;
        Tue,  5 Apr 2022 07:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E75BC3410F;
        Tue,  5 Apr 2022 07:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145230;
        bh=SY5CrdqZiViwSqGKTiO8sCEsREGcjWYPSLn1jzZgA8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2uf/Dy9RoBVPVnKXiT4ub2OHNyuotPLr3VIZhi/RZmTLYnolrMmaxjOM6Yb2L24/C
         ocN/X6bHdBLH1TVwba7Aer2IXfz52u2hxQ6CX29kW6HJdG7u/Dny7eHgaDYBENmP2S
         V9mVwTaph5RPwgTow5S5BnBdONuzzOVtL6nBGFvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0331/1126] arm64: dts: qcom: sdm845: fix microphone bias properties and values
Date:   Tue,  5 Apr 2022 09:17:58 +0200
Message-Id: <20220405070417.332971045@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 625c24460dbbc3b6c9a148c0a30f0830893fc909 ]

replace millivolt with correct microvolt and adjust value to
the minimal value allowed by documentation.

Found with `make qcom/sdm845-oneplus-fajita.dtb`.

Fixes:
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias1-microvolt' is a required property
        From schema: Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias2-microvolt' is a required property
        From schema: Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias3-microvolt' is a required property
        From schema: Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias4-microvolt' is a required property
        From schema: Documentation/devicetree/bindings/sound/qcom,wcd934x.yaml
arch/arm64/boot/dts/qcom/sdm845-oneplus-fajita.dt.yaml: codec@1: 'qcom,micbias1-millivolt', 'qcom,micbias2-millivolt', 'qcom,micbias3-millivolt', 'qcom,micbias4-millivolt' do not match any of the regexes: '^.*@[0-9a-f]+$', 'pinctrl-[0-9]+'

Fixes: 27ca1de07dc3 ("arm64: dts: qcom: sdm845: add slimbus nodes")

Signed-off-by: David Heidelberg <david@ixit.cz>
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211213195105.114596-1-david@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index cfdeaa81f1bb..1bb4d98db96f 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -3613,10 +3613,10 @@
 					#clock-cells = <0>;
 					clock-frequency = <9600000>;
 					clock-output-names = "mclk";
-					qcom,micbias1-millivolt = <1800>;
-					qcom,micbias2-millivolt = <1800>;
-					qcom,micbias3-millivolt = <1800>;
-					qcom,micbias4-millivolt = <1800>;
+					qcom,micbias1-microvolt = <1800000>;
+					qcom,micbias2-microvolt = <1800000>;
+					qcom,micbias3-microvolt = <1800000>;
+					qcom,micbias4-microvolt = <1800000>;
 
 					#address-cells = <1>;
 					#size-cells = <1>;
-- 
2.34.1



