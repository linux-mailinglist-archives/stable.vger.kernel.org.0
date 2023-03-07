Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4E36AE85F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbjCGRPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCGROp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9CA8FBD0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 328AFB8199A
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82031C433EF;
        Tue,  7 Mar 2023 17:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208994;
        bh=068jDOsDVjFz9fffEUC8LMNHniQ23B84+s4CraJECiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Purc3kNJNycoTqsOLWse+5d3rQpnIAOWQDmVaGFCdz/5qWqsvevdxGnXTDyl6vI7H
         hvMwegDTm5xSOXcKrSnuhhirRMEwVz5WKozAWIi2ZdD/WonaRbPEy1zEYTu6fEe3kA
         KLcfbSdE/zHwqGL3sQSxYdZtP9PkFVFMcOtVgEJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0076/1001] arm64: dts: amlogic: meson-axg-jethome-jethub-j1xx: fix invalid rtc node name
Date:   Tue,  7 Mar 2023 17:47:28 +0100
Message-Id: <20230307170025.396581560@linuxfoundation.org>
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

[ Upstream commit 956f52025c5dd92c80c12e31c99c854086a6fc55 ]

Fixes:
pcf8563@51: $nodename:0: 'pcf8563@51' does not match '^rtc(@.*|-[0-9a-f])*$'

Link: https://lore.kernel.org/r/20230124-b4-amlogic-bindings-fixups-v1-8-44351528957e@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
index 1916c007cba58..e1605a9b0a13f 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
@@ -217,7 +217,7 @@ &i2c1 {
 	pinctrl-names = "default";
 
 	/* RTC */
-	pcf8563: pcf8563@51 {
+	pcf8563: rtc@51 {
 		compatible = "nxp,pcf8563";
 		reg = <0x51>;
 		status = "okay";
-- 
2.39.2



