Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C163C8C02
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhGNTk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230237AbhGNTk4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:40:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A231D613D1;
        Wed, 14 Jul 2021 19:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291484;
        bh=yALOl0UiSQkC3CuYYi8tHAy/WsG1GunY1vIUID0pJG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6BpAyKqIgIIwJ9FVVj64/uQwcOcqvQTcosxgz0cQ6gs2F6zG3GTMZpnmrU3KM8um
         rAEnea3vbEIpEkcD2Wc7mzy8S1SQOBOpOJkEyvRBsfF+NGe9IEiScunjqWFsEyzmZC
         H7wz6HpIvqPlytf4u3yF/fC2bGXhD2PkyywK2bIEYWA0/MWubGghVA58+TjHabTtzk
         sgp0uiOeC1vJWGyUicFUwwP7WtVX4NuazG75cE4+qS9pnOOgfzMcv6pqtLTthzSMJt
         nMD2jdIr9raaKbVzfvIXc+e9Olp6VGLd5Jp/dwayGt3kQ7lOmvnxDsK49pIy8VgzNx
         E48Iy/nQcw1IA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 002/108] ARM: dts: gemini: add device_type on pci
Date:   Wed, 14 Jul 2021 15:36:14 -0400
Message-Id: <20210714193800.52097-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
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
index 065ed10a79fa..07448c03dac9 100644
--- a/arch/arm/boot/dts/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini.dtsi
@@ -286,6 +286,7 @@ pci@50000000 {
 			clock-names = "PCLK", "PCICLK";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pci_default_pins>;
+			device_type = "pci";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			#interrupt-cells = <1>;
-- 
2.30.2

