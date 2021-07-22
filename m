Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5B23D29C3
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbhGVQGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234900AbhGVQFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:05:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E80D661363;
        Thu, 22 Jul 2021 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972347;
        bh=icmE0/xpmce9z6I8441lIcrQBtxWtI/KuYzOMJ/JTd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13x5Ik0VPyjoJct7v8zVCvSn1oLRpwerr33565k+CixlzJdcByKTFusaVqwHws4jL
         Oh8lzqytpZsjACdJn7Mofzz0bmwpsPcZMnw8bBNiaPR8sVwwUrB5jwFMTNOUgZg0D3
         F12LqCCSLg7MdZbCb35EStpSV/wPS5yy06g54NVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 033/156] ARM: dts: ux500: Fix orientation of Janice accelerometer
Date:   Thu, 22 Jul 2021 18:30:08 +0200
Message-Id: <20210722155629.481234649@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e409c1e1d5cb164361229e3a3f084e4a32544fb6 ]

This fixes up the axis on the Janice accelerometer to give
the right orientation according to tests.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ux500-samsung-janice.dts | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
index eaf8039d10ad..25af066f6f3a 100644
--- a/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
+++ b/arch/arm/boot/dts/ste-ux500-samsung-janice.dts
@@ -583,10 +583,9 @@
 					accelerometer@08 {
 						compatible = "bosch,bma222";
 						reg = <0x08>;
-						/* FIXME: no idea about this */
-						mount-matrix = "1", "0", "0",
-							       "0", "1", "0",
-							       "0", "0", "1";
+						mount-matrix = "0", "1", "0",
+							       "-1", "0", "0",
+							       "0", "0", "-1";
 						vddio-supply = <&ab8500_ldo_aux2_reg>; // 1.8V
 						vdd-supply = <&ab8500_ldo_aux1_reg>; // 3V
 					};
-- 
2.30.2



