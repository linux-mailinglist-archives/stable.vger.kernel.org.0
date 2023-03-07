Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46EED6AE836
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCGROJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjCGRNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:13:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C29B7EA16
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:08:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDDB9B819A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AFCC433D2;
        Tue,  7 Mar 2023 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208898;
        bh=KdT5cdtrr7CIf/EfSUMYBfTXiMKM4jDUZ6YwFh2ToIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJKGGSJ3TnFQZoSsI5OdSKt+Z32LlAI7deIqV+ADHkGweNk+bkeIdtWv6C3YFZ9jp
         rExggpNCITaNofJphF/kScG/nHL8Jdcdrs3yt3J3o8MI1vy8m3fYDpeU9NSxaOj8Bp
         3KXpgIB6Puuq5IYDv4VZZjVkywg0Js2+NJzBVkcA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0045/1001] arm64: dts: meson-axg: jethub-j1xx: Fix MAC address node names
Date:   Tue,  7 Mar 2023 17:46:57 +0100
Message-Id: <20230307170024.065697655@linuxfoundation.org>
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

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 2f66eeb06e3e8b1cac9e9093be3baadbac2709eb ]

Node names should use hyphens instead of underscores to not cause
warnings.

Fixes: 59ec069d5055 ("arm64: dts: meson-axg: add support for JetHub D1p (j110)")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-4-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi     | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
index 5836b00309312..22fd43b5fd73c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
@@ -168,15 +168,15 @@ sn: sn@32 {
 		reg = <0x32 0x20>;
 	};
 
-	eth_mac: eth_mac@0 {
+	eth_mac: eth-mac@0 {
 		reg = <0x0 0x6>;
 	};
 
-	bt_mac: bt_mac@6 {
+	bt_mac: bt-mac@6 {
 		reg = <0x6 0x6>;
 	};
 
-	wifi_mac: wifi_mac@c {
+	wifi_mac: wifi-mac@c {
 		reg = <0xc 0x6>;
 	};
 
-- 
2.39.2



