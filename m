Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DE1540C1A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbiFGSd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353078AbiFGSbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:31:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF85217CC83;
        Tue,  7 Jun 2022 10:56:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2835B82374;
        Tue,  7 Jun 2022 17:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33DD9C34115;
        Tue,  7 Jun 2022 17:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624604;
        bh=mbM4lFYWufa3Mlp5ZMoSuDYbE+24tQdhs04k3HMjwxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zy9iVEmDTwztjQZCG3C5nIJTeBspZs5UjHhxfR8TCC9ALIbJWn7i9jmQzzZlEGCeA
         HPnJhec/EPtbJYNYPpkDORQhxh23vu9jOVgxQ0FUsU/JUoxkkFbZJIhSONzFLwyOQp
         sGdyg4MzOAZF1bbpLF9jkJ6sviwaok89WCgSSONE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 386/667] ARM: dts: BCM5301X: Update pin controller node name
Date:   Tue,  7 Jun 2022 19:00:51 +0200
Message-Id: <20220607164946.324831466@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 130b5e32ba9d2d2313e39cf3f6d0729bff02b76a ]

This fixes:
arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dtb: cru-bus@100: 'pin-controller@1c0' does not match any of the regexes: '^clock-controller@[a-f0-9]+$', '^phy@[a-f0-9]+$', '^pinctrl@[a-f0-9]+$', '^syscon@[a-f0-9]+$', '^thermal@[a-f0-9]+$'
        From schema: Documentation/devicetree/bindings/mfd/brcm,cru.yaml
arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dtb: pin-controller@1c0: $nodename:0: 'pin-controller@1c0' does not match '^(pinctrl|pinmux)(@[0-9a-f]+)?$'
        From schema: Documentation/devicetree/bindings/pinctrl/brcm,ns-pinmux.yaml

Ref: e7391b021e3f ("dt-bindings: mfd: brcm,cru: Rename pinctrl node")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index db8c3f684786..30217948ef82 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -455,7 +455,7 @@
 				reg = <0x180 0x4>;
 			};
 
-			pinctrl: pin-controller@1c0 {
+			pinctrl: pinctrl@1c0 {
 				compatible = "brcm,bcm4708-pinmux";
 				reg = <0x1c0 0x24>;
 				reg-names = "cru_gpio_control";
-- 
2.35.1



