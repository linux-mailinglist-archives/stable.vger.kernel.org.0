Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2179549940C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351102AbiAXUie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385438AbiAXUdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F15C061778;
        Mon, 24 Jan 2022 11:44:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41BF6B811F9;
        Mon, 24 Jan 2022 19:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728DEC340E5;
        Mon, 24 Jan 2022 19:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053479;
        bh=pvYtC9heZmM5zQOv9q7on2eqOlXb2uSoAf+0nnGKKhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdHQX2LUybndc6dnFgiE+7H2H7Ciq7BC2CXBtdgpjmrbXOM+HnomuCJTXmcKMfLRL
         3sQsQfWv+UbLjQmcc+k8WVTPtoLhiJZpq7gYBSbhbk/h7Q1nyuxal50P5WEkXlaXxf
         bbMIgGkscT+5tYIifwzt3KKIv4uJsSDXLC4zOJx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Alexander Stein <alexander.stein@mailbox.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/563] arm64: dts: amlogic: Fix SPI NOR flash node name for ODROID N2/N2+
Date:   Mon, 24 Jan 2022 19:37:24 +0100
Message-Id: <20220124184027.122575755@linuxfoundation.org>
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
index 59b5f39088757..b9b8cd4b5ba9d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtsi
@@ -543,7 +543,7 @@
 	pinctrl-0 = <&nor_pins>;
 	pinctrl-names = "default";
 
-	mx25u64: spi-flash@0 {
+	mx25u64: flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		compatible = "mxicy,mx25u6435f", "jedec,spi-nor";
-- 
2.34.1



