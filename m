Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B434F279C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbiDEIHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiDEH7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F7F5748A;
        Tue,  5 Apr 2022 00:53:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42616615C3;
        Tue,  5 Apr 2022 07:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB56C34110;
        Tue,  5 Apr 2022 07:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145233;
        bh=MBJNukljmwQnzR5zg24hkhfWMssQy3eMfwPIH82ryCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayPieFVQK+tDGUwAv21FtmkErjt1kNA8I8BuPePfPVQS46dr0ryACSmSmErCg+GXl
         +od+e+pQTQJutTDkJphuNGZ022rR+PsEJc0xOC8w5hrPtrSVpgwMMv5ReUugEM57+1
         ge1rMhHUk7N6EYWyyXeXT99HjgVlICfLGaUanEW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0332/1126] arm64: dts: qcom: sm8250: fix PCIe bindings to follow schema
Date:   Tue,  5 Apr 2022 09:17:59 +0200
Message-Id: <20220405070417.361513582@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d60507200485bc778bf6a5556271d784ab09d913 ]

Replace (unused) enable-gpio binding with schema-defined wake-gpios. The
GPIO line is still unused, but at least we'd follow the defined schema.

While we are at it, change perst-gpio property to follow the preferred
naming schema (perst-gpios).

Fixes: 13e948a36db7 ("arm64: dts: qcom: sm8250: Commonize PCIe pins")
Cc: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211214231448.2044987-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index e2a5dfa7b1a0..a92230bec1dd 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1740,8 +1740,8 @@
 			phys = <&pcie0_lane>;
 			phy-names = "pciephy";
 
-			perst-gpio = <&tlmm 79 GPIO_ACTIVE_LOW>;
-			enable-gpio = <&tlmm 81 GPIO_ACTIVE_HIGH>;
+			perst-gpios = <&tlmm 79 GPIO_ACTIVE_LOW>;
+			wake-gpios = <&tlmm 81 GPIO_ACTIVE_HIGH>;
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&pcie0_default_state>;
@@ -1844,8 +1844,8 @@
 			phys = <&pcie1_lane>;
 			phy-names = "pciephy";
 
-			perst-gpio = <&tlmm 82 GPIO_ACTIVE_LOW>;
-			enable-gpio = <&tlmm 84 GPIO_ACTIVE_HIGH>;
+			perst-gpios = <&tlmm 82 GPIO_ACTIVE_LOW>;
+			wake-gpios = <&tlmm 84 GPIO_ACTIVE_HIGH>;
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&pcie1_default_state>;
@@ -1950,8 +1950,8 @@
 			phys = <&pcie2_lane>;
 			phy-names = "pciephy";
 
-			perst-gpio = <&tlmm 85 GPIO_ACTIVE_LOW>;
-			enable-gpio = <&tlmm 87 GPIO_ACTIVE_HIGH>;
+			perst-gpios = <&tlmm 85 GPIO_ACTIVE_LOW>;
+			wake-gpios = <&tlmm 87 GPIO_ACTIVE_HIGH>;
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&pcie2_default_state>;
-- 
2.34.1



