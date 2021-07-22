Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70DCC3D29FC
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234494AbhGVQHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235093AbhGVQGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F87461D25;
        Thu, 22 Jul 2021 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972435;
        bh=GcFCwocmJf1fh/si+I6SLpT/vo6aBNZqWmMHtJtL8aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VcxvmPLKFZh1HBMdb8UsqIy7q0hikN/t/Zx6JTFm90aKr0K60TQicDswBvisiPs70
         ad0KIatVrlZ3UVZqdO9Cl8XG98P5FAyxjBOcfH0eYIuO85aa4FoDlqZtRFzP/xfF+y
         fDhVopDdzTwusyLuvsWpFSM4wiv5UcK1Rqx9TmH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 079/156] arm64: dts: imx8mn-beacon-som: Assign PMIC clock
Date:   Thu, 22 Jul 2021 18:30:54 +0200
Message-Id: <20210722155630.947914830@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 1de3aa8611d21d6be546ca1cd13ee05bdd650018 ]

The PMIC throws an errors because the clock isn't assigned to it.
Fix this by assigning the clocks info.

Signed-off-by: Adam Ford <aford173@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
index c35eeaff958f..54eaf3d6055b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn-beacon-som.dtsi
@@ -120,6 +120,9 @@
 		interrupt-parent = <&gpio1>;
 		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 		rohm,reset-snvs-powered;
+		#clock-cells = <0>;
+		clocks = <&osc_32k 0>;
+		clock-output-names = "clk-32k-out";
 
 		regulators {
 			buck1_reg: BUCK1 {
-- 
2.30.2



