Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1493C9026
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhGNTx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240960AbhGNTuQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E419261406;
        Wed, 14 Jul 2021 19:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291988;
        bh=QeIk8TBOXjeCTIFRQ/JBLrnwEdrCMM6+OpeAEx6CFuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOTc4WG5fEWCqKi/IUN8spPAD1i1Bk60VaDwX8tzKd9fzqvzOSSOVTvk2NqKj517D
         i3MT0Rt+R3Ua4JrOMu1gJlm9rlBoWBw/XPquCvkTclFq4snkd3Udf3KW3xmt6g2oYR
         SaULPIPOXeY3Ci7Q9rTgJJR1zNT2ifIWpnXhJEHZRNe4k2+vq9N1ylHrmi408EWsQQ
         nQi7Z1DGQc5Iw/UZ/+qKK8Pi6RtyjkdcIKypflW0PaU7SSBPe8CsHk7QJjDhsNr3OG
         5ZOYLyZfD4Om6XSjnM7IPIfW4mGjzAr+l+Eio21dlxQcwVkKb8iL0EN5bcBYSpue0M
         WXn2mps6BO9tQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/39] ARM: dts: gemini: add device_type on pci
Date:   Wed, 14 Jul 2021 15:45:47 -0400
Message-Id: <20210714194625.55303-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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
index eb752e9495de..4949951e3597 100644
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

