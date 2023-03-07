Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D664B6AE835
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCGROF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjCGRNI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:13:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C40880936
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:08:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D576B819A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533F0C433EF;
        Tue,  7 Mar 2023 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208892;
        bh=uu4fTqgmkgZcz/KVZl73vpBU7jZIanvK/uILpJ5R0bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFlac2qW9wKdxtaBLeN1GNlykqjROdKzVVX2EsHv9R1Pu+el6u1Fbh3FAYnEl4tJa
         KpOqPocsNrwaFBsY36Jm0WxSmRCVZv/m5G9x3c3DCiUBlEfzCZkV9EBg4N46VFmQKl
         RPcxRN+VG7FusYTXjdpvkLh0Prak9CEdlcGBlVJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vyacheslav Bocharov <adeep@lexina.in>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0043/1001] arm64: dts: meson-gxl: jethub-j80: Fix WiFi MAC address node
Date:   Tue,  7 Mar 2023 17:46:55 +0100
Message-Id: <20230307170023.998506583@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit f95acdb2b4af21caae2c76a48e565158181386ca ]

Unit addresses should be written using lower-case hex characters. Use
wifi_mac@c to fix a yaml schema validation error once the eFuse
dt-bindings have been converted to a yaml schema:
  efuse: Unevaluated properties are not allowed ('wifi_mac@C' was
  unexpected)

Also node names should use hyphens instead of underscores as the latter
can also cause warnings.

Fixes: abfaae24ecf3 ("arm64: dts: meson-gxl: add support for JetHub H1")
Acked-by: Vyacheslav Bocharov <adeep@lexina.in>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-2-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts     | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
index 6831137c5c109..270483e007bc8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dts
@@ -90,7 +90,7 @@ bt_mac: bt_mac@6 {
 		reg = <0x6 0x6>;
 	};
 
-	wifi_mac: wifi_mac@C {
+	wifi_mac: wifi-mac@c {
 		reg = <0xc 0x6>;
 	};
 };
-- 
2.39.2



