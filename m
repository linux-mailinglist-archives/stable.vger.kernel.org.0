Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56D2499251
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381130AbiAXUS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:18:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55918 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380141AbiAXUPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:15:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71CB7B8122D;
        Mon, 24 Jan 2022 20:15:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11694C340E5;
        Mon, 24 Jan 2022 20:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055344;
        bh=DvUIF0aNMXcgNbPMQeVs2fhSNNBxIP9JkQsS3ZIdf7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfUwtwI7J0RgpvNEnrFpxuJlVkHBSPZkF+wINoehNQb5YpzQe9srV+wE979S1DULw
         IgUSfDqNw2j9O+L5oZLtU2WFVJrnc4a2dflB0ct1AHIyBmZCwWpFnc1oHQEx3RTkow
         WPUodMsLClywMsugNa/mEAGOzy7AOP4gc6hR2pLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Alexander Stein <alexander.stein@mailbox.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 121/846] arm64: dts: amlogic: Fix SPI NOR flash node name for ODROID N2/N2+
Date:   Mon, 24 Jan 2022 19:33:58 +0100
Message-Id: <20220124184105.145606130@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@mailbox.org>

[ Upstream commit 95d35256b564aca33fb661eac77dc94bfcffc8df ]

Fix the schema warning: "spi-flash@0: $nodename:0: 'spi-flash@0' does
 not match '^flash(@.*)?$'" from jedec,spi-nor.yaml

Fixes: a084eaf3096c ("arm64: dts: meson-g12b-odroid-n2: add SPIFC controller node")
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Alexander Stein <alexander.stein@mailbox.org>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/20211026182813.900775-3-alexander.stein@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
index 4f33820aba1f1..a84ed3578425e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
@@ -607,7 +607,7 @@
 	pinctrl-0 = <&nor_pins>;
 	pinctrl-names = "default";
 
-	mx25u64: spi-flash@0 {
+	mx25u64: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "mxicy,mx25u6435f", "jedec,spi-nor";
-- 
2.34.1



