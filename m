Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091EF3D283B
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232715AbhGVPz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232565AbhGVPzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:55:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE0D76135A;
        Thu, 22 Jul 2021 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971770;
        bh=LVYjTKltne4pNqzUjWqaLAEQe5qia2wIDuOXmHLSYdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVs59H9HoN74nXcgfQiPEUkzDpcs2/8hXzCKcduge2ggFm0AIzPjoLssRdMtYBpal
         K2DfozWh5d01nTLogfZnGH+1Uh+cvbUdQi6g6rZxWmz84xCmmPEhAFJ9VlIHNJqpzZ
         HdQ1pF5rGua78fDUdEZk9H02HnW8XfzgoFRWO0iw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 002/125] ARM: dts: gemini: add device_type on pci
Date:   Thu, 22 Jul 2021 18:29:53 +0200
Message-Id: <20210722155624.752757277@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
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
index 065ed10a79fa..07448c03dac9 100644
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



