Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04ED66D2D90
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 04:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbjDACE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 22:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjDACE2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 22:04:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A651718;
        Fri, 31 Mar 2023 19:04:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99A3AB83303;
        Sat,  1 Apr 2023 01:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E88BC4339C;
        Sat,  1 Apr 2023 01:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313366;
        bh=HLziX9yQsRyMNBX7Zv2bMuzsajdwysD2DN7RUAmWucM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dwnVhk+Sz8rXtof6yIwBHHun3QwIs1Xqf0QgRO1WZhKM0E2HvYVfG46dT6uR331UD
         VQk/X8RG8BuJZJtIXEYh3jTYt2eZ1AF1QOjN4RaTVA3CJoiMUG4l2jkF23/1J92/R/
         ovjqa9jFQhw1NpPRgMP/w6OrsTOA6oCEXeUqkI45FrrmniFvi7Xo7e0xTAV5MkmdZ7
         zrD4F1dQtRZHKsn8S1+XHVMSyO6QyJaiQXhI4GPrzcNdfg0H3xL4nPXTUpzbxgNWDL
         4Qg7If8lyLkX2FTgWQCbI5dmt1SbezMceoYyuLB8/6iCwXpK3FQ8celQ5a76JEG0d1
         mgLC4jdcKroDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Weiss <luca@z3ntu.xyz>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 02/24] ARM: dts: qcom: apq8026-lg-lenok: add missing reserved memory
Date:   Fri, 31 Mar 2023 21:42:18 -0400
Message-Id: <20230401014242.3356780-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014242.3356780-1-sashal@kernel.org>
References: <20230401014242.3356780-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Weiss <luca@z3ntu.xyz>

[ Upstream commit ecd240875e877d78fd03efbc62292f550872df3f ]

Turns out these two memory regions also need to be avoided, otherwise
weird things will happen when Linux tries to use this memory.

Signed-off-by: Luca Weiss <luca@z3ntu.xyz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308-lenok-reserved-memory-v1-1-b8bf6ff01207@z3ntu.xyz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts b/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
index 193569f0ca5f7..4bdadb7681c30 100644
--- a/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
+++ b/arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts
@@ -26,6 +26,16 @@ chosen {
 	};
 
 	reserved-memory {
+		sbl_region: sbl@2f00000 {
+			reg = <0x02f00000 0x100000>;
+			no-map;
+		};
+
+		external_image_region: external-image@3100000 {
+			reg = <0x03100000 0x200000>;
+			no-map;
+		};
+
 		adsp_region: adsp@3300000 {
 			reg = <0x03300000 0x1400000>;
 			no-map;
-- 
2.39.2

