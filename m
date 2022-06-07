Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB308542000
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 02:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbiFHAFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 20:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455447AbiFGXSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 19:18:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BCC21C611
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 14:15:48 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d22so15865432plr.9
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 14:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jT8DLfbyhUAC8YupnNkx7/WPeiPnBTRo6q4n9p3S9IY=;
        b=VlUgXcU9owX1EBIje6hBA2fwQ9kjFpI9bPxIwfz3BBF+P0QwC14EOuzXoFF8wDys4m
         LvFexAAmIgm9t44ySB3iZn4tl5NRcrd+xFuGu0qVyxf3w/br+VLAlQmjgGoWKBREO2gT
         mBi4xnNl9LeVoaIH1Mm5CLnk7Jt6LFoQ9GNFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jT8DLfbyhUAC8YupnNkx7/WPeiPnBTRo6q4n9p3S9IY=;
        b=2JE24TmX5bpDyIxHyDdWCMJ2ZhKE/J4DXCjjMDoG4N6qKZLqxIwxoJ0Yl7v3y1jF+e
         EdQrDU+qbgKA2FbRcnb8kksCv65eKHIwDaUHwvbHD9SFlyuIo5T6ld76nk4OFUSmNym3
         nqi/tzDEgYvvv4EbgFj0sko1Ys1swFgbBvq5B31SGRcyIkY+hUmefAeJY52VviNvsi4S
         BSmXgWD17YgwRmpeF9CUnXiDVZh8lhjkDKMZBgoR0w48FDPR1yBUH0i8/3+KCxgmApAx
         WTClp5cEYtixvNmIowWke8aQ7WC34mYBQG4T/4k2lQdH6Upj3X/Rwoq5q0a0T0LBsOqp
         jpSQ==
X-Gm-Message-State: AOAM5318TORDgpxHoNRm2LjUftbBAnQRw5GyF/WrE6c4gPMSlHHMfQGJ
        aMe6LTk8omscc5AC3zt9CXNedQ==
X-Google-Smtp-Source: ABdhPJxhFzWqzH75FBiSKGcGqopAKv26dB/QVu2+AEpLNrGFVc0gxO7a4bpodDrd1FVbJmDNPWR2Tg==
X-Received: by 2002:a17:903:110e:b0:167:8847:5d9d with SMTP id n14-20020a170903110e00b0016788475d9dmr8945619plh.3.1654636548284;
        Tue, 07 Jun 2022 14:15:48 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:b689:cc5b:e6ad:930e])
        by smtp.gmail.com with UTF8SMTPSA id g7-20020a636b07000000b003fd3a3db089sm8589907pgc.11.2022.06.07.14.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 14:15:47 -0700 (PDT)
From:   Brian Norris <briannorris@chromium.org>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Sebastian Fricke <sebastian.fricke@collabora.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] arm64: dts: rockchip: Assign RK3399 VDU clock rate
Date:   Tue,  7 Jun 2022 14:15:36 -0700
Message-Id: <20220607141535.1.Idafe043ffc94756a69426ec68872db0645c5d6e2@changeid>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Before commit 9998943f6dfc ("media: rkvdec: Stop overclocking the
decoder"), the rkvdec driver was forcing the VDU clock rate. After that
commit, we rely on the default clock rate. That rate works OK on many
boards, with the default PLL settings (CPLL is 800MHz, VDU dividers
leave it at 400MHz); but some boards change PLL settings.

Assign the expected default clock rate explicitly, so that the rate is
consistent, regardless of PLL configuration.

This was particularly broken on RK3399 Gru Scarlet systems, where the
rk3399-gru-scarlet.dtsi assigns PLL_CPLL to 1.6 GHz, and so the VDU
clock ends up at 800 MHz (twice the expected rate), and causes video
artifacts and other issues.

Note: I assign the clock rate in the clock controller instead of the
vdec node, because there are multiple nodes that use this clock, and per
the clock.yaml specification:

  Configuring a clock's parent and rate through the device node that
  consumes the clock can be done only for clocks that have a single
  user. Specifying conflicting parent or rate configuration in multiple
  consumer nodes for a shared clock is forbidden.

  Configuration of common clocks, which affect multiple consumer devices
  can be similarly specified in the clock provider node.

Fixes: 9998943f6dfc ("media: rkvdec: Stop overclocking the decoder")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
This is a candidate for 5.19 IMO, since commit 9998943f6dfc landed in
5.19-rc1 and is being queued up for -stable as we speak.

 arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi | 4 +++-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi             | 6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
index 913d845eb51a..1977103a5ef4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet.dtsi
@@ -376,7 +376,8 @@ &cru {
 		<&cru ACLK_VIO>,
 		<&cru ACLK_GIC_PRE>,
 		<&cru PCLK_DDR>,
-		<&cru ACLK_HDCP>;
+		<&cru ACLK_HDCP>,
+		<&cru ACLK_VDU>;
 	assigned-clock-rates =
 		<600000000>, <1600000000>,
 		<1000000000>,
@@ -388,6 +389,7 @@ &cru {
 		<400000000>,
 		<200000000>,
 		<200000000>,
+		<400000000>,
 		<400000000>;
 };
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index fbd0346624e6..9d5b0e8c9cca 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1462,7 +1462,8 @@ cru: clock-controller@ff760000 {
 			<&cru HCLK_PERILP1>, <&cru PCLK_PERILP1>,
 			<&cru ACLK_VIO>, <&cru ACLK_HDCP>,
 			<&cru ACLK_GIC_PRE>,
-			<&cru PCLK_DDR>;
+			<&cru PCLK_DDR>,
+			<&cru ACLK_VDU>;
 		assigned-clock-rates =
 			 <594000000>,  <800000000>,
 			<1000000000>,
@@ -1473,7 +1474,8 @@ cru: clock-controller@ff760000 {
 			 <100000000>,   <50000000>,
 			 <400000000>, <400000000>,
 			 <200000000>,
-			 <200000000>;
+			 <200000000>,
+			 <400000000>;
 	};
 
 	grf: syscon@ff770000 {
-- 
2.36.1.255.ge46751e96f-goog

