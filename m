Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFCA6357D6
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238196AbiKWJqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiKWJqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76211165A7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A47661B65
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565E7C433D6;
        Wed, 23 Nov 2022 09:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196615;
        bh=Q+o/j3EO3T6xfOu/fqqIB8jSgqWGrqYfpy8sfN8veD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rmic+FQ1Lec5Ex360wCoSuX4/+iB0t5ZEPGQzaxFS83kdrb2yItIbDO3fjFfHdiZ5
         Kxl8w+FaXGbIbXJxqzcbmq5EutVKC3l9duIg8RuvpXTXId/FnLsMiEa2kpRgJiA1my
         xmkbhRL0j2yzMT8FhSZLvzJPJUXPk74pWby2FNDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 081/314] arm64: dts: qcom: sc8280xp: fix USB1 PHY RX1 registers
Date:   Wed, 23 Nov 2022 09:48:46 +0100
Message-Id: <20221123084629.143814463@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 81cad26c6c3984d01b0612069c70ffd820f62dfa ]

The USB1 SS PHY node had the RX1 register block (0x600) replaced with
RX2 (0xc00).

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220919094454.1574-3-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index e3e192877a88..2b8eea373163 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1242,7 +1242,7 @@ usb_1_qmpphy: phy-wrapper@8904000 {
 
 			usb_1_ssphy: usb3-phy@8903400 {
 				reg = <0 0x08903400 0 0x100>,
-				      <0 0x08903c00 0 0x3ec>,
+				      <0 0x08903600 0 0x3ec>,
 				      <0 0x08904400 0 0x1f0>,
 				      <0 0x08903a00 0 0x100>,
 				      <0 0x08903c00 0 0x3ec>,
-- 
2.35.1



