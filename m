Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D82415ECE3
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391672AbgBNRaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:30:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:59082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390712AbgBNQHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:07:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8677A2467E;
        Fri, 14 Feb 2020 16:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696455;
        bh=ScsIUI1jhlemcbd0HtcfRdTTAt1Fs26SJj8CgwW/VZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0duWHp31wHHiK4aOtyfGzLjxVAfWqWjBQwV0MKt0QOknjdZKnEBN14zdLeBCMPGDf
         vJ6/qhtvfmbEIcazs0AStyaTbA8kUE5AeyMOCZrwU2lt7dZS0AxuQMB98b3Q798BPP
         JeSqWPht4usZMhfii9qaYK0/LQk+xgfCTw81gPrs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Gaignard <benjamin.gaignard@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 267/459] ARM: dts: stm32: Add power-supply for DSI panel on stm32f469-disco
Date:   Fri, 14 Feb 2020 10:58:37 -0500
Message-Id: <20200214160149.11681-267-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Gaignard <benjamin.gaignard@st.com>

[ Upstream commit 0ff15a86d0c5a3f004fee2e92d65b88e56a3bc58 ]

Add a fixed regulator and use it as power supply for DSI panel.

Fixes: 18c8866266 ("ARM: dts: stm32: Add display support on stm32f469-disco")

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f469-disco.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/stm32f469-disco.dts b/arch/arm/boot/dts/stm32f469-disco.dts
index a3ff04940aec1..c6dc6d1a051b0 100644
--- a/arch/arm/boot/dts/stm32f469-disco.dts
+++ b/arch/arm/boot/dts/stm32f469-disco.dts
@@ -76,6 +76,13 @@
 		regulator-max-microvolt = <3300000>;
 	};
 
+	vdd_dsi: vdd-dsi {
+		compatible = "regulator-fixed";
+		regulator-name = "vdd_dsi";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+	};
+
 	soc {
 		dma-ranges = <0xc0000000 0x0 0x10000000>;
 	};
@@ -155,6 +162,7 @@
 		compatible = "orisetech,otm8009a";
 		reg = <0>; /* dsi virtual channel (0..3) */
 		reset-gpios = <&gpioh 7 GPIO_ACTIVE_LOW>;
+		power-supply = <&vdd_dsi>;
 		status = "okay";
 
 		port {
-- 
2.20.1

