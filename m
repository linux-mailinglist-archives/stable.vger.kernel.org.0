Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4DA4F31CB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344733AbiDEKkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243769AbiDEJkV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:40:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2C7B82C0;
        Tue,  5 Apr 2022 02:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F6CC614F9;
        Tue,  5 Apr 2022 09:25:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F091C385A0;
        Tue,  5 Apr 2022 09:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150700;
        bh=/maTMZpPyHrPXM73DSYyKjXwq5K+XsJdIA6vi+YbTEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CdFXc0HHymc35UXVFfCiYzU8ELPE8CNW3acW7w2ASH8Tw21AdaBQfm8nuivj7dSP
         18J7KSw2R1Y5y6qTlPVZkMefy4xDNB9OdV5W58XaDACX6LovFTiPq5f+Tj1jVu3IO0
         5lqFKc6LFcv/AoK+3v65xcihOz7zJJa4hdxm5arI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 5.15 149/913] ARM: dts: exynos: add missing HDMI supplies on SMDK5250
Date:   Tue,  5 Apr 2022 09:20:11 +0200
Message-Id: <20220405070344.302310449@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

commit 60a9914cb2061ba612a3f14f6ad329912b486360 upstream.

Add required VDD supplies to HDMI block on SMDK5250.  Without them, the
HDMI driver won't probe.  Because of lack of schematics, use same
supplies as on Arndale 5250 board (voltage matches).

Cc: <stable@vger.kernel.org> # v3.15+
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Link: https://lore.kernel.org/r/20220208171823.226211-2-krzysztof.kozlowski@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/exynos5250-smdk5250.dts |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -118,6 +118,9 @@
 	status = "okay";
 	ddc = <&i2c_2>;
 	hpd-gpios = <&gpx3 7 GPIO_ACTIVE_HIGH>;
+	vdd-supply = <&ldo8_reg>;
+	vdd_osc-supply = <&ldo10_reg>;
+	vdd_pll-supply = <&ldo8_reg>;
 };
 
 &i2c_0 {


