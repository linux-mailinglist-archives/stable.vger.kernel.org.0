Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52F65414C4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358895AbiFGUV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359868AbiFGUVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:21:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B4A17A880;
        Tue,  7 Jun 2022 11:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A90F5B82340;
        Tue,  7 Jun 2022 18:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075FFC385A2;
        Tue,  7 Jun 2022 18:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626652;
        bh=bFhZ957r2YH94rqSbhXVV4Hj1qf6FyXRtokEAkKhViw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYaZhX190OOJmP1fZfbn2eE97MlDRUDAgNS2xtxFFvsibYm2VttWZCGn1aKGyIRJ7
         X6RJt/FaK3BCr7tDlgye1eUxkpb8VF2mbXWXwqMsVxLiAL3fTaGsRiksLIqvshluwg
         obnws4Id8/wUcfapaJa5j1ZyD/ypc4vJ98hBYWeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 455/772] ARM: dts: BCM5301X: Update pin controller node name
Date:   Tue,  7 Jun 2022 19:00:47 +0200
Message-Id: <20220607165002.410240153@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 603c700c706f..65f8a759f1e3 100644
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



