Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEDC451F23
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355683AbhKPAii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344404AbhKOTYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA2CE633CE;
        Mon, 15 Nov 2021 18:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002624;
        bh=yt5cx2WCFWtQQ6xKesorN/IvaQQz/K4+WBUdIcZo4DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYpMmFupwEmvA5i0qnfAliPVBWQViT4pgwqZYuPCob41fFtdTUjOBm38IUfuqfluq
         TZ/5iiyzVEycL34R93KUYmpjeY7H6PaO/8XW3vYHyuWIfBbKEOzNxU3AwnskjxRrmO
         HyMoc/XGWcW6sL31knVxFXZg5NX6pfpHm8/QLF/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 638/917] ARM: dts: stm32: fix SAI sub nodes register range
Date:   Mon, 15 Nov 2021 18:02:13 +0100
Message-Id: <20211115165450.461576701@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index bd289bf5d2690..6992a4b0ba79b 100644
--- a/arch/arm/boot/dts/stm32mp151.dtsi
+++ b/arch/arm/boot/dts/stm32mp151.dtsi
@@ -824,7 +824,7 @@
 				#sound-dai-cells = <0>;
 
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x4 0x1c>;
+				reg = <0x4 0x20>;
 				clocks = <&rcc SAI1_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 87 0x400 0x01>;
@@ -834,7 +834,7 @@
 			sai1b: audio-controller@4400a024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI1_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 88 0x400 0x01>;
@@ -855,7 +855,7 @@
 			sai2a: audio-controller@4400b004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x4 0x1c>;
+				reg = <0x4 0x20>;
 				clocks = <&rcc SAI2_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 89 0x400 0x01>;
@@ -865,7 +865,7 @@
 			sai2b: audio-controller@4400b024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI2_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 90 0x400 0x01>;
@@ -886,7 +886,7 @@
 			sai3a: audio-controller@4400c004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x04 0x1c>;
+				reg = <0x04 0x20>;
 				clocks = <&rcc SAI3_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 113 0x400 0x01>;
@@ -896,7 +896,7 @@
 			sai3b: audio-controller@4400c024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI3_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 114 0x400 0x01>;
@@ -1271,7 +1271,7 @@
 			sai4a: audio-controller@50027004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x04 0x1c>;
+				reg = <0x04 0x20>;
 				clocks = <&rcc SAI4_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 99 0x400 0x01>;
@@ -1281,7 +1281,7 @@
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



