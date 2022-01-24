Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AF349A023
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1458116AbiAXXEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345140AbiAXWzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:55:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F096C0680B7;
        Mon, 24 Jan 2022 13:09:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D1AB6146A;
        Mon, 24 Jan 2022 21:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24586C340E5;
        Mon, 24 Jan 2022 21:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058590;
        bh=Jqatb1L8yQjhbQy9UNMVpIvmVrX+KciqGzLn7FtNWoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjjAEDhMZU9NJJsPELHsE9+FQoAzHs39eJU7wJwSEDo/oV7smopqVGpCxogjpAaG4
         b/zSYjgNPrR24a+a37BkgR2A3dYTgkRYz/me1cqn3EJoM8AtogFagCGmoaH4nZdNlz
         3BOHXRxyPdaSAxGeyhtODuCTn9hCdzFVgIh9ke4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0305/1039] arm64: dts: marvell: cn9130: add GPIO and SPI aliases
Date:   Mon, 24 Jan 2022 19:34:54 +0100
Message-Id: <20220124184135.564908526@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit effd42600b987c1e95f946b14fefc1c7639e7439 ]

CN9130 has one CP115 built in, which like the CP110 has 2 GPIO and 2 SPI
controllers built-in.

However, unlike the Armada 7k and 8k the SoC DTSI doesn't add the required
aliases as both the Orion SPI driver and MVEBU GPIO drivers require the
aliases to be present.

So add the required aliases for GPIO and SPI controllers.

Fixes: 6b8970bd8d7a ("arm64: dts: marvell: Add support for Marvell CN9130 SoC support")

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/cn9130.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/cn9130.dtsi b/arch/arm64/boot/dts/marvell/cn9130.dtsi
index a2b7e5ec979d3..71769ac7f0585 100644
--- a/arch/arm64/boot/dts/marvell/cn9130.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130.dtsi
@@ -11,6 +11,13 @@
 	model = "Marvell Armada CN9130 SoC";
 	compatible = "marvell,cn9130", "marvell,armada-ap807-quad",
 		     "marvell,armada-ap807";
+
+	aliases {
+		gpio1 = &cp0_gpio1;
+		gpio2 = &cp0_gpio2;
+		spi1 = &cp0_spi0;
+		spi2 = &cp0_spi1;
+	};
 };
 
 /*
-- 
2.34.1



