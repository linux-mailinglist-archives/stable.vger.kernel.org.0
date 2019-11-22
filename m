Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC16106A15
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfKVKbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:31:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727430AbfKVKbo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:31:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD19D20714;
        Fri, 22 Nov 2019 10:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418704;
        bh=qDKjb23qMwMmQedUVQV3sCSnLpgnmjDuN8SzcUJWMbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybRq3Jnd/KQWcmW8gPYy7WGUkgNTNMOddsfxBi7MjiK25zemEpI15Kcyr7+bg78Ue
         zqX3xg1dr12CbW590Hn120WQBIPEfShYG2i3/+ZZE8E3d41tedaVX3c4faKRzViVLn
         hlejmJXpkylTlPWehvfy4cCUOmektzq/b080FKaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcel Ziswiler <marcel@ziswiler.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 023/159] ARM: dts: pxa: fix power i2c base address
Date:   Fri, 22 Nov 2019 11:26:54 +0100
Message-Id: <20191122100722.251945852@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel@ziswiler.com>

[ Upstream commit 8a1ecc01a473b75ab97be9b36f623e4551a6e9ae ]

There is one too many zeroes in the Power I2C base address. Fix this.

Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/pxa27x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/pxa27x.dtsi b/arch/arm/boot/dts/pxa27x.dtsi
index 210192c38df3c..4448505e34d3b 100644
--- a/arch/arm/boot/dts/pxa27x.dtsi
+++ b/arch/arm/boot/dts/pxa27x.dtsi
@@ -63,7 +63,7 @@
 			clocks = <&clks CLK_PWM1>;
 		};
 
-		pwri2c: i2c@40f000180 {
+		pwri2c: i2c@40f00180 {
 			compatible = "mrvl,pxa-i2c";
 			reg = <0x40f00180 0x24>;
 			interrupts = <6>;
-- 
2.20.1



