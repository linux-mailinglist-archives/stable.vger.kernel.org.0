Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4E06AEDB9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjCGSGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjCGSGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:06:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5479EACE21
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB711B8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31776C433EF;
        Tue,  7 Mar 2023 17:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211965;
        bh=qDAmvfMHTiLeIfK1ZXd18D6vIUxfJi4F2NA3OvFS+Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrtTQaLc/rijKvNMK58Ho3ltbPCBs8D9jD2yifNk03aE0B8xbV7kLJ3195uSP2i80
         Pceby0SzJiEKpLhDZlVKjzR9GQdytdB0ilx6ME2mXs0r998Jd0Fu+TBNuYbiVPrfMF
         Gr863DILAkzsUjMm9pw1f6DIv8yymosgMpMWiDbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bryan Brattlof <bb@ti.com>,
        Dhruva Gole <d-gole@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/885] arm64: dts: ti: k3-am62-main: Fix clocks for McSPI
Date:   Tue,  7 Mar 2023 17:49:27 +0100
Message-Id: <20230307170003.107111643@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit 6be5d8e5d1804eb4cec29cd8a85dc9cb18683b5d ]

Fixes the clock Device ID's in the DT according to the tisci docs clock
identifiers for AM62x

Fixes: c37c58fdeb8a ("arm64: dts: ti: k3-am62: Add more peripheral nodes")
Reviewed-by: Bryan Brattlof <bb@ti.com>
Signed-off-by: Dhruva Gole <d-gole@ti.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20230103054840.1133711-1-d-gole@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
index 27b4034d0db2e..edcf6b2718814 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -306,7 +306,7 @@ main_spi0: spi@20100000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 141 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 172 0>;
+		clocks = <&k3_clks 141 0>;
 		status = "disabled";
 	};
 
@@ -317,7 +317,7 @@ main_spi1: spi@20110000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 142 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 173 0>;
+		clocks = <&k3_clks 142 0>;
 		status = "disabled";
 	};
 
@@ -328,7 +328,7 @@ main_spi2: spi@20120000 {
 		#address-cells = <1>;
 		#size-cells = <0>;
 		power-domains = <&k3_pds 143 TI_SCI_PD_EXCLUSIVE>;
-		clocks = <&k3_clks 174 0>;
+		clocks = <&k3_clks 143 0>;
 		status = "disabled";
 	};
 
-- 
2.39.2



