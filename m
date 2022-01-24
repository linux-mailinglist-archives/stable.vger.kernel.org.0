Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813C8499493
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358993AbiAXUnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388480AbiAXUjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:39:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46DEC02415F;
        Mon, 24 Jan 2022 11:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71C64B81142;
        Mon, 24 Jan 2022 19:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98DFAC340E5;
        Mon, 24 Jan 2022 19:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053872;
        bh=Jqatb1L8yQjhbQy9UNMVpIvmVrX+KciqGzLn7FtNWoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfJ54gJol/zKCsvdzAWIRbMdaYRaUq4WBox/TSB64PSVUu02H2vI+sE8BQeSXxfiN
         sxsCg3cGAPflfYuypp4MyxjYeJdj8fz5rq6UiimDLqZbiopMlBOrHvbfb7CqTFwXwz
         U6Hb5sFz8WgavAMloBEcx1GL3KfWwPtZ+m9ECILY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 177/563] arm64: dts: marvell: cn9130: add GPIO and SPI aliases
Date:   Mon, 24 Jan 2022 19:39:02 +0100
Message-Id: <20220124184030.536654813@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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



