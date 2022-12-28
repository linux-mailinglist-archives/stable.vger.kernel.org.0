Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45382657913
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiL1O5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:57:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiL1O5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:57:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E7C11C24
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:57:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70F8FB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA1CC433EF;
        Wed, 28 Dec 2022 14:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239435;
        bh=HNr5cZ0HXuOmL8WptTmahKluPWfhOTJ/MVIJ6lu5TcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVMV+rG8RQ9CtOsJ8Yj532tU5tooJlvGSeIDa+tSmCB5kzRNAtECSBtOgvEcytWlO
         MflQo3wjv0IUceStAYQCQm4jR/s3l8Rwl3EA5P+cgioDdo/qlNF6wLtLD4F82sHhpC
         kuME7vovTMlCK8usDex3mh4zR7lw/F0oZKdv38Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Doug Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0029/1073] arm64: dts: qcom: sc7180-trogdor-homestar: fully configure secondary I2S pins
Date:   Wed, 28 Dec 2022 15:26:57 +0100
Message-Id: <20221228144328.935987103@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 59e787935cfe6f562fbb9117e2df4076eaf810d8 ]

The Trogdor Homestar DTSI adds additional GPIO52 pin to secondary I2S pins
("sec_mi2s_active") and configures it to "mi2s_1" function.

The Trogdor DTSI (which is included by Homestar) configures drive
strength and bias for all "sec_mi2s_active" pins, thus the intention was
to apply this configuration also to GPIO52 on Homestar.

Reported-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: be0416a3f917 ("arm64: dts: qcom: Add sc7180-trogdor-homestar")
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221020225135.31750-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
index 1bd6c7dcd9e9..bfab67f4a7c9 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
@@ -194,6 +194,12 @@ pinmux {
 		pins = "gpio49", "gpio50", "gpio51", "gpio52";
 		function = "mi2s_1";
 	};
+
+	pinconf {
+		pins = "gpio49", "gpio50", "gpio51", "gpio52";
+		drive-strength = <2>;
+		bias-pull-down;
+	};
 };
 
 &ts_reset_l {
-- 
2.35.1



