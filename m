Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8304F2764
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233371AbiDEIGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiDEH7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6193D37A2C;
        Tue,  5 Apr 2022 00:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF90B615CD;
        Tue,  5 Apr 2022 07:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBD3C3410F;
        Tue,  5 Apr 2022 07:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145298;
        bh=OVYuAGTQx5dSN0iF81tVUGvUVEbzaoIJnsYHukZKhrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sM1JckKTNl2sshuqLZMx8wFH/QqNEQF1eJ1dMU1S7tgapGZYc0LJDGDuBg5G1BE0x
         CzpEHzaFkmrSA9Q7sXY+HzVP/jvBQgJ1IxvWN0NcXKEuA2Q9lrCh1vovr2jZk49J9X
         zlpxCXANXfrg2O8d+X0xN+70/sTAxX2xfL5bbtgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0357/1126] arm64: dts: ti: k3-j721s2-mcu-wakeup: Fix the interrupt-parent for wkup_gpioX instances
Date:   Tue,  5 Apr 2022 09:18:24 +0200
Message-Id: <20220405070418.107252350@linuxfoundation.org>
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

From: Keerthy <j-keerthy@ti.com>

[ Upstream commit 223d9ac45efb9311e7b2b0494c3ed25c701c6a5d ]

The interrupt-parent for wkup_gpioX instances are wrongly assigned as
main_gpio_intr instead of wkup_gpio_intr. Fix it.

Fixes: b8545f9d3a54 ("arm64: dts: ti: Add initial support for J721S2 SoC")
Signed-off-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Kishon Vijay Abraham I <kishon@ti.com>
Link: https://lore.kernel.org/r/20220203132647.11314-1-a-govindraju@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
index 7521963719ff..6c5c02edb375 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-mcu-wakeup.dtsi
@@ -108,7 +108,7 @@
 		reg = <0x00 0x42110000 0x00 0x100>;
 		gpio-controller;
 		#gpio-cells = <2>;
-		interrupt-parent = <&main_gpio_intr>;
+		interrupt-parent = <&wkup_gpio_intr>;
 		interrupts = <103>, <104>, <105>, <106>, <107>, <108>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
@@ -124,7 +124,7 @@
 		reg = <0x00 0x42100000 0x00 0x100>;
 		gpio-controller;
 		#gpio-cells = <2>;
-		interrupt-parent = <&main_gpio_intr>;
+		interrupt-parent = <&wkup_gpio_intr>;
 		interrupts = <112>, <113>, <114>, <115>, <116>, <117>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-- 
2.34.1



