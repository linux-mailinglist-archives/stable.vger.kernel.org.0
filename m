Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059343CDFF9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344402AbhGSPMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345200AbhGSPL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8563F61222;
        Mon, 19 Jul 2021 15:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709929;
        bh=jFFLxHcYne3t64ZVQ95C1TktoYV39YTxa4CLUK0vDHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RdaWZte/qA0n5+ET68JLIBI2/XbqDYaoCmZHaeFnli5DisV0lhQsTXbjiS128+Nyc
         tj9eD+ESfmF5JMyhlO0m/wzav1WoT11pubV53pwUS9Kd0jwnuPdFMF3JuJ25Tw/kBO
         gYwrVOQADvM1PIeF4nT1/sKMvLEeKGJNn7NX9TWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/149] ARM: dts: am437x: align ti,pindir-d0-out-d1-in property with dt-shema
Date:   Mon, 19 Jul 2021 16:54:03 +0200
Message-Id: <20210719144933.319955758@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 9b11fec7345f21995f4ea4bafb0e108b9a620238 ]

ti,pindir-d0-out-d1-in property is expected to be of type boolean.
Therefore, fix the property accordingly.

Fixes: b0b039515445 ("ARM: dts: am43x-epos-evm: set data pin directions for spi0 and spi1")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index a6fbc088daa8..a9f191d78b54 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -848,7 +848,7 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&spi0_pins_default>;
 	pinctrl-1 = <&spi0_pins_sleep>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 };
 
 &spi1 {
@@ -856,7 +856,7 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&spi1_pins_default>;
 	pinctrl-1 = <&spi1_pins_sleep>;
-	ti,pindir-d0-out-d1-in = <1>;
+	ti,pindir-d0-out-d1-in;
 };
 
 &usb2_phy1 {
-- 
2.30.2



