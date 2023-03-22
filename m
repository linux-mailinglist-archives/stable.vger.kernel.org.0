Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479876C4934
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 12:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbjCVLcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 07:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbjCVLcu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 07:32:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D025ADE9;
        Wed, 22 Mar 2023 04:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E86062048;
        Wed, 22 Mar 2023 11:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35627C433A1;
        Wed, 22 Mar 2023 11:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679484768;
        bh=A224LTHWKyLxmjx6qp6P3XqpHiJ6RCtOe0JndfMbuWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdS+FNljpt/dOsy1LrjXkYjv512iVkZ9rD3totrRvXbNjlbUCjSz+xxRNAEGHF7+I
         YAiCsJfK10E3Ay2ZzqccwFq7jRTKR/nPwVd7EY4ggWknbb8nRO9bdLj56UkVyk4sEG
         ZZeFRzP+MK8aVxPcKHGbhbkMJhQUFUNcAfCVrHtZ81glExHlJpIh2Enl+UHb6W2gr2
         ZTPn+jZgvpqjJGf1Btyp7JvFSc4jA4p0evwGEeXK8UHHbtwXtQHFk4/A1l8Z/XtCUI
         53VUVtX7ZA4fJ07vD7i1rjqWQFolWAxDx0eI3JzdmMzGmklTwyVMMWwp+dKNWd8oK7
         1iru9e3FllRTA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pewjO-0004fN-NK; Wed, 22 Mar 2023 12:34:14 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Bjorn Andersson <andersson@kernel.org>
Cc:     Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/6] arm64: dts: qcom: sc8280xp-x13s: mark s11b regulator as always-on
Date:   Wed, 22 Mar 2023 12:33:13 +0100
Message-Id: <20230322113318.17908-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322113318.17908-1-johan+linaro@kernel.org>
References: <20230322113318.17908-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The s11b supply is used by the wlan module (as well as some of the
pmics) which are not yet fully described in the devicetree.

Mark the regulator as always-on for now.

Fixes: 123b30a75623 ("arm64: dts: qcom: sc8280xp-x13s: enable WiFi controller")
Cc: stable@vger.kernel.org	# 6.2
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
index 26dbba9f51fb..c79559e4b22e 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -386,6 +386,7 @@ vreg_s11b: smps11 {
 			regulator-min-microvolt = <1272000>;
 			regulator-max-microvolt = <1272000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-always-on;
 		};
 
 		vreg_s12b: smps12 {
-- 
2.39.2

