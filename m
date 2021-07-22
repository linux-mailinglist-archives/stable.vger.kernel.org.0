Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1B33D27C5
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhGVPwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230013AbhGVPwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:52:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15C5961364;
        Thu, 22 Jul 2021 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971595;
        bh=2FL072S8lSAcJr33e4kv7fAazzLgUF2ag4t7ijKNK9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CuuMSjEkme18sFbPlEyEh/n7NKuRpk/r5J47RS+nW9AoRVRAqYJ5Qo3wtm3fxpwlI
         tP7am2nQgc3QokufhssagK71wD6RhUlE9fK2veHWt3YdOH4jrfDZBNja+i4/qDB8Ns
         RwIGSYW8o/z4BzWkzX3T2kAghhWi7q5IxgBMkpXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/71] ARM: dts: stm32: fix RCC node name on stm32f429 MCU
Date:   Thu, 22 Jul 2021 18:31:00 +0200
Message-Id: <20210722155618.706742765@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Torgue <alexandre.torgue@foss.st.com>

[ Upstream commit e4b948415a89a219d13e454011cdcf9e63ecc529 ]

This prevent warning observed with "make dtbs_check W=1"

Warning (simple_bus_reg): /soc/rcc@40023810: simple-bus unit address format
error, expected "40023800"

Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32f429.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32f429.dtsi b/arch/arm/boot/dts/stm32f429.dtsi
index 5c8a826b3195..1476d3eaf6fa 100644
--- a/arch/arm/boot/dts/stm32f429.dtsi
+++ b/arch/arm/boot/dts/stm32f429.dtsi
@@ -696,7 +696,7 @@
 			status = "disabled";
 		};
 
-		rcc: rcc@40023810 {
+		rcc: rcc@40023800 {
 			#reset-cells = <1>;
 			#clock-cells = <2>;
 			compatible = "st,stm32f42xx-rcc", "st,stm32-rcc";
-- 
2.30.2



