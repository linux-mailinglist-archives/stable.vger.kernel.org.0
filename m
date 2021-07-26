Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375B23D5E12
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbhGZPFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:05:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236084AbhGZPFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E11DE60F38;
        Mon, 26 Jul 2021 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314333;
        bh=w3yQuzr/G+QH0QVyZgXCHetDDKhqkVPuLL2l65nV/vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A4C1Dftm5abtGbEf/bF0PK+CZujOZtkBKZvc2zOOB0jPwiuGD2uF1GAmcSkxexTEt
         huK8KnbGqwEOyJBmoxqPTcvkeoWJaOByBom0VPgWeP5XSqPD++SDjhG8wglT4dQ22j
         bN4vXvj/Ull7A4Zvc/zNwrV+fCmePRHmpzbssim0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/82] ARM: dts: gemini: add device_type on pci
Date:   Mon, 26 Jul 2021 17:38:01 +0200
Message-Id: <20210726153828.195001291@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
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
index b9b07d0895cf..52c35bf816f0 100644
--- a/arch/arm/boot/dts/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini.dtsi
@@ -275,6 +275,7 @@
 			clock-names = "PCLK", "PCICLK";
 			pinctrl-names = "default";
 			pinctrl-0 = <&pci_default_pins>;
+			device_type = "pci";
 			#address-cells = <3>;
 			#size-cells = <2>;
 			#interrupt-cells = <1>;
-- 
2.30.2



