Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677466357C3
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236751AbiKWJqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbiKWJqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AA111578D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E7C661B74
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146C5C433B5;
        Wed, 23 Nov 2022 09:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196611;
        bh=3BVQFlI9Xv6+9PtX5E+AxRdo9ciUdmLL3GX+MxRYr4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PSy/1RsTXw3odDXsG6sU1h1FgZgLxWww52xBgZmipicw4BOW4j2S1BfzlmGapcJrT
         /J8pwU8d5ia0KlGN2H+KWR3hHg133a9mvdvFZnZbbONLo8VFv0GrrJ4RjupmtSzI49
         Pp9MSS/WlQN4O6iCp5FsClUi+7qeZwG4QKgkb8Zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 080/314] arm64: dts: qcom: sc8280xp: fix USB0 PHY PCS_MISC registers
Date:   Wed, 23 Nov 2022 09:48:45 +0100
Message-Id: <20221123084629.096775697@linuxfoundation.org>
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

[ Upstream commit 31b3b3059791be536e2ec0c6830767b596af340f ]

The USB0 SS PHY node had the PCS_MISC register block (0x1200) replaced
with PCS_USB (0x1700).

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20220919094454.1574-2-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index cdc395d53c5a..e3e192877a88 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1184,7 +1184,7 @@ usb_0_ssphy: usb3-phy@88eb400 {
 				      <0 0x088ec400 0 0x1f0>,
 				      <0 0x088eba00 0 0x100>,
 				      <0 0x088ebc00 0 0x3ec>,
-				      <0 0x088ec700 0 0x64>;
+				      <0 0x088ec200 0 0x18>;
 				#phy-cells = <0>;
 				#clock-cells = <0>;
 				clocks = <&gcc GCC_USB3_PRIM_PHY_PIPE_CLK>;
-- 
2.35.1



