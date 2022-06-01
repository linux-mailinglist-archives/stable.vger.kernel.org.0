Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6927B53A6FF
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353912AbiFAN5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353920AbiFAN4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:56:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE828CCC2;
        Wed,  1 Jun 2022 06:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79FD8B81AEB;
        Wed,  1 Jun 2022 13:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E978C34119;
        Wed,  1 Jun 2022 13:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091690;
        bh=EbLXjcLRXtxb0jXjdZtiVIGjSd5602C1FKsy5V+dTeA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PbB1uj6FZiThQ/T6OWVdDEWCqwR48yTbI64GEFJNaF/LZqjYYQoVRT0BtMcD1nZ/Q
         iHLJNvLVvDcYYxEACd2JhkCmeAGpQ2b6HFTt+W3jbNJw+GGPwOr6mpBjGAi5owPtil
         RKceryKdBAIY3hftgr54Fv6nYE9PUec+ACOLX5L6p33d1SCyD2cV+7JvjgT+GkzBVx
         FL2YneTUFsaFF6YCAd5WWtJ/wfNsVMf92MMe9qRCgQ+klFprOUk406uj8y8BiZ/Bk4
         7JxR++K2ZWdXc5uosW14vl69tZ4EJN19TGmAzP5FQfH4nBpHDf/XTn++MR4kRZmop5
         sl0jomFR3Xx8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joel Selvaraj <jo@jsfamily.in>,
        Caleb Connolly <caleb@connolly.tech>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, agross@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 14/48] arm64: dts: qcom: sdm845-xiaomi-beryllium: fix typo in panel's vddio-supply property
Date:   Wed,  1 Jun 2022 09:53:47 -0400
Message-Id: <20220601135421.2003328-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
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

