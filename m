Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664FC6578F7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiL1O4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233253AbiL1O4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:56:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40CFDF1
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:56:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7059861551
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AEAC433EF;
        Wed, 28 Dec 2022 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239366;
        bh=n5yV5tTFWa2mM5JRZ3IxA7qXWWr2cfGUdwUwoG2a2Y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqUCiJ2p9n5QkCEES/o/r2hf5bgs1KrUIBzVnHTSoVCgaCn7WgYkLD4uMdvc5MChX
         7Oj6NruvwykbyiARcDlQdweKds5solaxwDIcjMRUxHVFQh539lOkTO9AQ+kqO6Z1b7
         EuxU/ydbopvOi2AuErLoMS6ytRlufk56t6je1Rsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0017/1073] arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias
Date:   Wed, 28 Dec 2022 15:26:45 +0100
Message-Id: <20221228144328.627070594@linuxfoundation.org>
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

[ Upstream commit 9bce41fab14da8f21027dc9847535ef5e22cbe8b ]

There is no "bias-no-pull" property.  Assume intentions were disabling
bias.

Fixes: 79e7739f7b87 ("arm64: dts: qcom: sdm845-cheza: add initial cheza dt")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221010114417.29859-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
index b5eb8f7eca1d..b5f11fbcc300 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi
@@ -1436,7 +1436,7 @@ ap_suspend_l_assert: ap_suspend_l_assert {
 		config {
 			pins = "gpio126";
 			function = "gpio";
-			bias-no-pull;
+			bias-disable;
 			drive-strength = <2>;
 			output-low;
 		};
@@ -1446,7 +1446,7 @@ ap_suspend_l_deassert: ap_suspend_l_deassert {
 		config {
 			pins = "gpio126";
 			function = "gpio";
-			bias-no-pull;
+			bias-disable;
 			drive-strength = <2>;
 			output-high;
 		};
-- 
2.35.1



