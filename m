Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C975450E84
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbhKOSQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:16:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:50072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239431AbhKOSHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CCC0633A8;
        Mon, 15 Nov 2021 17:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998325;
        bh=jGL8/FxCHHhcBqMUVLx8jz6mtFdPIlHDc/aDqj+M9CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEMiaxrhzFyPS3mZicKYoXIVoeWNhlhO+W7YH88H/d6GNVWA6m8BiWck72MubmtoR
         6puCdQ4H1HeTUvjrny380ASFXQB1CqNRshdC9i33Gc6fucuqN9FoyYrSd4GMkjiowb
         dpWWgSTfl++vrliw2mrmRieB7ePKtIHCnrcEsYzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 436/575] ARM: dts: stm32: fix SAI sub nodes register range
Date:   Mon, 15 Nov 2021 18:02:41 +0100
Message-Id: <20211115165358.853291887@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 6f87a74d31277f0896dcf8c0850ec14bde03c423 ]

The STM32 SAI subblocks registers offsets are in the range
0x0004 (SAIx_CR1) to 0x0020 (SAIx_DR).
The corresponding range length is 0x20 instead of 0x1c.
Change reg property accordingly.

Fixes: 5afd65c3a060 ("ARM: dts: stm32: add sai support on stm32mp157c")

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp151.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp151.dtsi b/arch/arm/boot/dts/stm32mp151.dtsi
index b479016fef008..7a0ef01de969e 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -811,7 +811,7 @@
 				#sound-dai-cells = <0>;
 
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x4 0x1c>;
+				reg = <0x4 0x20>;
 				clocks = <&rcc SAI1_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 87 0x400 0x01>;
@@ -821,7 +821,7 @@
 			sai1b: audio-controller@4400a024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI1_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 88 0x400 0x01>;
@@ -842,7 +842,7 @@
 			sai2a: audio-controller@4400b004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x4 0x1c>;
+				reg = <0x4 0x20>;
 				clocks = <&rcc SAI2_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 89 0x400 0x01>;
@@ -852,7 +852,7 @@
 			sai2b: audio-controller@4400b024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI2_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 90 0x400 0x01>;
@@ -873,7 +873,7 @@
 			sai3a: audio-controller@4400c004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x04 0x1c>;
+				reg = <0x04 0x20>;
 				clocks = <&rcc SAI3_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 113 0x400 0x01>;
@@ -883,7 +883,7 @@
 			sai3b: audio-controller@4400c024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI3_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 114 0x400 0x01>;
@@ -1250,7 +1250,7 @@
 			sai4a: audio-controller@50027004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x04 0x1c>;
+				reg = <0x04 0x20>;
 				clocks = <&rcc SAI4_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 99 0x400 0x01>;
@@ -1260,7 +1260,7 @@
 			sai4b: audio-controller@50027024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI4_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 100 0x400 0x01>;
-- 
2.33.0



