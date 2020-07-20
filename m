Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D23C226627
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbgGTQAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732429AbgGTQAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:00:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8715B20684;
        Mon, 20 Jul 2020 16:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260844;
        bh=LorpaEKQ7nhoObZ9HTfrCrS8FOrlHSM8/j9dc66NydE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKkVVd3mImuGQHr1czBg1cszhGNMdGUrgattY1kJ8uwX5wobwpHAiYRVlzyhtHVRj
         lkPv6Vn70wUPL5kMZeyH/FMeKG7kY8vp2PGXD/dpXGD0W0nj087sigs0IxIBcPt0u4
         1DfXpKgsv7mV5nYkDXCguuVrQkjD0PAaqmKzwrp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/215] arm64: dts: spcfpga: Align GIC, NAND and UART nodenames with dtschema
Date:   Mon, 20 Jul 2020 17:36:38 +0200
Message-Id: <20200720152825.721813062@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 681a5c71fb829fc2193e3bb524af41525477f5c3 ]

Fix dtschema validator warnings like:
    intc@fffc1000: $nodename:0:
        'intc@fffc1000' does not match '^interrupt-controller(@[0-9a-f,]+)*$'

Fixes: 78cd6a9d8e15 ("arm64: dts: Add base stratix 10 dtsi")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
index d1fc9c2055f49..9498d1de730ce 100644
--- a/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
+++ b/arch/arm64/boot/dts/altera/socfpga_stratix10.dtsi
@@ -77,7 +77,7 @@ psci {
 		method = "smc";
 	};
 
-	intc: intc@fffc1000 {
+	intc: interrupt-controller@fffc1000 {
 		compatible = "arm,gic-400", "arm,cortex-a15-gic";
 		#interrupt-cells = <3>;
 		interrupt-controller;
@@ -302,7 +302,7 @@ mmc: dwmmc0@ff808000 {
 			status = "disabled";
 		};
 
-		nand: nand@ffb90000 {
+		nand: nand-controller@ffb90000 {
 			#address-cells = <1>;
 			#size-cells = <0>;
 			compatible = "altr,socfpga-denali-nand";
@@ -445,7 +445,7 @@ timer3: timer3@ffd00100 {
 			clock-names = "timer";
 		};
 
-		uart0: serial0@ffc02000 {
+		uart0: serial@ffc02000 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0xffc02000 0x100>;
 			interrupts = <0 108 4>;
@@ -456,7 +456,7 @@ uart0: serial0@ffc02000 {
 			status = "disabled";
 		};
 
-		uart1: serial1@ffc02100 {
+		uart1: serial@ffc02100 {
 			compatible = "snps,dw-apb-uart";
 			reg = <0xffc02100 0x100>;
 			interrupts = <0 109 4>;
-- 
2.25.1



