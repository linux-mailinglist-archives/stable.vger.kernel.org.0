Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9A364A11A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiLLNfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiLLNfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:35:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A6A13E31
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:35:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C68A61050
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FD7C433EF;
        Mon, 12 Dec 2022 13:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852100;
        bh=fWnF3oHZ5CoAgt7Q24i+W738kLt/F40OznHYZP1msPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0z2U0fdmGyYQnCNksFjC+TOIOHlQVgHbiLu/7J9KBHnHcRZxjBCSmW6Z0/ynyWGV
         Lmmj8UxSZmtx7vIsIMYldgWq3UryARMF4PPxOljqoz2XlD+TU8OnL/+XdB0Uf+p6ag
         n3vkx3DF1kCPoSB3kgsVZKMrAxpftxgx1+4pCb6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 011/157] arm64: dts: rockchip: fix adc-keys sub node names
Date:   Mon, 12 Dec 2022 14:15:59 +0100
Message-Id: <20221212130934.877797725@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit f2bd2e76d6ea13e12849975adae46145375532a4 ]

Fix adc-keys sub node names on Rockchip boards,
so that they match with regex: '^button-'

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/6a6a3603-5540-cacc-2672-c015af1ec684@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30-evb.dts            | 10 +++++-----
 arch/arm64/boot/dts/rockchip/rk3308-evb.dts          | 12 ++++++------
 arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts      |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts    |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts   |  2 +-
 arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts     |  4 ++--
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi      |  2 +-
 .../boot/dts/rockchip/rk3399-sapphire-excavator.dts  |  4 ++--
 arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi    |  2 +-
 10 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/px30-evb.dts b/arch/arm64/boot/dts/rockchip/px30-evb.dts
index 848bc39cf86a..4249b42843da 100644
--- a/arch/arm64/boot/dts/rockchip/px30-evb.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-evb.dts
@@ -30,31 +30,31 @@
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		esc-key {
+		button-esc {
 			label = "esc";
 			linux,code = <KEY_ESC>;
 			press-threshold-microvolt = <1310000>;
 		};
 
-		home-key {
+		button-home {
 			label = "home";
 			linux,code = <KEY_HOME>;
 			press-threshold-microvolt = <624000>;
 		};
 
-		menu-key {
+		button-menu {
 			label = "menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <987000>;
 		};
 
-		vol-down-key {
+		button-down {
 			label = "volume down";
 			linux,code = <KEY_VOLUMEDOWN>;
 			press-threshold-microvolt = <300000>;
 		};
 
-		vol-up-key {
+		button-up {
 			label = "volume up";
 			linux,code = <KEY_VOLUMEUP>;
 			press-threshold-microvolt = <17000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3308-evb.dts b/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
index 9fe9b0d11003..184b84fdde07 100644
--- a/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3308-evb.dts
@@ -23,7 +23,7 @@
 		poll-interval = <100>;
 		keyup-threshold-microvolt = <1800000>;
 
-		func-key {
+		button-func {
 			linux,code = <KEY_FN>;
 			label = "function";
 			press-threshold-microvolt = <18000>;
@@ -37,31 +37,31 @@
 		poll-interval = <100>;
 		keyup-threshold-microvolt = <1800000>;
 
-		esc-key {
+		button-esc {
 			linux,code = <KEY_MICMUTE>;
 			label = "micmute";
 			press-threshold-microvolt = <1130000>;
 		};
 
-		home-key {
+		button-home {
 			linux,code = <KEY_MODE>;
 			label = "mode";
 			press-threshold-microvolt = <901000>;
 		};
 
-		menu-key {
+		button-menu {
 			linux,code = <KEY_PLAY>;
 			label = "play";
 			press-threshold-microvolt = <624000>;
 		};
 
-		vol-down-key {
+		button-down {
 			linux,code = <KEY_VOLUMEDOWN>;
 			label = "volume down";
 			press-threshold-microvolt = <300000>;
 		};
 
-		vol-up-key {
+		button-up {
 			linux,code = <KEY_VOLUMEUP>;
 			label = "volume up";
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts b/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
index 43c928ac98f0..1deef53a4c94 100644
--- a/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3318-a95x-z2.dts
@@ -25,7 +25,7 @@
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <17000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
index 2a332763c35c..9d9297bc5f04 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-khadas-edge.dtsi
@@ -123,7 +123,7 @@
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts b/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
index 452728b82e42..3bf8f959e42c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopc-t4.dts
@@ -39,7 +39,7 @@
 		keyup-threshold-microvolt = <1800000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
index 72182c58cc46..65cb21837b0c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-nanopi-m4b.dts
@@ -19,7 +19,7 @@
 		keyup-threshold-microvolt = <1500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts b/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
index 9e2e246e0bab..dba4d03bfc2b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-orangepi.dts
@@ -52,13 +52,13 @@
 			press-threshold-microvolt = <300000>;
 		};
 
-		back {
+		button-back {
 			label = "Back";
 			linux,code = <KEY_BACK>;
 			press-threshold-microvolt = <985000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <1314000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
index acb174d3a8c5..4f3dd107e83e 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
@@ -41,7 +41,7 @@
 		keyup-threshold-microvolt = <1500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "Recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <18000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
index 13927e7d0724..dbec2b7173a0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire-excavator.dts
@@ -33,13 +33,13 @@
 			press-threshold-microvolt = <300000>;
 		};
 
-		back {
+		button-back {
 			label = "Back";
 			linux,code = <KEY_BACK>;
 			press-threshold-microvolt = <985000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <1314000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
index 0d45868132b9..8d61f824c12d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-pinenote.dtsi
@@ -23,7 +23,7 @@
 		io-channel-names = "buttons";
 		keyup-threshold-microvolt = <1750000>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <0>;
-- 
2.35.1



