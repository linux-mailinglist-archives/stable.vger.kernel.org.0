Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7263C8FBC
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241427AbhGNTxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240420AbhGNTtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CF396143B;
        Wed, 14 Jul 2021 19:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291917;
        bh=2/Ma+/5SmIHyyjOul5fg2PpMvA4eToWqw03g622bYV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyQt0T+lGCmDRb3cUS0WjcM41Qo0cYxaywIi0Maf6xMCAsdUeA1tEUn3HEN1JLloG
         8RW76XFrawmEBGNtyiN+U2kXV6G0Taydi54qcZzX6Lq5qxVxGxD/ZwPYu3fTSiGjji
         zRYTD/MppSMeyiUyNzguMAEi8ziroUXJZdSIT0neLxUJv+bBD7/k4KPk5N+Lxp6Cku
         qTKhMUxYh6uhIU5nz8ycStAvJXemX3114qM8mBJWamhGNAt4B0r/6ovq/lWn7Pywu/
         irqnaJVf8rSrIyr6em0N4HMGqYhM3jIQwodzrpMyAemvqQZbhDol/rNf0R6nKPj5oj
         O2cuMd/kmkhBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/51] ARM: dts: gemini: add device_type on pci
Date:   Wed, 14 Jul 2021 15:44:24 -0400
Message-Id: <20210714194513.54827-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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
index 8cf67b11751f..ef4f1c5323bd 100644
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

