Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA9F63AF0E
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 18:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbiK1Rhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 12:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiK1Rhs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 12:37:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4479C25D2;
        Mon, 28 Nov 2022 09:37:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5487612E3;
        Mon, 28 Nov 2022 17:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5D7C433D6;
        Mon, 28 Nov 2022 17:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669657067;
        bh=YyU7mChH0/BPR9SsGJGZjBDTLtDxjphLY+Vx4U7JK4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMHacSZkYMKzLJLTDLpWKVtTMUEKVWpwOv5Luca37JmzyVSBpEk21/7IT1BFqIxwD
         zGvY0KDzPWSZEruejvDDyOmwe5n2h84OpKIEv+pH56NSIFfMtsdEFa6w9UEDnXEFSj
         bwkNMwILduQE3ZrjP3gEOZXfDJnnquI3m01l5nAwQ4UUTTU4cZRrP74fGDxWqznURU
         6T3AVDVgGsiV8ojt76Bih2IOEj7xosPsz5gdC2S0+qXihnFYNN10SApos4dOKY82yE
         VvGm/w2peD2AtmqQ7NDJE9RK9V645NNujuRWWxFSGs197sm0zCBXhLalpYwuyurMtQ
         n6stN6JWDB3FA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 08/39] ARM: dts: rockchip: fix adc-keys sub node names
Date:   Mon, 28 Nov 2022 12:35:48 -0500
Message-Id: <20221128173642.1441232-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221128173642.1441232-1-sashal@kernel.org>
References: <20221128173642.1441232-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 942b35de22efeb4f9ded83f1ea7747f3fe5a3bb2 ]

Fix adc-keys sub node names on Rockchip boards,
so that they match with regex: '^button-'

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/7a0013b1-3a55-a344-e9ea-eacb4b49433c@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3066a-mk808.dts | 2 +-
 arch/arm/boot/dts/rk3288-evb.dtsi   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/rk3066a-mk808.dts b/arch/arm/boot/dts/rk3066a-mk808.dts
index cfa318a506eb..2db5ba706208 100644
--- a/arch/arm/boot/dts/rk3066a-mk808.dts
+++ b/arch/arm/boot/dts/rk3066a-mk808.dts
@@ -32,7 +32,7 @@ adc-keys {
 		keyup-threshold-microvolt = <2500000>;
 		poll-interval = <100>;
 
-		recovery {
+		button-recovery {
 			label = "recovery";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <0>;
diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
index 399d6b9c5fd4..382d2839cf47 100644
--- a/arch/arm/boot/dts/rk3288-evb.dtsi
+++ b/arch/arm/boot/dts/rk3288-evb.dtsi
@@ -28,19 +28,19 @@ button-down {
 			press-threshold-microvolt = <300000>;
 		};
 
-		menu {
+		button-menu {
 			label = "Menu";
 			linux,code = <KEY_MENU>;
 			press-threshold-microvolt = <640000>;
 		};
 
-		esc {
+		button-esc {
 			label = "Esc";
 			linux,code = <KEY_ESC>;
 			press-threshold-microvolt = <1000000>;
 		};
 
-		home  {
+		button-home  {
 			label = "Home";
 			linux,code = <KEY_HOME>;
 			press-threshold-microvolt = <1300000>;
-- 
2.35.1

