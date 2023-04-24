Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E38C6ECEB5
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbjDXNeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbjDXNeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:34:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEE97DAC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CF1F61E07
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B6CC433EF;
        Mon, 24 Apr 2023 13:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343235;
        bh=4gXVQtAcaW0FgitIlf8EbiYrPIpEIU7SBrpJE+zKxwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FISwYwzlAdWbAPMZqC9KHQ3PJlIooyoLf8RdKEQ9H3kdou01yMTpCpJFd1JZ3o8H9
         dTQkDY+ZppBAGIhkM2jjsxLb4fbn7C9vFwNKm/3fA0S2ufYvnLlm0K1fIHVTmrDJRW
         RgUBi8Pp8HhrJ/tpSLorctImETJQmB5eKj2ExJsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Gonzalez <mgonzalez@freebox.fr>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/68] arm64: dts: meson-g12-common: specify full DMC range
Date:   Mon, 24 Apr 2023 15:17:34 +0200
Message-Id: <20230424131127.802311032@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Gonzalez <mgonzalez@freebox.fr>

[ Upstream commit aec4353114a408b3a831a22ba34942d05943e462 ]

According to S905X2 Datasheet - Revision 07:
DRAM Memory Controller (DMC) register area spans ff638000-ff63a000.

According to DeviceTree Specification - Release v0.4-rc1:
simple-bus nodes do not require reg property.

Fixes: 1499218c80c99a ("arm64: dts: move common G12A & G12B modes to meson-g12-common.dtsi")
Signed-off-by: Marc Gonzalez <mgonzalez@freebox.fr>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Link: https://lore.kernel.org/r/20230327120932.2158389-2-mgonzalez@freebox.fr
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index c0defb36592d0..9dd9f7715fbe6 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1604,10 +1604,9 @@
 
 			dmc: bus@38000 {
 				compatible = "simple-bus";
-				reg = <0x0 0x38000 0x0 0x400>;
 				#address-cells = <2>;
 				#size-cells = <2>;
-				ranges = <0x0 0x0 0x0 0x38000 0x0 0x400>;
+				ranges = <0x0 0x0 0x0 0x38000 0x0 0x2000>;
 
 				canvas: video-lut@48 {
 					compatible = "amlogic,canvas";
-- 
2.39.2



