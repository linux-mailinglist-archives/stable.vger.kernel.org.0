Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EECB3C8E7B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbhGNTsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237998AbhGNTq6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:46:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E45EC600D4;
        Wed, 14 Jul 2021 19:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291787;
        bh=yALOl0UiSQkC3CuYYi8tHAy/WsG1GunY1vIUID0pJG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJ+Hda0pj8fCtEQouDFCvhmCTLNr1jeo1QQJtEqiiz7+flnvrRHOrMtHHBq0ThjHq
         EPwR9cpJOnAZXhxSkBjHq5g5pqWWBZ/SUzO7t9jERqoS3frmhw8HsEjOKbXWCCQMUV
         IoE6lqbYFE7pdvWo3/6xtRLHwsx/Nect60mSJctU07Ddv3I5nSSd+lGPg6rJ492n7+
         +T9819DsLYJUEid4kY3RFBy84DqzmhiOqEAd8BFKS94H1hH7qMa1Ej/g6LXpY6smCS
         +TP0zyo1oiX/kMvNbrv7bz561ZO4CjRI28+ZW6YKDvNLZVUFGUWDN4CC0grR2CoTL8
         EOE+NPCzdFzsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/88] ARM: dts: gemini: add device_type on pci
Date:   Wed, 14 Jul 2021 15:41:37 -0400
Message-Id: <20210714194303.54028-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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

