Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6E657964
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiL1PAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:00:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbiL1PA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D33A412AEF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CFB26154C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CF3C433D2;
        Wed, 28 Dec 2022 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239624;
        bh=LePJ2vt1YjtHwGGSiscpXiJIZjF6rgIfetJV+DGwa8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hc8ch8w0c+4bYaAbHwxiXNiz1n7VgMdhnEsyVdBW1HQ/r0zxQ12Hp9rrCxKyzr6na
         CNzepL6pe4J8DFM9nFgFEycXIrH3cSBdzHZbvokZQQebw+A3teZdwgbeDZ+ne++z9A
         XcwwvWdiaiNxWNtuXYvoMYoPKfXiwpgtZfn8Oi2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0005/1146] arm64: dts: qcom: sm8250-sony-xperia-edo: fix touchscreen bias-disable
Date:   Wed, 28 Dec 2022 15:25:44 +0100
Message-Id: <20221228144330.330850958@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 7ff4a646fae3697b039c6b684786a1e309e8445c ]

The property to disable bias is "bias-disable".

Fixes: e76c7e1f15fe ("arm64: dts: qcom: sm8250-edo: Add Samsung touchscreen")
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220930192954.242546-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
index 5428aab3058d..e4769dcfaad7 100644
--- a/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250-sony-xperia-edo.dtsi
@@ -619,7 +619,7 @@ ts_int_default: ts-int-default {
 		pins = "gpio39";
 		function = "gpio";
 		drive-strength = <2>;
-		bias-disabled;
+		bias-disable;
 		input-enable;
 	};
 
-- 
2.35.1



