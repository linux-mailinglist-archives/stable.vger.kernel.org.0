Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D03C3C9090
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236999AbhGNTzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:55:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241234AbhGNTu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FF0D613ED;
        Wed, 14 Jul 2021 19:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292045;
        bh=dpO5R1xchflP8vB9MiPUAHooMPT8cAsNlxyYoF+mAJU=;
        h=From:To:Cc:Subject:Date:From;
        b=igG7yfuxZgPct8hATpiVLEbpe0wf01AuyQgvfk4jpEcIlR+YXBpZdQF0M8klSS0Pc
         pHJvjc6iGHGGaADE/PsxKpdpNlaniE/cnV0/KIio+tua8jlCmuXZxwM1vjOov/1dWc
         xhO6/Z2pedRIPipY8gzxy/MuJ62/n0AD6uAniCPZD71LL7EYLnYviSJcWANCNkBQ24
         0ntYxsGwrcyR6hn3WY/D0LMZRvsiWii5I/xLX6//Db9BssQmz6Wynsdj4uRky9MC/o
         ApoaocCZYewrenT6WSXvPzBR0fLTbe7ntvmv+31sv4ezojARaNJZ3ZhDKTUETj49Wh
         uDPOKd5lyGMoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/28] ARM: dts: gemini: add device_type on pci
Date:   Wed, 14 Jul 2021 15:46:56 -0400
Message-Id: <20210714194723.55677-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corentin Labbe <clabbe@baylibre.com>

[ Upstream commit 483f3645b3f7acfd1c78a19d51b80c0656161974 ]

Fixes DT warning on pci node by adding the missing device_type.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/gemini.dtsi b/arch/arm/boot/dts/gemini.dtsi
index b9b07d0895cf..52c35bf816f0 100644
--- a/arch/arm/boot/dts/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini.dtsi
@@ -275,6 +275,7 @@ pci@50000000 {
 			clock-names = "PCLK", "PCICLK";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pci_default_pins>;
+			device_type = "pci";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			#interrupt-cells = <1>;
-- 
2.30.2

