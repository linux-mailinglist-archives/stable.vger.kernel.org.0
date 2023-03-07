Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244516AEE0A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbjCGSJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjCGSI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:08:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDADF7A937
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:03:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CB93BCE1C79
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A04C4339C;
        Tue,  7 Mar 2023 18:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212188;
        bh=gtvOJfSLuEURTPpaOL10tOXmuupFAfBmKlnJSPqQlI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TCY6YUQoAJa35Co3FNJhhip6ag+ahfUvECzKNu/6/62dW25tqITJ+XS7sEGWWZEd1
         S/mWYErOnZdXKDCDfgq9znn2NuZTcLeFuHbvZ/ps4joGupgQdyYmSe+JkZhwjDVXw2
         +6Br6GLz3+sKXcdlV2zE4PScgsVVvjb3XhhY0yDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 105/885] arm64: dts: qcom: pmk8350: Use the correct PON compatible
Date:   Tue,  7 Mar 2023 17:50:39 +0100
Message-Id: <20230307170006.448548710@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit c0ee8e0ba5cc17623e63349a168b41e407b1eef0 ]

A special compatible was introduced for PMK8350 both in the driver and
the bindings to facilitate for 2 base registers (PBS & HLOS). Use it.

Fixes: b2de43136058 ("arm64: dts: qcom: pmk8350: Add peripherals for pmk8350")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230213212930.2115182-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmk8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmk8350.dtsi b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
index ec002eecb19d9..f0d256d99e62e 100644
--- a/arch/arm64/boot/dts/qcom/pmk8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
@@ -16,7 +16,7 @@ pmk8350: pmic@0 {
 		#size-cells = <0>;
 
 		pmk8350_pon: pon@1300 {
-			compatible = "qcom,pm8998-pon";
+			compatible = "qcom,pmk8350-pon";
 			reg = <0x1300>, <0x800>;
 			reg-names = "hlos", "pbs";
 
-- 
2.39.2



