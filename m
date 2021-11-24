Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FE545C33B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349753AbhKXNg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:36:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348607AbhKXNeL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:34:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9B5F61B4C;
        Wed, 24 Nov 2021 12:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758455;
        bh=m49XzIzx/Jk3TbBc9EgjateyyuJWPMBrWon/YnhATGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MWzUDQ3gefKvmLw2GW9rrhgPJy6Iw/8rhEMVkBj5b4ErSJaPy7/3fVYed1JWMGot+
         Wvyof/BjM9ySJG6zWpkfz6K9Oi7SEo7d99eNpYfKOmreUxSsgqsaF+G2q/1qr1LTY9
         1h0VyThMWPotyY1BHn7iWYUKG+PSzgivHm/MqZiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/154] ARM: dts: qcom: fix memory and mdio nodes naming for RB3011
Date:   Wed, 24 Nov 2021 12:57:20 +0100
Message-Id: <20211124115703.770174206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 14a1f6c9d8017ffbf388e82e1a1f023196d98612 ]

Fixes warnings regarding to memory and mdio nodes and
apply new naming following dt-schema.

Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211020214741.261509-1-david@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
index 282b89ce3d451..33545cf40f3ab 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-rb3011.dts
@@ -19,12 +19,12 @@
 		stdout-path = "serial0:115200n8";
 	};
 
-	memory@0 {
+	memory@42000000 {
 		reg = <0x42000000 0x3e000000>;
 		device_type = "memory";
 	};
 
-	mdio0: mdio@0 {
+	mdio0: mdio-0 {
 		status = "okay";
 		compatible = "virtual,mdio-gpio";
 		gpios = <&qcom_pinmux 1 GPIO_ACTIVE_HIGH>,
@@ -91,7 +91,7 @@
 		};
 	};
 
-	mdio1: mdio@1 {
+	mdio1: mdio-1 {
 		status = "okay";
 		compatible = "virtual,mdio-gpio";
 		gpios = <&qcom_pinmux 11 GPIO_ACTIVE_HIGH>,
-- 
2.33.0



