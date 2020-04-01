Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDEB19AFFB
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbgDAQW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387550AbgDAQWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:22:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E4622137B;
        Wed,  1 Apr 2020 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758174;
        bh=LgPj8+2ycUOEbuzcx4Slc6l4LdVpqf9vUNx2DlNUndY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AU4vf8XgZFooSXLb+4i//KES++C82SRxRjGG+vSAuyRy6V9zlNI6aojRclq4dUBHM
         LqfExV+3dm+YAfO5mfP7hojbujk+mw2WJczIvWye//4AibwViRZgqSjr/n3z+eg1SC
         F4qCL8+luPfSmXjmzxmyEAi/zVwn2VMX7O3LIEBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 23/27] ARM: dts: imx6: phycore-som: fix arm and soc minimum voltage
Date:   Wed,  1 Apr 2020 18:17:51 +0200
Message-Id: <20200401161433.199490420@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.352722470@linuxfoundation.org>
References: <20200401161414.352722470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

commit 636b45b8efa91db05553840b6c0120d6fa6b94fa upstream.

The current set minimum voltage of 730000µV seems to be wrong. I don't
know the document which specifies that but the imx6qdl datasheets says
that the minimum voltage should be 0.925V for VDD_ARM (LDO bypassed,
lowest opp) and 1.15V for VDD_SOC (LDO bypassed, lowest opp).

Fixes: ddec5d1c0047 ("ARM: dts: imx6: Add initial support for phyCORE-i.MX 6 SOM")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-phytec-phycore-som.dtsi
@@ -107,14 +107,14 @@
 		regulators {
 			vdd_arm: buck1 {
 				regulator-name = "vdd_arm";
-				regulator-min-microvolt = <730000>;
+				regulator-min-microvolt = <925000>;
 				regulator-max-microvolt = <1380000>;
 				regulator-always-on;
 			};
 
 			vdd_soc: buck2 {
 				regulator-name = "vdd_soc";
-				regulator-min-microvolt = <730000>;
+				regulator-min-microvolt = <1150000>;
 				regulator-max-microvolt = <1380000>;
 				regulator-always-on;
 			};


