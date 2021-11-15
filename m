Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB57D450C22
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhKORfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:35:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238172AbhKORdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54F3B632B1;
        Mon, 15 Nov 2021 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996894;
        bh=mUO0coad183vli2ccJ2QFAPTuofMA4wMwRzWxHFTIFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDrbpDCjzrLRzlnR1ImfMrjFG5lDTP1siBZ+Em2ZpgFd/KS+bYx2cnj3uGl+wmrw8
         We5j8Io6R+4a8cXENoigXgbPJ4Jls3j1E1D5qUCPP6lC8E77Hzt4sYhVJQKlBc/hNs
         3Xp3elVIxZxBcLok90Yjbd3oldDngT5Eq8q04/SQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 279/355] ARM: dts: stm32: fix SAI sub nodes register range
Date:   Mon, 15 Nov 2021 18:03:23 +0100
Message-Id: <20211115165322.755783752@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
 arch/arm/boot/dts/stm32mp157c.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp157c.dtsi b/arch/arm/boot/dts/stm32mp157c.dtsi
index eca469a64a977..a687c024daa92 100644
--- a/arch/arm/boot/dts/stm32mp157c.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c.dtsi
@@ -773,7 +773,7 @@
 				#sound-dai-cells = <0>;
 
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x4 0x1c>;
+				reg = <0x4 0x20>;
 				clocks = <&rcc SAI1_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 87 0x400 0x01>;
@@ -783,7 +783,7 @@
 			sai1b: audio-controller@4400a024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI1_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 88 0x400 0x01>;
@@ -804,7 +804,7 @@
 			sai2a: audio-controller@4400b004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x4 0x1c>;
+				reg = <0x4 0x20>;
 				clocks = <&rcc SAI2_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 89 0x400 0x01>;
@@ -814,7 +814,7 @@
 			sai2b: audio-controller@4400b024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI2_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 90 0x400 0x01>;
@@ -835,7 +835,7 @@
 			sai3a: audio-controller@4400c004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x04 0x1c>;
+				reg = <0x04 0x20>;
 				clocks = <&rcc SAI3_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 113 0x400 0x01>;
@@ -845,7 +845,7 @@
 			sai3b: audio-controller@4400c024 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-b";
-				reg = <0x24 0x1c>;
+				reg = <0x24 0x20>;
 				clocks = <&rcc SAI3_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 114 0x400 0x01>;
@@ -1191,7 +1191,7 @@
 			sai4a: audio-controller@50027004 {
 				#sound-dai-cells = <0>;
 				compatible = "st,stm32-sai-sub-a";
-				reg = <0x04 0x1c>;
+				reg = <0x04 0x20>;
 				clocks = <&rcc SAI4_K>;
 				clock-names = "sai_ck";
 				dmas = <&dmamux1 99 0x400 0x01>;
@@ -1201,7 +1201,7 @@
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



