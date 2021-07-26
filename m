Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444B03D5EA5
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhGZPLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236528AbhGZPJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:09:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD50360F59;
        Mon, 26 Jul 2021 15:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314589;
        bh=TmGl2rybaSYiC+hIzGuvAo29R/MvPDfww6VyD3AbxQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIKtI2NGc+Zw8TvaKELaaQtjm+/DoXK2nfieH8d+7KNY5N17jBZOkCvCeAGP1yE8p
         +MjQB3259ydEpSUwW+AtE+63qqYM3PVdA5EZN28uGS//r4JDM6f6AtdtzNRDXTmHi5
         xyGYLLvEHhVnA3SqD2Sv8ErVMAc6iVi/guTkOIKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/120] ARM: dts: gemini: add device_type on pci
Date:   Mon, 26 Jul 2021 17:37:34 +0200
Message-Id: <20210726153832.422977135@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -286,6 +286,7 @@
 			clock-names = "PCLK", "PCICLK";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pci_default_pins>;
+			device_type = "pci";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			#interrupt-cells = <1>;
-- 
2.30.2



