Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AA5451F3D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355793AbhKPAik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344232AbhKOTYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F12163636;
        Mon, 15 Nov 2021 18:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002448;
        bh=QPAv+pnlnR8/JQUrSyaxyj0CGOv8mdSEsO2XRhRn57E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LECvO47sZJ7Y8jiP9FFBBUYdBUjL32CbV9dOkIgOq56Njfl7MU0sYMNAVGy3g3jQ5
         tnQVKpLnkN3gtGUyDX1bn+D/Kdu5JG/x+c0nUxO2AWchjq2k2a4gwGuGGJ7N+J1eBB
         T4IRRhB+71N2zwyDgkWuoXa730DZCtrbH9/dXCrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 571/917] arm64: dts: broadcom: bcm4908: Fix UART clock name
Date:   Mon, 15 Nov 2021 18:01:06 +0100
Message-Id: <20211115165448.141476667@linuxfoundation.org>
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

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 6c38c39ab2141f53786d73e706675e8819a3f2cb ]

According to the binding the correct clock name is "refclk".

Fixes: 2961f69f151c ("arm64: dts: broadcom: add BCM4908 and Asus GT-AC5300 early DTS files")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index a5a64d17d9ea6..f6b93bbb49228 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -292,7 +292,7 @@
 			reg = <0x640 0x18>;
 			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&periph_clk>;
-			clock-names = "periph";
+			clock-names = "refclk";
 			status = "okay";
 		};
 
-- 
2.33.0



