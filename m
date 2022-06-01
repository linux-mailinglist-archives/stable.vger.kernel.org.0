Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C7E53A666
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353545AbiFANxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353514AbiFANxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:53:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A68880D2;
        Wed,  1 Jun 2022 06:52:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3939C615CD;
        Wed,  1 Jun 2022 13:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8304CC34119;
        Wed,  1 Jun 2022 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091565;
        bh=EbLXjcLRXtxb0jXjdZtiVIGjSd5602C1FKsy5V+dTeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CwfpGTXA9PyLdUVe/2blOyxVNDlWpeT7hwnUCHfgGQAdeCOtrbZy9ib6Yzni9EreJ
         dEtS7SmAg2hZzkQ67ItlwzLuV3xq8YNPzt46s/dpJdjpMn29xsc6snKb6xWChjPMWU
         HXIC3jMXWwZmbiBlDoiwFcdq0NN/Zvu26IBcv0r8UTxPSvWYLBrPAHxhDYn6cjtINY
         8uNh38JiOZ7bd2+MhQUxvg+zMBsSfiQa3sQ60ID7q7lxbdu6Wyl9Qw5gcDGv8BHgd2
         eC4XO3QhW01WUYscgXhYFODos0PYn+B+L7xvWzTmzJPEG4AoqgRvCH5FYQ0o8hpAtC
         E4qTyjaXefEOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Selvaraj <jo@jsfamily.in>,
        Caleb Connolly <caleb@connolly.tech>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 14/49] arm64: dts: qcom: sdm845-xiaomi-beryllium: fix typo in panel's vddio-supply property
Date:   Wed,  1 Jun 2022 09:51:38 -0400
Message-Id: <20220601135214.2002647-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135214.2002647-1-sashal@kernel.org>
References: <20220601135214.2002647-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joel Selvaraj <jo@jsfamily.in>

[ Upstream commit 1f1c494082a1f10d03ce4ee1485ee96d212e22ff ]

vddio is misspelled with a "0" instead of "o". Fix it.

Signed-off-by: Joel Selvaraj <jo@jsfamily.in>
Reviewed-by: Caleb Connolly <caleb@connolly.tech>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/BY5PR02MB7009901651E6A8D5ACB0425ED91F9@BY5PR02MB7009.namprd02.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
index 367389526b41..a97f5e89e1d0 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-xiaomi-beryllium.dts
@@ -218,7 +218,7 @@ &dsi0 {
 	panel@0 {
 		compatible = "tianma,fhd-video";
 		reg = <0>;
-		vddi0-supply = <&vreg_l14a_1p8>;
+		vddio-supply = <&vreg_l14a_1p8>;
 		vddpos-supply = <&lab>;
 		vddneg-supply = <&ibb>;
 
-- 
2.35.1

