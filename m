Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1BC6AE854
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjCGRPN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCGROn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A393B3E5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:09:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45CAE614E7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439D2C433D2;
        Tue,  7 Mar 2023 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208978;
        bh=HnLrCH3iQXSmyQVxV6BMxPB+jKxEXYwkmL3FfWW3lFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wb5+Ja+DGV7ylDhP5vdRxL4G5o/IgB9ShJm9ATRyU+RBq6spTXi71V8Z96raCF9ZV
         KBUiUJUJ2pT163H63XE+fvYHO/otLXHlVb+230FQg+DAyxxTetJ0Dl4jF+NpDccM9h
         9RP9jxUaD+vDaNmgfL23QHhzHd9RcCl4+7d1HMGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0072/1001] arm64: dts: amlogic: meson-axg-jethome-jethub-j1xx: fix supply name of USB controller node
Date:   Tue,  7 Mar 2023 17:47:24 +0100
Message-Id: <20230307170025.196348113@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit a69cb1042cea840bc7b60fea1c26a6b259e68bf2 ]

Fixes:
usb@ffe09080: 'phy-supply' does not match any of the regexes: '^usb@[0-9a-f]+$', 'pinctrl-[0-9]+'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-4-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
index 22fd43b5fd73c..1916c007cba58 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
@@ -303,7 +303,7 @@ &uart_AO_B {
 
 &usb {
 	status = "okay";
-	phy-supply = <&usb_pwr>;
+	vbus-supply = <&usb_pwr>;
 };
 
 &spicc1 {
-- 
2.39.2



